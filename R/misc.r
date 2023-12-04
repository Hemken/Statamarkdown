# When the package loads
.onAttach <- function (libname, pkgname) {
  # Redfine the 'stata' engine
  knitr::knit_engines$set(stata=stata_engine)

  # Find the Stata executable
  stataexe <- find_stata()
  if (stataexe!="") {
    knitr::opts_chunk$set(engine.path=list(stata=stataexe))
  } else {
    packageStartupMessage("No Stata executable found.")
  }

  # Optimize chunk options
  knitr::opts_chunk$set(error=TRUE, cleanlog=TRUE, comment=NA, noisy=FALSE)

  # Hook to place collected chunk contents in a profile.do file
  stata_collectcode()

  packageStartupMessage("The 'stata' engine is ready to use.")
}
