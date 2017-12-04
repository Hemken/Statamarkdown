find_stata <- function() {
  if (Sys.info()["sysname"]=="Windows"){
  stataexe <- NULL
  for (d in c("C:/Program Files","C:/Program Files (x86)")) {
    if (dir.exists(d)) {
      for (v in 11:15) {
        dv <- paste(d,paste0("Stata",v), sep="/")
        if (dir.exists(dv)) {
          for (f in c("Stata", "StataSE", "StataMP",
               "Stata-64", "StataSE-64", "StataMP-64")) {
            dvf <- paste(paste(dv, f, sep="/"), "exe", sep=".")
            if (file.exists(dvf)) {
              stataexe <- dvf
              message("Stata found at ", stataexe)
              break
            }
          }
        }
      }
    }
  }
} else if (Sys.info()["sysname"]=="Darwin") {
  stataexe <- NULL
  dv <- "/Applications/Stata/"
  if (dir.exists(d)) {
    for (f in c("Stata", "StataSE", "StataMP")) {
      dvf <- paste(paste(dv, f, sep="/"), "app", sep=".")
      if (file.exists(dvf)) {
        stataexe <- dvf
        message("Stata found at ", stataexe)
        break
      }
    }
  }
} else {
  message("Stata executable not found.\n Specify the location of your Stata executable.")
}
  return(stataexe)
}
