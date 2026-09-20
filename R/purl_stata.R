#' Extract Stata code from a dynamic document
#'
#' The Stata analogue of [knitr::purl()]: extracts the code from the
#' Stata code chunks of an R Markdown or Quarto document and writes it
#' to a Stata do-file.
#'
#' Chunks are recognised with knitr's own chunk patterns, so indented
#' chunks and fences of more than three backticks are handled.  A chunk
#' is extracted when its header engine is `stata`, or when it uses the
#' older `r` chunk form with an `engine = "stata"` option.  Chunks with
#' the `purl = FALSE` or `eval = FALSE` options (either in the chunk
#' header or in option comments) are skipped.  Option comments are
#' split from the code by [knitr::partition_chunk()], so the forms
#' knitr itself recognises are honoured: `*|` in a `stata` chunk and
#' `#|` in a chunk using the older `engine='stata'` form.  They are
#' never copied into the do-file as code, but with `documentation >= 1`
#' they are recorded as plain Stata comments below the chunk header
#' line.
#'
#' @param input A character string with the name of the input document.
#' @param output A character string with the name of the do-file to
#'   write.  Defaults to the name of the input document with its
#'   extension changed to `.do`.
#' @param text A character string with the document text to use in
#'   place of a file.
#' @param documentation How much documentation to carry into the
#'   do-file, following [knitr::purl()]: `0` (or `FALSE`) extracts the
#'   code only; `1` (or `TRUE`, the default) precedes the code of each
#'   chunk with a Stata comment giving the chunk's header (its label
#'   and options); `2` also includes the document's text as Stata
#'   comments (the code of non-Stata chunks is not included).
#'
#' @return If a do-file is written, the path to the do-file, invisibly.
#'   If `text` is given and `output` is `NULL`, a character vector of
#'   the extracted lines.
#'
#' @seealso [knitr::purl()], [Statamarkdown-package]
#'
#' @export
#'
#' @examples
#' indoc <- '
#' Some text.
#'
#' ```{r}
#' library(Statamarkdown)
#' ```
#'
#' ```{stata first-Stata, collectcode=TRUE}
#' sysuse auto, clear
#' generate gpm = 1/mpg
#' ```
#'
#' ```{stata second-Stata}
#' regress price gpm
#' ```
#' '
#' purl_stata(text = indoc)
purl_stata <- function(input, output = NULL, text = NULL, documentation = 1L) {
  doc <- if (isTRUE(documentation)) 1L else if (isFALSE(documentation)) 0L
    else documentation
  if (!(is.numeric(doc) && length(doc) == 1L && doc %in% 0:2))
    stop("'documentation' must be 0 (or FALSE), 1 (or TRUE), or 2")
  doc <- as.integer(doc)

  if (is.null(text)) {
    x <- xfun::read_utf8(input)
    if (is.null(output)) output <- xfun::with_ext(input, "do")
    if (identical(normalizePath(output, mustWork = FALSE),
                  normalizePath(input, mustWork = FALSE)))
      stop("'output' must be different from 'input'")
  } else {
    x <- xfun::split_lines(text)
  }

  pat <- knitr::all_patterns$md
  begin <- grep(pat$chunk.begin, x)
  end <- grep(pat$chunk.end, x)

  # document text as Stata comments, keeping blank lines blank
  comment_out <- function(lines) {
    ifelse(nzchar(trimws(lines)), paste("*", lines), lines)
  }

  res <- character()
  nstata <- 0L
  pos <- 0L
  for (b in begin) {
    if (b <= pos) next # inside the previous chunk
    e <- end[end > b][1L]
    if (is.na(e)) break # unclosed chunk
    if (doc >= 2L && b - pos > 1L) # the text between chunks
      res <- c(res, comment_out(x[(pos + 1L):(b - 1L)]))
    pos <- e

    # the chunk header: engine, label and options inside the braces
    header <- sub(pat$chunk.begin, "\\1", x[b])
    is_stata <- grepl("^stata([ ,].*)?$", header) ||
      # older syntax: an r chunk with the engine option set to stata
      grepl("^r[ ,].*engine\\s*=\\s*['\"]stata['\"]", header)
    if (!is_stata) next
    if (grepl("(purl|eval)\\s*=\\s*F(ALSE)?\\b", header)) next

    code <- if (e - b > 1L) x[(b + 1L):(e - 1L)] else character()
    # let knitr split the chunk's option comments from its code, so that
    # they are recognised and parsed exactly as they are when the
    # document is knitted: a "stata" fence takes "*|" comments, while
    # the older engine='stata' form has an "r" fence, taking "#|"
    parts <- knitr::partition_chunk(
      if (grepl("^stata([ ,].*)?$", header)) "stata" else "r", code)
    if (isFALSE(parts$options$purl) || isFALSE(parts$options$eval)) next
    opts <- parts$src
    code <- parts$code

    if (doc >= 1L) {
      # record the chunk options: the option comments become plain
      # Stata comments under the header line
      code <- c(paste0("* ---- ", header, " ----"),
                if (length(opts))
                  paste("*", trimws(sub("^[[:space:]]*[^|]*[|]", "", opts))),
                code)
    }
    nstata <- nstata + 1L
    res <- c(res, code, "")
  }
  if (doc >= 2L && pos < length(x)) # the text after the last chunk
    res <- c(res, comment_out(x[(pos + 1L):length(x)]))
  # drop a trailing blank line
  if (length(res) && !nzchar(res[length(res)])) res <- res[-length(res)]

  if (nstata == 0L) {
    warning("No Stata code chunks found in the document")
    return(invisible(character()))
  }

  if (is.null(output)) res else {
    xfun::write_utf8(res, output)
    invisible(output)
  }
}
