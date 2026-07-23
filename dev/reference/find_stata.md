# Locate the Stata executable

A helper function that seeks to locate your Stata executable. Ordinarily
this is run automatically when Statamarkdown is loaded.

## Usage

``` r
find_stata(message = TRUE)
```

## Arguments

- message:

  (logical) Whether or not to print a message when Stata is found.

## Value

A character string with the path and name of the Stata executable.

## Details

This function searches for recent versions of Stata (\>= Stata 11), in
some of the usual default installation locations.

If Stata is not found, you will have to specify its correct location
yourself.

## See also

[Statamarkdown-package](https://hemken.github.io/Statamarkdown/dev/reference/Statamarkdown-package.md)

## Author

Doug Hemken

## Examples

```` r
indoc <- '
# An R console example
## In a first code chunk, set up with
```{r}
library(Statamarkdown)
```

## Then mark Stata code chunks with
```{stata}
sysuse auto, clear
generate gpm = 1/mpg
summarize price gpm
```
'

if (nzchar(Statamarkdown::find_stata()) &&
    requireNamespace("rmarkdown", quietly = TRUE)) {
  # To run this example, remove tempdir().
  frmd <- file.path(tempdir(), "test.Rmd")
  fhtml <- file.path(tempdir(), "test.html")

  # Knit and render in a fresh R process, so that stale knitr state in a
  # long-running session (e.g. from RStudio's "Run examples" button)
  # cannot interfere with how the document text is parsed.
  xfun::Rscript_call(
    function(indoc, frmd, fhtml) {
      writeLines(indoc, frmd)
      rmarkdown::render(frmd, "html_document", fhtml)
    },
    args = list(indoc, frmd, fhtml)
  )
  message("HTML output created at: ", fhtml)
  if (interactive()) {
    # Show in the RStudio Viewer pane if available, otherwise the browser
    viewer <- getOption("viewer", default = utils::browseURL)
    viewer(fhtml)
  }
}
#> No Stata executable found.
````
