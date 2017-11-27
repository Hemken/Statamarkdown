stata_collectcode <- function() {
    if (file.exists("profile.do")) {
        stop("You must remove or rename an existing 'profile.do'.")
    }
knitr::knit_hooks$set(collectcode = function(before, options, envir) {
    if (!before) {
        if (options$engine == “stata“) {
            autoexec <- file("profile.do", open="at")
            writeLines(options$code, autoexec)
            close(autoexec)
            #print(sys.frames())
            #print(sys.calls())
        do.call("on.exit",
            list(quote(unlink("profile.do")), add=TRUE),
            envir = sys.frame(-9))
            # sys.frame(1) or sys.frame(-10) is rmarkdown::render()
            # sys.frame(-9) is knitr::knit()
        }
    }
})
}
