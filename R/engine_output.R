# modified from knitr::engine_output()
engine_output <- function (options, code, out, extra = NULL) {
  if (missing(code) && is.list(out))
    return(unlist(knitr::sew(out, options)))
  if (!is.logical(options$echo))
    code = code[options$echo]
  if (length(code) != 1)
    code = single_string(code)
  if (options$engine == "sas" && length(out) > 1 && !grepl("[[:alnum:]]", out[2]))
    out = utils::tail(out, -3)
  if (length(out) != 1)
    out = single_string(out)
  out = sub("([^\n]+)", "\\1\n", out)
  if (options$engine == "stata") {
      out = stata_engine_output(out, options)
  }
  single_string(c(if (length(options$echo) > 1 || options$echo) (knitr::knit_hooks$get("source"))(code, options),
                  if (options$results != "hide" && !xfun::is_blank(out)) {
      if (options$engine == "highlight") out else knitr::sew(out, options)
  },
  extra))
}
