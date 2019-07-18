stataoutputhook <- function(x, options) {
  message(paste(options$engine, "output from", options$label))
  if (options$engine=="stata") {
    x = paste(x, collapse = "\n")
    y <- strsplit(x, "\n")[[1]]
    #      print(y)
    # # Remove "running profile.do"
    running <- grep("^\\.?[[:space:]]?running[[:space:]].*profile.do.*", y)
    rm_profile = options$remove_profile
    if (is.null(rm_profile)) {
      rm_profile = FALSE
    }
    if (is.null(options$remove_empty_lines)) {
      options$remove_empty_lines = FALSE
    }
    if (options$remove_empty_lines) {
      message("removing empty lines")
      y = y[ y != "" ]
    }

    if (rm_profile) {
      message("removing profile")
      if (length(running) > 0) {
        y[running] <- sub("^\\.?[[:space:]]?running[[:space:]].*profile.do.*","",
                          y[running])
      }
    }
    #      print("running removed")
    # print(y)
    # Remove command echo in Stata log
    if (length(options$cleanlog)==0 | options$cleanlog!=FALSE) {
      message("cleaning the log")

      commandlines <- grep("^\\.[[:space:]]", y)
      # print(commandlines)
      if (length(commandlines)>0) {
        # loopcommands <- grep("^[[:space:]][[:space:]][[:digit:]+]\\.", y)
        loopcommands <- grep("^[[:space:]]+[[:digit:]]+\\.", y)
        commandlines <- c(commandlines, loopcommands)
      }
      # print(commandlines)
      continuations <- grep("^>[[:space:]]", y)
      print(y[continuations])
      if (length(commandlines)>0 && length(continuations)>0) {
        for (i in 1:length(continuations)) {
          if ((continuations[i]-1) %in% commandlines) {
            commandlines <- c(commandlines, continuations[i])
          }
        }
      }
      # print(commandlines)
      # print(y[commandlines])
      if (length(commandlines)>0) {
        message("removing command lines")
        y <- y[-(commandlines)]
      }

      # Some commands have a leading space?

      if (length(grep("^[[:space:]*]\\.", y))>0) {
        message("removing leading spaces")
        y <- y[-(grep("^[[:space:]*]\\.", y))]
      }
    }
    # Ensure a trailing blank line
    if (length(y)>0 && y[length(y)] != "") { y <- c(y, "") }

    # Remove blank lines at the top of the Stata log
    firsttext <- min(grep("[[:alnum:]]", y))
    if (firsttext != Inf && firsttext != 1) {y <- y[-(1:(firsttext-1))]}
    y = paste(y, collapse = "\n")
  } else {
    y <- x
  }
  # Now treat the result as regular output
  hook_orig(y, options)
}
