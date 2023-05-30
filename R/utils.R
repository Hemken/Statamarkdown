# unexported from 'knitr' version 1.22
# author: Yihui Xie

# split_lines = function(x) { # in package:xfun
#     if (length(grep('\n', x)) == 0L) return(x)
#     x = gsub('\n$', '\n\n', x)
#     x[x == ''] = '\n'
#     unlist(strsplit(x, '\n'))
# }

strip_white = function(x, test_strip = xfun::is_blank) { # used in spinstata.R
    if (!length(x)) return(x)
    while (test_strip(x[1])) {
        x = x[-1]; if (!length(x)) return(x)
    }
    while (test_strip(x[(n <- length(x))])) {
        x = x[-n]; if (n < 2) return(x)
    }
    x
}

# is_blank = function(x) { # in package:xfun
#     if (length(x)) all(grepl('^\\s*$', x)) else TRUE
# }

out_format = function(x) { # used in spinstata.R
    fmt = knitr::opts_knit$get('out.format')
    if (missing(x)) fmt else !is.null(fmt) && (fmt %in% x)
}

`%n%` = function(x, y) if (is.null(x)) y else x  # used in spinstata.R

# unexported from 'highr' version 0.8
# author: Yihui Xie

spaces = function (n = 1, char = " ") { # used in spinstata.R
    if (n <= 0)
        return("")
    if (n == 1)
        return(char)
    paste(rep(char, n), collapse = "")
}

# unexported from 'knitr' version 1.43 (where it is named 'one_string')
# author: Yihui Xie
# used in engine_output.R
single_string = function(x, ...) paste(x, ..., collapse = '\n')

