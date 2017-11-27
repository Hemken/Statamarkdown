\docType{package}
\name{Statamarkdown-package}
\alias{Statamarkdown-package}
\alias{Statamarkdown}

\title{Settings and functions to extend the knitr Stata engine.}

\description{
Using the "Stata" language engine in \code{knitr} has a number of limitations.
Each Stata code chunk is run as a separate batch file, and source
code is part of the output returned to the document being knit.

??When used with chunk option \code{error=TRUE}, the user can see some
Stata errors automatically included in their document.

Another function here sets up a chunk hook, that repeats selected
code chunks
at the beginning of later code chunks.  This allows
the code in one chunk to use the results of a previous chunk.  See
\code{\link{stata_collectcode}}.
}

\references{
More documentation and examples:
\url{http://www.ssc.wisc.edu/~hemken/Stataworkshops/sas.html#writing-sas-documentation}
}
\seealso{
The package that this extends: \code{\link{knitr-package}}.
}
\author{
Doug Hemken
}
