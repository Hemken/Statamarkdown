# Define a Stata engine for knitr

This function creates a modified Stata engine.

## Usage

``` r
stata_engine(options)
```

## Arguments

- options:

  Chunk options, passed to the engine function when it is actually
  invoked within knitr.

## Value

The language engine function returns Stata code and output internally to
knitr.

## Details

Set up once per session (i.e. document). Ordinarily this is run
automatically when Statamarkdown is loaded.

`stata_engine(options)` is a language engine that returns Stata log
output. The end user should not need to use the language engine function
directly. This is the workhorse function that actually calls Stata and
returns output.

## Including Stata graphs

Setting the chunk option `stata.fig=TRUE` exports the graph drawn by the
chunk (Stata's current graph) to a figure file, and includes it in the
output document. The figure is laid out by knitr's usual plot machinery,
so the standard figure chunk options apply, including `fig.cap` (the
figure caption), `fig.alt` (the alternative text, for accessibility;
falling back to `fig.cap` if unset), `out.width`, `out.height`,
`fig.align`, `fig.link` and `fig.path`.

The export format is controlled with the `stata.fig.format` chunk
option, and defaults to `"svg"`, which Stata can export on all platforms
in batch mode (including console Stata on Linux, which cannot export
PNG). For PDF/LaTeX output set, for example, `stata.fig.format="pdf"`.

The hyphenated option spellings `stata-fig` and `stata-fig-format` are
also accepted, matching Quarto's option naming convention (as in
`fig-cap` and `fig-alt`). These work in YAML-style option comments (`#|`
or `*|` lines at the start of the chunk, in either R Markdown or Quarto
documents), but not in the chunk header's comma-separated syntax, where
a hyphenated name is not valid R.

Note that knitr's `fig.width`, `fig.height` and `dpi` options control
R's graphics devices and have no effect on Stata graphs; set the graph
size in Stata, for example with the `xsize()` and `ysize()` options to
`graph display`. One graph is exported per chunk; to include several
graphs, draw them in separate chunks (using `collectcode=TRUE` to carry
the data over).

## See also

[knitr::knit_engines](https://rdrr.io/pkg/knitr/man/knit_engines.html)

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
