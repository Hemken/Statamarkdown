#' Convert a specially marked up Stata "do" file to Markdown and HTML
#'
#' This function takes a Stata file containing special markup in
#' its comments, and converts it to
#' Markdown and HTML documents (or one of several other formats).
#'
#' This function takes a Stata file containing special markup in
#' its comments, and converts it into knitr's "spin" format.
#' This is in turn sent to [knitr::spin()], and converted to
#' Markdown and HTML (or one of several other formats).
#'
#' Special Markup:
#' * `"/*' "` - Begin document text, ends with `"'*/"`
#' * `"/*+ "` - Begin chunk header, ends with `"+*/"`
#' * `"/*R "` - Begin a chunk of R code, ends with `"R*/"`
#' * `"/** "` - Dropped from document, ends with `"*/*"`
#'
#' Code in a chunk is taken to be Stata code, and the chunk header is
#' given the `engine='stata'` chunk option, unless the code is marked
#' as R code with the `"/*R ... R*/"` markup, or the chunk header sets
#' an `engine` option itself.  Writing `engine='stata'` in the chunk
#' headers of a "do" file is therefore no longer necessary, but it is
#' still honoured.
#'
#' With knitr >= 1.53, Stata is also used for code which is not
#' preceded by a chunk header at all, in a document which has no
#' chunks of R code.
#'
#' @param statafile A character string with the name of a Stata
#'   "do" file, containing markup in its comments.
#' @param text A character string in place of a file.
#' @param keep Whether to save intermediate files.
#' @param ... options passed to [knitr::spin()], for example
#'   `format` (the output format, such as `"Rmd"` or `"qmd"`), `knit`,
#'   `report` or `envir`.
#'
#' @return The path to the output file.
#'
#'   If given text instead of a file, returns the compiled document as a
#'   character string.
#'
#' @author Doug Hemken
#'
#' @seealso [knitr::spin()], [Statamarkdown-package]
#'
#' @export
#'
#' @examples
#' indoc <- "/*'
#' # Statamarkdown Example
#'
#' This is a special Stata script which can be used to generate a report.
#' You can write normal text in command-style comments.
#'
#' First we load Statamarkdown.
#' '*/
#'
#'   /*+  setup +*/
#'   /*R
#' library(Statamarkdown)
#' R*/
#'
#'   /*' The report begins here. '*/
#'
#'   /*+  example1 +*/
#'   sysuse auto
#' /* Stata comment */
#'   summarize
#'
#' /*' You can use the ***usual*** Markdown to mark up text.'*/
#' "
#' if (nzchar(Statamarkdown::find_stata(message = FALSE)) &&
#'     requireNamespace("markdown", quietly = TRUE)) {
#'   # To run this example, remove tempdir().
#'   fhtml <- file.path(tempdir(), "test.html")
#'   # Spin in a fresh R process, so that stale knitr state in a
#'   # long-running session (e.g. from RStudio's "Run examples" button)
#'   # cannot interfere with how the document text is parsed.
#'   x <- xfun::Rscript_call(
#'     function(indoc) Statamarkdown::spinstata(text = indoc),
#'     args = list(indoc)
#'   )
#'   writeLines(x, fhtml)
#'   message("HTML output created at: ", fhtml)
#'   if (interactive()) {
#'     # Show in the RStudio Viewer pane if available, otherwise the browser
#'     viewer <- getOption("viewer", default = utils::browseURL)
#'     viewer(fhtml)
#'   }
#' }
spinstata <- function(statafile, text=NULL, keep=FALSE, ...) {
    if (is.null(text)) {
        vtext <- readLines(statafile, warn=FALSE)
    } else {
        vtext <- unlist(strsplit(text, "\n"))
    }

    md_start    <- grepl(pattern="^[[:space:]]*/[*]['][[:space:]]*", x=vtext)    # markdown begins
    md_end      <- grepl(pattern="['][*]/[[:space:]]*$", x=vtext)                # markdown ends
    md_block    <- rep(0, length(vtext))
    md_block[1] <- md_block[1] + md_start[1]

    chunk_start <- grepl(pattern="^[[:space:]]*/[*][+][[:space:]]*", x=vtext)    # chunk begins
    chunk_end   <- grepl(pattern="[+][*]/[[:space:]]*$", x=vtext)                # chunk ends
    chunk_head  <- rep(0, length(vtext))
    chunk_head[1] <- chunk_head[1] + chunk_start[1]

    R_start    <- grepl(pattern="^[[:space:]]*/[*][R][[:space:]]*", x=vtext)    # R code begins
    R_end      <- grepl(pattern="[R][*]/[[:space:]]*$", x=vtext)                # R code ends
    R_code     <- rep(0, length(vtext))
    R_code[1]  <- R_code[1] + R_start[1]

    for (i in seq_along(vtext)[-1]) {
        md_block[i]   <- md_block[i-1]   + md_start[i]    - md_end[i-1]
        chunk_head[i] <- chunk_head[i-1] + chunk_start[i] - chunk_end[i-1]
        R_code[i]     <- R_code[i-1]     + R_start[i]     - R_end[i-1]
    }

    # Markdown (document)
    vtext[as.logical(md_start)] <- sub("^[[:space:]]*/[*]['][[:space:]]*", "", vtext[as.logical(md_start)])     # strip leading /*'
    vtext[as.logical(md_block)] <- paste("#' ", vtext[as.logical(md_block)])              # markdown lines
    vtext[as.logical(md_end)]   <- sub("['][*]/[[:space:]]*$", "", vtext[as.logical(md_end)])           # strip trailing "'*/"

    # Chunk header
    vtext[as.logical(chunk_start)] <- sub("^[[:space:]]*/[*][+][[:space:]]*", "#\\+ ", vtext[as.logical(chunk_start)])     # convert leading "*+" to "#+"
    vtext[as.logical(chunk_end)] <- sub("[+][*]/[[:space:]]*$", "", vtext[as.logical(chunk_end)])       # strip trailing ";"

    # R code
    vtext[as.logical(R_start)] <- sub("^[[:space:]]*/[*][R][[:space:]]*", "", vtext[as.logical(R_start)])    # convert leading "*R" to " "
    vtext[as.logical(R_end)] <- sub("[R][*]/[[:space:]]*$", "", vtext[as.logical(R_end)])               # strip trailing ";"

    # The "/*R ... R*/" markup holds R code; any other code in a chunk
    # is Stata, so give those chunk headers the engine option.  A chunk
    # header therefore need not repeat "engine='stata'", while a chunk
    # which sets an engine itself is left alone.
    breaks <- which(chunk_start | md_start)
    for (h in which(chunk_start & chunk_end)) {
        header <- sub("^#[+][[:space:]]*", "", vtext[h])
        if (!nzchar(header) || grepl("engine[[:space:]]*=", header)) next
        end <- c(breaks[breaks > h], length(vtext) + 1L)[1L] - 1L
        if (end <= h) next                       # a chunk with no code
        if (any(R_code[(h + 1L):end] > 0)) next  # a chunk of R code
        # trailing white space would otherwise end up inside the
        # chunk label, e.g. "#+ label , engine='stata'"
        vtext[h] <- paste0(sub("[[:space:]]+$", "", vtext[h]), ", engine='stata'")
    }

    # Fail early: compiling Markdown to HTML with knitr::knit2html(),
    # which knitr::spin() calls for the Rmd and qmd formats, needs the
    # markdown package, which knitr only suggests
    dots <- list(...)
    if ((is.null(dots$knit) || isTRUE(dots$knit)) &&
        (is.null(dots$report) || isTRUE(dots$report)) &&
        grepl("^[Rq]md$", if (is.null(dots$format)) "Rmd" else dots$format[1L]) &&
        !requireNamespace("markdown", quietly = TRUE))
        stop("The 'markdown' package is required to compile the document to HTML.\n",
             "  Please install it with install.packages('markdown').")

    args <- c(list(precious = keep,
                   comment = c("^/[*][*]", "^.*[*]/[*] *$")), dots)

    # knitr >= 1.53 can set the default engine for every chunk, which
    # also covers Stata code that is not preceded by a chunk header.
    # The fence language wins over an engine chunk option, so only do
    # this for a document which has no chunks of R code to protect.
    if (is.null(args$engine) && !any(R_code > 0) &&
        "engine" %in% names(formals(knitr::spin)))
        args$engine <- "stata"

    if (is.null(text)) {
        rfile <- sub("[.]do$", ".r", statafile, ignore.case=TRUE)
        if (rfile == statafile)
            stop("'statafile' must have a '.do' extension")

        writeLines(vtext, rfile)
        if (!keep)
            on.exit(unlink(rfile), add=TRUE)
        do.call(knitr::spin, c(list(rfile), args))
    } else {
        return(do.call(knitr::spin, c(list(text = vtext), args)))
    }

}
