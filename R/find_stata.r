find_stata <- function(message=TRUE) {
  stataexe <- ""
  if (.Platform$OS.type == "windows"){
#  stataexe <- NULL
  for (d in c("C:/Program Files","C:/Program Files (x86)")) {
    if (stataexe=="" & dir.exists(d)) {
      for (v in seq(16,11,-1)) {
        dv <- paste(d,paste0("Stata",v), sep="/")
        if (dir.exists(dv)) {
          for (f in c("Stata", "StataIC", "StataSE", "StataMP",
               "Stata-64", "StataIC-64", "StataSE-64", "StataMP-64")) {
            dvf <- paste(paste(dv, f, sep="/"), "exe", sep=".")
            if (file.exists(dvf)) {
              stataexe <- dvf
              if (message) message("Stata found at ", stataexe)
            }
            if (stataexe != "") break
          }
       }
       if (stataexe != "") break
      }
    }
    if (stataexe != "") break
  }
  } else if (Sys.info()["sysname"]=="Darwin") {
#    stataexe <- NULL
    dv <- "/Applications/Stata/"
    if (dir.exists(dv)) {
      for (f in c("Stata", "StataSE", "StataMP", "StataIC")) {
        dvf <- paste(paste(paste(dv, f, sep="/"), "app", sep="."), "Contents/MacOS", f, sep="/")
        if (file.exists(dvf)) {
          stataexe <- dvf
          if (message) message("Stata found at ", stataexe)
          break
        }
        if (stataexe != "") break
      }
    }
  } else if (.Platform$OS.type == "unix") {
#      stataexe <- NULL
      stataexe <- system2("which", "stata", stdout=TRUE)
      if (message) message("Stata found at ", stataexe)
  } else {
    message("Unrecognized operating system.")
  }
  if (stataexe!="") {
    knitr::opts_chunk$set(engine.path=list(stata=stataexe))
  } else {
    packageStartupMessage("No Stata executable found.")
  }
  return(stataexe)
}

