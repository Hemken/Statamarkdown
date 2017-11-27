stataoutputhook <- function(x, options) {
    y <- strsplit(x, "\n")[[1]]
    # Remove command echo in Stata log
    commandlines <- grep("^\\.", y)
    if (length(commandlines)>0) {y <- y[-(grep("^\\.", y))]}
    # Some commands have a leading space?
    if (length(grep("^[[:space:]*]\\.", y))>0) {
        y <- y[-(grep("^[[:space:]*]\\.", y))]
    }
    # Ensure a trailing blank line
    if (length(y)>0 && y[length(y)] != "") { y <- c(y, "") }
    # Remove blank lines at the top of the Stata log
    firsttext <- min(grep("[[:alnum:]]", y))
    if (firsttext != Inf) {y <- y[-(1:(firsttext-1))]}
    # Now treat the result as regular output
    hook_orig(y, options)
}
