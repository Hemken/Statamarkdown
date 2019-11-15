
.onLoad <- function (libname, pkgname) {
    if (!requireNamespace("utils")) stop("Requires utils package.")
  # print(".onLoad")
  # print(utils::globalVariables())
    utils::globalVariables("hook_orig") # to suppress CHECK note
}

.onAttach <- function (libname, pkgname) {
#  if (!requireNamespace("knitr")) stop("Requires knitr package.")
  knitr::knit_engines$set(stata=stata_engine)
#  packageStartupMessage("Stata engine redefined")

  stataexe <- find_stata()
  if (stataexe!="") {
    knitr::opts_chunk$set(engine.path=list(stata=stataexe))
  } else {
    packageStartupMessage("No Stata executable found.")
  }
  knitr::opts_chunk$set(#engine="stata",
                        error=TRUE, cleanlog=TRUE, comment=NA)
#  packageStartupMessage("Chunk options optimized")

  stata_collectcode()
#  packageStartupMessage("collectcode option defined")

  assign("hook_orig", knitr::knit_hooks$get("output"), pos=2)
  knitr::knit_hooks$set(output = stataoutputhook)
#  packageStartupMessage("output for Stata redefined")

  if (stataexe!="") {
    packageStartupMessage("The 'stata' engine is ready to use.")
  }

}
