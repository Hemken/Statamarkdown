\name{find_stata}
\alias{find_stata}
\title{
A helper function that seeks to locate your Stata executable.
}
\description{
This function searches for recent versions of Stata (>= Stata 11),
in some of the usual default installation locations.

In the event Stata is not found, you will have to specify the
correct location yourself.

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
indoc <- '
# An R console example
## In a first code chunk, set up with
```{r}
library(Statamarkdown)
stataexe <- find_stata()
knitr::opts_chunk$set(engine="stata", #engine.path=stataexe,
  error=TRUE, cleanlog=TRUE, comment=NA)
```
## Then mark Stata code chunks with
```{r, engine="stata", engine.path=stataexe, collectcode=TRUE}
sysuse auto, clear
generate gpm = 1/mpg
summarize price gpm
```

## A later chunk that depends on the first.
```{r, engine="stata", engine.path=stataexe}
regress price gpm
```
'
# To run this example, remove tempdir().
fmd <- file.path(tempdir(), "test.md")
fhtml <- file.path(tempdir(), "test.html")

knitr::knit(text=indoc, output=fmd)
markdown::markdownToHTML(fmd, fhtml)
}
}
