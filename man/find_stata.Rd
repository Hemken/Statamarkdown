\name{find_stata}
\alias{find_stata}
\title{
A helper function that seeks to locate your Stata executable.
Ordinarily this is run
automatically when \pkg{Statamarkdown} is loaded.
}
\description{
This function searches for recent versions of Stata (>= Stata 11),
in some of the usual default installation locations.

If Stata is not found, you will have to specify it's
correct location yourself.

}
\usage{
find_stata(message=TRUE)
}
\arguments{
\item{message}{(logical) Whether or not to print a message
when Stata is found.}
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

if (!is.null(Statamarkdown::find_stata())) {
  # To run this example, remove tempdir().
  fmd <- file.path(tempdir(), "test.md")
  fhtml <- file.path(tempdir(), "test.html")

  knitr::knit(text=indoc, output=fhtml)
  markdown::markdownToHTML(fmd, fhtml)
}
}

