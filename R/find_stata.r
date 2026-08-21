#' Locate the Stata executable
#'
#' A helper function that seeks to locate your Stata executable.
#' Ordinarily this is run automatically when \pkg{Statamarkdown} is loaded.
#'
#' This function searches for recent versions of Stata (>= Stata 11),
#' in some of the usual default installation locations.
#'
#' If Stata is not found, you will have to specify its
#' correct location yourself.
#'
#' @param message (logical) Whether or not to print messages: where
#'   Stata was found, or that no Stata executable could be found.
#'
#' @return A character string with the path and name of the Stata executable.
#'
#' @author Doug Hemken
#'
#' @seealso [Statamarkdown-package]
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
find_stata <- function(message=TRUE) {
  stataexe <- ""
  if (.Platform$OS.type == "windows"){
  for (d in c("C:/Program Files","C:/Program Files (x86)")) {
    if (stataexe=="" && dir.exists(d)) {
      for (v in seq(19,11,-1)) {
        for (dirstub in c("Stata", "StataNow")){
          dv <- paste(d, paste0(dirstub,v), sep="/")
          if (dir.exists(dv)) {
            for (f in c("Stata", "StataIC", "StataSE", "StataMP", "StataBE",
                        "Stata-64", "StataIC-64", "StataSE-64", "StataMP-64", "StataBE-64")) {
              dvf <- paste(paste(dv, f, sep="/"), "exe", sep=".")
              if (file.exists(dvf)) {
                stataexe <- dvf
                if (message) packageStartupMessage("Stata found at ", stataexe)
              }
              if (stataexe != "") break
              }
          }
          if (stataexe != "") break
        }
       if (stataexe != "") break
      }
    }
    if (stataexe != "") break
}
  } else if (Sys.info()["sysname"]=="Darwin") {
    dvstub <- c("/Applications/StataNow", "/Applications/Stata")
    for (dv in dvstub) {
    if (dir.exists(dv)) {
      for (f in c("Stata", "StataSE", "StataMP", "StataIC", "StataBE")) {
        dvf <- paste(paste(paste(dv, f, sep="/"), "app", sep="."), "Contents/MacOS", f, sep="/")
        if (file.exists(dvf)) {
          stataexe <- dvf
          if (message) packageStartupMessage("Stata found at ", stataexe)
        }
        if (stataexe != "") break
      }
    }
    if (stataexe != "") break
    }
  } else if (.Platform$OS.type == "unix") {
    for (f in c("stata-mp", "stata-se", "stata", "stata-ic")) {
      stataexe <- Sys.which(f)[[f]]
      if (stataexe != '') {
        if (message) packageStartupMessage("Stata found at ", stataexe)
      }
      else
        for (d in c("/software/stata", "/usr/local/sbin", "/usr/local/bin", "/usr/sbin",
                    "/usr/local/statanow19", "/usr/local/stata19", "/usr/local/stata", "/usr/local/stata18", "/usr/local/stata17", "/usr/local/stata16",
                    "/usr/local/stata15")) {
          df <- paste(d, f, sep="/")
          if (file.exists(df)) {
            stataexe <- df
            if (message) packageStartupMessage("Stata found at ", stataexe)
          }
          if (stataexe != "") break
        }
      if (stataexe != "") break
    }
  } else {
    message("Unrecognized operating system.")
  }
  if (stataexe!="") {
    knitr::opts_chunk$set(engine.path=list(stata=stataexe))
    # also cache the path for the whole session, since knitr restores
    # the engine.path chunk option when a knit finishes
    .statamarkdown$stataexe <- stataexe
  } else if (message) {
    packageStartupMessage("No Stata executable found.")
  }
  return(stataexe)
}
