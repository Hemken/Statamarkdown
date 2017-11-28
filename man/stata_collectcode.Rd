\name{stata_collectcode}
\alias{stata_collectcode}
\title{
A function to create a knitr chunk hook for accumlating code.
}
\description{
This wrapper function calls \code{knitr::knit_hooks$set()} to
define a chunk hook.  When the chunk hook is later invoked, this
writes the contents of the current chunk to the end of a Stata
\code{profile.do} file.

This function is normally invoked when the Statamarkdown
package is loaded - you should not need to invoke it.
}
\usage{
stata_collectcode()
}
\details{
When knitr calls Stata, each code chunk is processed as a separate
Stata batch job.  Where code in one chunk depends upon the results
from a prevous chunk, code needs to be repeated and re-evaluated.

This function creates a knitr chunk hook that signals when one
chunk's code should be saved for re-use later.  The code is
temporarily placed in a Stata \code{profile.do} file.
}
\note{
If there is already an \file{profile.do} in the directory where
the document source is located, it will be used in addition
to the code you collect.
}
\value{
There are no return values, chunk hook creation is a side effect here..
}
\author{
Doug Hemken
}
\seealso{
\code{\link{Statamarkdown-package}}
}
\examples{
stata_collectcode()

\dontrun{
indoc <- '
---
title: "Basic Statamarkdown Doc"
author: "Doug Hemken"
output: html_document
---
# In a first code chunk, set up with
```{r}
require(Statamarkdown)

stataexe <- "C:/Program Files (x86)/Stata15/StataSE-64.exe"
```
# Then mark Stata code chunks with
```{r, engine="stata", engine.path=stataexe, collectcode=TRUE}
sysuse auto, clear
generate gpm = 1/mpg
summarize price gpm
```

# A later chunk that depends on the first.
```{r, engine="stata", engine.path=stataexe}
regress price gpm
```
'
knitr::knit(text=indoc, output="test.md")
rmarkdown::render("test.md")
}
}
