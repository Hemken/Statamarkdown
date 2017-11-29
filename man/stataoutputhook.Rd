\name{stataoutputhook}
\alias{stataoutputhook}
\alias{hook_orig}
\title{
A function to provide cleaner output for knitr's Stata engine.
}
\description{
Stata returns output that is a mix of code and results.

This function filters the output by removing the Stata commands.
}
\usage{
stataoutputhook(x, options)
}
\arguments{
\item{x}{out object passed from the Stata engine.}
\item{options}{options object passed from the Stata engine.}
}

\details{
To disable removing Stata commands from the output, use
chunk option \code{cleanlog=FALSE}.

In the future more choice and nuance could be added here.

This function is normally used when the Statamarkdown package
is loaded, the user should not need to invoke this directly.
}
\value{
This returns a call to \code{knitr::engine_output}.
}
\author{
Doug Hemken
}
\seealso{
\code{\link{Statamarkdown}},

}
\examples{

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

# A later chunk that depends on the first, with unaltered output.
```{r, engine="stata", engine.path=stataexe, echo=FALSE, cleanlog=FALSE}
regress price gpm
```
'
knitr::knit(text=indoc, output="test.md")
rmarkdown::render("test.md")
}
}
