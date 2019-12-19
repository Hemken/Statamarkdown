# unexported from 'knitr' version 1.26
# author: Yihui Xie, 2019

# hook_orig <- function(x, options) x

# unexported from 'knitr' version 1.22
# author: Yihui Xie

split_lines = function(x) {
    if (length(grep('\n', x)) == 0L) return(x)
    x = gsub('\n$', '\n\n', x)
    x[x == ''] = '\n'
    unlist(strsplit(x, '\n'))
}

strip_white = function(x, test_strip = is_blank) {
    if (!length(x)) return(x)
    while (test_strip(x[1])) {
        x = x[-1]; if (!length(x)) return(x)
    }
    while (test_strip(x[(n <- length(x))])) {
        x = x[-n]; if (n < 2) return(x)
    }
    x
}

is_blank = function(x) {
    if (length(x)) all(grepl('^\\s*$', x)) else TRUE
}

out_format = function(x) {
    fmt = knitr::opts_knit$get('out.format')
    if (missing(x)) fmt else !is.null(fmt) && (fmt %in% x)
}

`%n%` = function(x, y) if (is.null(x)) y else x

# unexported from 'highr' version 0.8
spaces = function (n = 1, char = " ") {
    if (n <= 0)
        return("")
    if (n == 1)
        return(char)
    paste(rep(char, n), collapse = "")
}
