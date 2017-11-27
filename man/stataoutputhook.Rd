\name{stataoutputhook}
\alias{stataoutputhook}
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
In the future more choice and nuance could be added here.  
The user should not need to invoke this directly.
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
title: "Basic SASmarkdown Doc"
author: "Doug Hemken"
output: html_document
---
# In a first code chunk, set up with
```{r}
require(SASmarkdown)
sas_enginesetup(sashtml=sashtml)

sasexe <- "C:/Program Files/SASHome/SASFoundation/9.4/sas.exe"
sasopts <- "-nosplash -ls 75"
```
# Then set up SAS code chunks with
```{r, engine="sashtml", engine.path=sasexe, engine.opts=sasopts}
proc means data=sashelp.class;
run;
```
'
knitr::knit(text=indoc, output="test.md")
rmarkdown::render("test.md")
}
}
