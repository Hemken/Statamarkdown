
.onLoad <- function (libname, pkgname) {
    utils::globalVariables("hook_orig") # to suppress CHECK note
}

.onAttach <- function (libname, pkgname) {

  knitr::opts_chunk$set(engine="stata", #engine.path=stataexe,
                        error=TRUE, cleanlog=TRUE, comment=NA)

  stata_collectcode()

  assign("hook_orig", knitr::knit_hooks$get("output"), pos=2)
  # knitr::knit_hooks$set(output = Statamarkdown::stataoutputhook)
  knitr::knit_hooks$set(output = stataoutputhook)

}
