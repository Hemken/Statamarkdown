stataoutputhook <- function(x, options) {
    message(paste(options$engine, "output from", options$label))
    if (options$engine=="stata") {
      y <- strsplit(x, "\n")[[1]]
#      print(y)
      # # Remove "running profile.do"
      # running <- grep("^\\.?[[:space:]]?running[[:space:]].*profile.do", y)
      # if (length(running)>0) {y[running] <- sub("^\\.?[[:space:]]?running[[:space:]].*profile.do","", y[running])}
#      print("running removed")
#      print(y)
      # Remove command echo in Stata log
      if (length(options$cleanlog)==0 | options$cleanlog!=FALSE) {
        commandlines <- grep("^\\.[[:space:]]", y)
        if (length(commandlines)>0) {
          loopcommands <- grep("^[[:space:]][[:space:]][[:digit:]+]\\.", y)
          commandlines <- c(commandlines, loopcommands)
        }
        continuations <- grep("^>[[:space:]]", y)
        if (length(commandlines)>0 && length(continuations)>0) {
          for (i in 1:length(continuations)) {
            if ((continuations[i]-1) %in% commandlines) {
              commandlines <- c(commandlines, continuations[i])
            }
          }
        }
        if (length(commandlines)>0) {y <- y[-(commandlines)]}

        # Some commands have a leading space?
        if (length(grep("^[[:space:]*]\\.", y))>0) {
          y <- y[-(grep("^[[:space:]*]\\.", y))]
        }
      }
      # Ensure a trailing blank line
      if (length(y)>0 && y[length(y)] != "") { y <- c(y, "") }

      # Remove blank lines at the top of the Stata log
      firsttext <- min(grep("[[:alnum:]]", y))
      if (firsttext != Inf && firsttext != 1) {y <- y[-(1:(firsttext-1))]}
    } else {
      y <- x
    }
    # Now treat the result as regular output
    hook_orig(y, options)
}
