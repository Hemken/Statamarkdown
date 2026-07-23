# Extract Stata code from a dynamic document

The Stata analogue of
[`knitr::purl()`](https://rdrr.io/pkg/knitr/man/knit.html): extracts the
code from the Stata code chunks of an R Markdown or Quarto document and
writes it to a Stata do-file.

## Usage

``` r
purl_stata(input, output = NULL, text = NULL, documentation = 1L)
```

## Arguments

- input:

  A character string with the name of the input document.

- output:

  A character string with the name of the do-file to write. Defaults to
  the name of the input document with its extension changed to `.do`.

- text:

  A character string with the document text to use in place of a file.

- documentation:

  How much documentation to carry into the do-file, following
  [`knitr::purl()`](https://rdrr.io/pkg/knitr/man/knit.html): `0` (or
  `FALSE`) extracts the code only; `1` (or `TRUE`, the default) precedes
  the code of each chunk with a Stata comment giving the chunk's header
  (its label and options); `2` also includes the document's text as
  Stata comments (the code of non-Stata chunks is not included).

## Value

If a do-file is written, the path to the do-file, invisibly. If `text`
is given and `output` is `NULL`, a character vector of the extracted
lines.

## Details

Chunks are recognised with knitr's own chunk patterns, so indented
chunks and fences of more than three backticks are handled. A chunk is
extracted when its header engine is `stata`, or when it uses the older
`r` chunk form with an `engine = "stata"` option. Chunks with the
`purl = FALSE` or `eval = FALSE` options (either in the chunk header or
in option comments) are skipped. Option comments in all the forms knitr
accepts in Stata chunks (`#|`, and the Stata comment-prefix forms `*|`
and `//|`) are recognised: they are never copied into the do-file as
code, but with `documentation >= 1` they are recorded as plain Stata
comments below the chunk header line.

## See also

[`knitr::purl()`](https://rdrr.io/pkg/knitr/man/knit.html),
[Statamarkdown-package](https://hemken.github.io/Statamarkdown/dev/reference/Statamarkdown-package.md)

## Examples

```` r
indoc <- '
Some text.

```{r}
library(Statamarkdown)
```

```{stata first-Stata, collectcode=TRUE}
sysuse auto, clear
generate gpm = 1/mpg
```

```{stata second-Stata}
regress price gpm
```
'
purl_stata(text = indoc)
#> [1] "* ---- stata first-Stata, collectcode=TRUE ----"
#> [2] "sysuse auto, clear"                             
#> [3] "generate gpm = 1/mpg"                           
#> [4] ""                                               
#> [5] "* ---- stata second-Stata ----"                 
#> [6] "regress price gpm"                              
````
