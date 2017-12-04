\name{find_stata}
\alias{find_stata}
\title{
A function that seeks to locate your Stata executable.
}
\description{
This function searches for recent versions of Stata (>= Stata 11),
in the usual default installation locations.

}
\usage{
find_stata()
}
\value{
A character string with the path and name of the Stata executable.
}
\author{
Doug Hemken
}
\seealso{
\code{\link{Statamarkdown-package}}
}
\examples{
\dontrun{
stata_collectcode()

indoc <- '
---
title: "Basic Statamarkdown Doc"
author: "Doug Hemken"
output: html_document
---
# In a first code chunk, set up with
```{r}
library(Statamarkdown)
stataexe <- find_stata()
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
