\name{stata_engine}
\alias{stata_engine}
\title{Define a Stata engine for knitr}
\description{
This function creates a modified Stata engine.

Set up once per session (i.e. document).  Ordinarily this is run
automatically when \pkg{Statamarkdown} is loaded.
}
\usage{
stata_engine(options)
}
\arguments{
\item{options}{\code{options} are passed to the engine
function when it
is actually invoked within \pkg{knitr}.}
}

\details{
This function is used as follows.

\itemize{
\item{
\code{stata_engine(options)}
is a language engine that returns Stata log output.}

The end user should not need to use the language engine
function directly.  This is the
workhorse function that actually calls Stata and returns output.
}
}

\value{
The language engine function returns Stata code
and output internally to \pkg{knitr}.

}
\author{
Doug Hemken
}

\seealso{
\code{\link{knit_engines}}
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
