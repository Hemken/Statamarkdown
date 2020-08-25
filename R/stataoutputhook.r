stataoutputhook <- function(x, options) {
    message(paste("\n", options$engine, "output from chunk", options$label))
# print("input to stataoutputhook")
# print(x)
    if (options$engine=="stata") {
      y <- strsplit(x, "\n")[[1]]
# print(y)
# Remove "running profile.do"
running <- grep("^\\.?[[:space:]]?[R|r]unning[[:space:]].*profile.do", y)
if (length(running)>0) {y[running] <- sub("^\\.?[[:space:]]?[R|r]unning[[:space:]].*profile.do","", y[running])}
     # print("running removed")
# print(y)
      # Remove command echo in Stata log
      if (length(options$cleanlog)==0 | options$cleanlog!=FALSE) {
        commandlines <- grep("^\\.[[:space:]]", y)
# print(commandlines)
        if (length(commandlines)>0) {
          # loopcommands <- grep("^[[:space:]][[:space:]][[:digit:]+]\\.", y)
          loopcommands <- grep("^[[:space:]]+[[:digit:]]+\\.", y)
          commandlines <- c(commandlines, loopcommands)
        }
# print(commandlines)
        continuations <- grep("^>[[:space:]]", y)
#        print(y[continuations])
        if (length(commandlines)>0 && length(continuations)>0) {
          for (i in 1:length(continuations)) {
            if ((continuations[i]-1) %in% commandlines) {
              commandlines <- c(commandlines, continuations[i])
            }
          }
        }
# print(commandlines)
# print(y[commandlines])
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
# print("from stataoutputhook")
# print(y)
# Now treat the result as regular output
    hook_orig(y, options)
}
