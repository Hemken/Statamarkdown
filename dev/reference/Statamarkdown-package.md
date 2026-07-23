# Statamarkdown: Settings and functions to extend the knitr Stata engine

To use these functions and settings, attach the Statamarkdown library
from *within* the document to be `knit`. A typical preliminary code
chunk in a document would be

    ```{r setup, include=FALSE}
    library(Statamarkdown)
    ```

## Details

Using the "Stata" language engine in knitr has a number of limitations.
Each Stata code chunk is run as a separate batch file, and source code
is part of the output returned to the document being knit. This package
provides a language engine with code chunk options to overcome these
limitations.

Multiple documents can be rendered from the same script or R session;
the engine re-establishes the Stata executable path and the
`collectcode` hook for each document. (In versions upto 0.9.7 you had to
`detach("package:Statamarkdown")` in between documents.)

## Code Block (Chunk) Options

### Statamarkdown Chunk Options

#### collectcode (logical)

A function here sets up a chunk hook, that silently repeats selected
code chunks at the beginning of later code chunks. This allows the code
in one chunk to use the results of a previous chunk. The user marks code
chunks to be silently repeated with the chunk option `collectcode=TRUE`.

#### cleanlog (logical)

A second function here sets up an output hook. This removes Stata code
from the output by default. To leave Stata commands in the output,
specify the chunk option `cleanlog=FALSE`.

#### savedo (logical)

To save the code from a code block (as a "do" file) and also to save the
Stata log file produced by that code block, specify chunk option
`savedo=TRUE`. The filenames are the same as the chunk label.

### Knitr Chunk Options

#### eval (logical, numeric vector)

Whether or not to evaluate the code in the code block. Use `eval=FALSE`
to show code to the reader without having it evaluated.

Selective evaluation by specifying a numeric vector (as for R code
blocks) is also supported: the vector must be either all positive
(evaluate only these lines) or all negative (evaluate all but these
lines). Lines excluded from evaluation are commented out in the Stata
do-file.

#### include (logical)

Whether or not any trace of this code block appears in your document.
Use `include=FALSE` to evaluate code but suppress the source code echo
and all output (including error messages).

This is equivalent to
`eval=TRUE, echo=FALSE, results="hide", error=FALSE`.

#### echo (logical, numeric vector)

Whether or not to show the reader the source code. Use `echo=FALSE` to
suppress the source code in your document.

If this is specified as a numeric vector, it indicates which source
lines to show or suppress. For example, `echo=c(1,2)` shows only the
first two lines of the code block in the document (while still
evaluating the entire code block). Likewise, `echo=-1` hides just the
first line of code from the reader.

#### results (character)

To suppress normal output while still showing error messages use
`results="hide"`.

#### error (logical)

Whether or not to show error messages in your document. To suppress
error messages use `error=FALSE`.

Error messages that Stata writes to the log will appear as normal
output - they are not "errors" in this context. This option affects
error messages returned to/by the operating system.

#### comment (character)

A prefix to use before lines of output. The default for R output is
`comment="##"`

#### child (character)

Filename to be run and input in the document.

## References

More documentation and examples:
<https://www.ssc.wisc.edu/~hemken/Stataworkshops/stata.html#stata-and-r-markdown>

## See also

The package that this extends:
[knitr](https://rdrr.io/pkg/knitr/man/knitr-package.html).

## Author

**Maintainer**: Tom Palmer <remlapmot@hotmail.com>
([ORCID](https://orcid.org/0000-0003-4655-4511)) (MacOS, linux)

Authors:

- Tom Palmer <remlapmot@hotmail.com>
  ([ORCID](https://orcid.org/0000-0003-4655-4511)) (MacOS, linux)

- Doug Hemken <d_hemken@yahoo.com> (SSCC, Univ. of Wisconsin-Madison
  (retired))

Other contributors:

- Philipp Lepert \[contributor\]
