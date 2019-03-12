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
knitr::knit(text=indoc, output="test.md")
rmarkdown::render("test.md")
}
}
