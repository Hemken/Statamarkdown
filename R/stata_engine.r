#' Define a Stata engine for knitr
#'
#' This function creates a modified Stata engine.
#'
#' Set up once per session (i.e. document).  Ordinarily this is run
#' automatically when \pkg{Statamarkdown} is loaded.
#'
#' `stata_engine(options)` is a language engine that returns Stata
#' log output.  The end user should not need to use the language
#' engine function directly.  This is the workhorse function that
#' actually calls Stata and returns output.
#'
#' @section Including Stata graphs:
#'
#' Setting the chunk option `stata.fig=TRUE` exports the graph drawn
#' by the chunk (Stata's current graph) to a figure file, and includes
#' it in the output document.  The figure is laid out by knitr's
#' usual plot machinery, so the standard figure chunk options apply,
#' including `fig.cap` (the figure caption), `fig.alt` (the
#' alternative text, for accessibility; falling back to `fig.cap` if
#' unset), `out.width`, `out.height`, `fig.align`, `fig.link` and
#' `fig.path`.
#'
#' The export format is controlled with the `stata.fig.format` chunk
#' option, and defaults to `"svg"`, which Stata can export on all
#' platforms in batch mode (including console Stata on Linux, which
#' cannot export PNG).  For PDF/LaTeX output set, for example,
#' `stata.fig.format="pdf"`.
#'
#' The hyphenated option spellings `stata-fig` and `stata-fig-format`
#' are also accepted, matching Quarto's option naming convention (as
#' in `fig-cap` and `fig-alt`).  These work in YAML-style option
#' comments (`#|` or `*|` lines at the start of the chunk, in either
#' R Markdown or Quarto documents), but not in the chunk header's
#' comma-separated syntax, where a hyphenated name is not valid R.
#'
#' Note that knitr's `fig.width`, `fig.height` and `dpi` options
#' control R's graphics devices and have no effect on Stata graphs;
#' set the graph size in Stata, for example with the `xsize()` and
#' `ysize()` options to `graph display`.  One graph is exported per
#' chunk; to include several graphs, draw them in separate chunks
#' (using `collectcode=TRUE` to carry the data over).
#'
#' @param options Chunk options, passed to the engine function
#'   when it is actually invoked within \pkg{knitr}.
#'
#' @return The language engine function returns Stata code
#'   and output internally to \pkg{knitr}.
#'
#' @author Doug Hemken
#'
#' @seealso [knitr::knit_engines]
#'
#' @export
#'
#' @examples
#' indoc <- '
#' # An R console example
#' ## In a first code chunk, set up with
#' ```{r}
#' library(Statamarkdown)
#' ```
#'
#' ## Then mark Stata code chunks with
#' ```{stata}
#' sysuse auto, clear
#' generate gpm = 1/mpg
#' summarize price gpm
#' ```
#' '
#'
#' if (nzchar(Statamarkdown::find_stata(message = FALSE)) &&
#'     requireNamespace("rmarkdown", quietly = TRUE)) {
#'   # To run this example, remove tempdir().
#'   frmd <- file.path(tempdir(), "test.Rmd")
#'   fhtml <- file.path(tempdir(), "test.html")
#'
#'   # Knit and render in a fresh R process, so that stale knitr state in a
#'   # long-running session (e.g. from RStudio's "Run examples" button)
#'   # cannot interfere with how the document text is parsed.
#'   xfun::Rscript_call(
#'     function(indoc, frmd, fhtml) {
#'       writeLines(indoc, frmd)
#'       rmarkdown::render(frmd, "html_document", fhtml)
#'     },
#'     args = list(indoc, frmd, fhtml)
#'   )
#'   message("HTML output created at: ", fhtml)
#'   if (interactive()) {
#'     # Show in the RStudio Viewer pane if available, otherwise the browser
#'     viewer <- getOption("viewer", default = utils::browseURL)
#'     viewer(fhtml)
#'   }
#' }
stata_engine <- function (options)
{
  # knitr restores the knit hooks when a knit finishes, so in the
  # second document knitted in one R session the collectcode hook
  # registered when the package was attached is gone; re-register it
  # (the hook acts after the chunk, so this is early enough even for
  # the current chunk)
  if (is.null(knitr::knit_hooks$get("collectcode")) &&
      !is.null(.statamarkdown$stataexe)) {
    stata_collectcode(.statamarkdown$stataexe)
  }

  code <- {
    if (is.null(options$savedo) || options$savedo==FALSE) {
      f <- basename(tempfile(pattern="stata", tmpdir=".", fileext=".do"))
      on.exit(unlink(f), add = TRUE)
    } else {
      f <- basename(paste0(options$label, ".do"))
    }
    if (is.numeric(options$eval)) {
      if (all(options$eval < 0)) {
        pre <- rep("", length(options$code))
        pre[abs(options$eval)] <- "* "
      } else if (all(options$eval > 0)) {
        pre <- rep("* ", length(options$code))
        pre[abs(options$eval)] <- ""
      } else {
        message("eval option must be all negative or positive")
        pre <- rep("", length(options$code))
      }
      options$code <- paste0(pre, options$code)
    }

    # Optionally export the chunk's (current) Stata graph to a figure
    # file, to be included in the output document (issue #28).
    # knitr only normalises the names of its own options, so accept
    # both the dotted spelling (stata.fig) and the hyphenated spelling
    # used in Quarto documents (stata-fig)
    stata_fig <- function(name) {
      v <- options[[name]]
      if (is.null(v)) v <- options[[gsub(".", "-", name, fixed = TRUE)]]
      v
    }
    fig <- NULL
    dofile <- options$code
    if (isTRUE(stata_fig("stata.fig"))) {
      ext <- if (is.null(stata_fig("stata.fig.format"))) "svg" else stata_fig("stata.fig.format")
      fig <- knitr::fig_path(paste0(".", ext), options, number = 1L)
      dir.create(dirname(fig), recursive = TRUE, showWarnings = FALSE)
      # remove any figure left over from a previous knit, so a failed
      # export cannot silently include a stale image
      unlink(fig)
      # 'capture' so that a chunk which turns out not to produce a
      # graph does not abort the do-file; the missing figure file is
      # then reported below
      dofile <- c(dofile, paste0("capture graph export \"", fig, "\", replace"))
    }
    writeLines(dofile, f)


    logf = sub("[.]do$", ".log", f)
    if (is.null(options$savedo) || options$savedo==FALSE)
      on.exit(unlink(logf), add = TRUE)
    sysname <- Sys.info()[["sysname"]]
    paste(switch(sysname,
                 Windows = "/q /e do",
                 Darwin = "-q -e do",
                 Linux = "-q -b do",
                 "-q -b do"),
          switch(sysname,
                 Windows = shQuote(normalizePath(f)),
                 Darwin = paste0("\'\"", normalizePath(f), "\"\'"),
                 Linux  = paste0("\'\"", normalizePath(f), "\"\'"),
                 shQuote(normalizePath(f))))
  }

  if (is.list(options$engine.opts)) {
    code = paste(options$engine.opts[[options$engine]], code, options$doargs)
  } else { # backwards compatibility
    code = paste(options$engine.opts, code, options$doargs)
  }

  cmd = if (is.list(options$engine.path)) {
    options$engine.path[[options$engine]]
  } else { # backwards compatibility
    options$engine.path
  }
  if (is.null(cmd) || !nzchar(cmd)) {
    # The engine.path chunk option is set when the package is attached,
    # but knitr restores chunk options when a knit finishes -- so in the
    # second document rendered in one R session the option is unset
    # again.  Fall back to the executable located at attach time, which
    # is cached for the whole session.
    cmd <- .statamarkdown$stataexe
  }
  if (is.null(cmd) || !nzchar(cmd)) {
    stop("No Stata executable is set. Either none was found when ",
         "Statamarkdown was attached, or the engine.path chunk option ",
         "has been unset; see ?find_stata.")
  }

  out = if (!all(options$eval==FALSE)) {
    if (!is.null(options$noisy) && options$noisy==TRUE) message("running: ", cmd, " ", code)
    tryCatch(system2(cmd, code, stdout = TRUE, stderr = TRUE,
                     env = options$engine.env), error = function(e) {
                       if (!options$error)
                         stop(e)
                       paste("Error in running command", cmd)
                     })
  }
  else ""
  if (!options$error && !is.null(attr(out, "status")))
    stop(paste(out, collapse = "\n"))
  if (!all(options$eval==FALSE) && options$engine == "stata" && file.exists(logf))
    out = c(readLines(logf), out)

  # Include the exported graph through the active output format's plot
  # hook, so that the usual figure chunk options (fig.cap, fig.alt,
  # out.width, out.height, fig.align, fig.link, ...) are honoured
  extra <- NULL
  if (!is.null(fig) && !all(options$eval==FALSE) &&
      !identical(options$fig.show, "hide")) {
    if (file.exists(fig)) {
      options$fig.num <- 1L
      options$fig.cur <- 1L
      extra <- (knitr::knit_hooks$get("plot"))(fig, options)
    } else {
      message("stata.fig=TRUE but chunk '", options$label,
              "' did not export a graph")
    }
  }
  engine_output(options, options$code, out, extra)
}
