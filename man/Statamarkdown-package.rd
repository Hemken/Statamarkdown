\docType{package}
\name{Statamarkdown-package}
\alias{Statamarkdown-package}
\alias{Statamarkdown}
\alias{hook_orig}

\title{Settings and functions to extend the knitr Stata engine.}

\description{
To use these functions and settings, attach the \pkg{Statamarkdown}
library from \emph{within} the document to be \code{knit}.  A
typical preliminary code check in a document would be

\preformatted{
    ```{r setup, include=FALSE}
    library(Statamarkdown)
    ```
}

Using the "Stata" language engine in \pkg{knitr} has a number of limitations.
Each Stata code chunk is run as a separate batch file, and source
code is part of the output returned to the document being knit.
This package provides a language engine with code chunk options
to overcome these limitations.

If you render multiple documents from the same script or R session,
you should \code{detach("Statamarkdown")} in between documents.
}

\section{Code Block (Chunk) Options}{
\subsection{Statamarkdown Chunk Options}{
\subsection{collectcode: (logical)}{
A function here sets up a chunk hook, that silently repeats selected
code chunks
at the beginning of later code chunks.  This allows
the code in one chunk to use the results of a previous chunk.  The
user marks code chunks to be silently repeated with the
chunk option \code{collectcode=TRUE}.
}
\subsection{cleanlog: (logical)}{
A second function here sets up an output hook.  This removes Stata
code from the output by default.  To leave Stata commands in the
output, specify the chunk option \code{cleanlog=FALSE}.
}
\subsection{savedo: (logical)}{To save the code from a code block (as a
"do" file) and also to save the Stata log file produced by
that code block, specify chunk option \code{savedo=TRUE}.  The filenames
are the same as the chunk label.
}
}

\subsection{Knitr Chunk Options}{
\subsection{eval: (logical)}{Whether or not to evaluate
the code in the code block.  Use \code{eval=FALSE} to show
code to the reader without having it evaluated.

Selective evaluation by specifying a numeric vector (an option
for R code blocks) does \emph{not} work for Stata.
}
\subsection{include: (logical)}{Whether or not any trace
of this code block appears in your document.  Use \code{include=FALSE}
to evaluate code but suppress the source code echo and all
output (including error messages).

This is equivalent to \code{eval=TRUE, echo=FALSE, results="hide", error=FALSE}.
}
\subsection{echo: (logical, numeric vector)}{Whether or not
to show the reader the source code. Use \code{echo=FALSE} to
suppress the source code in your document.

If this is specified as
a numeric vector, it indicates which source lines to show
or suppress.  For example, \code{echo=c(1,2)} shows only the
first two lines of the code block in the document (while still
evaluating the entire code block).  Likewise, \code{echo=-1} hides
just the first line of code from the reader.
}
\subsection{results: (character)}{To suppress
normal output while still showing error messages
use \code{results="hide"}.
}
\subsection{error: (logical)}{Whether or not to show error
messages in your document.  To suppress error messages use
\code{error=FALSE}.

Error messages that Stata writes to the log will appear as normal
output - they are not "errors" in this context.  This option
affects error messages returned to/by the operating system.
}
\subsection{comment: (character)}{A prefix to use before
lines of output.  The default for R output is \code{comment="##"}
}
\subsection{child: (character)}{Filename to be run and input
in the document.
}
}
}

\references{
More documentation and examples:
\url{https://www.ssc.wisc.edu/~hemken/Stataworkshops/stata.html#stata-and-r-markdown}
}
\seealso{
The package that this extends: \pkg{\link[knitr:knitr-package]{knitr-package}}.
}
\author{
Doug Hemken
}
