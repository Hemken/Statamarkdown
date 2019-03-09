stataengine_output <- function (options, code, out, extra = NULL)
{
  # modified from knitr::engine_output(), packageVersion("knitr")==1.21
  if (missing(code) && is.list(out))
    return(unlist(wrap(out, options)))
  if (!is.logical(options$echo))
    code = code[options$echo]
  if (length(code) != 1L)
    code = paste(code, collapse = "\n")
  # if (options$engine == "sas" && length(out) > 1L && !grepl("[[:alnum:]]",
  #                                                           out[2]))
  #   out = tail(out, -3L)
  if (length(out) != 1L)
    out = paste(out, collapse = "\n")
  out = sub("([^\n]+)$", "\\1\n", out)
  # options$engine = switch(options$engine, mysql = "sql", node = "javascript",
  #                         psql = "sql", Rscript = "r", options$engine)
  if (options$engine == "stata") {
    out = gsub("\nrunning.*profile.do", "", out)
    out = sub("...\n\n\n", "", out)
    out = sub("\n. \nend of do-file\n", "", out)
  }
  paste(c(if (length(options$echo) > 1L || options$echo)
    (knitr::knit_hooks$get("source"))(code,
        options), if (options$results != "hide" && !knitr:::is_blank(out)) {
          if (options$engine == "highlight") out else knitr:::wrap.character(out,
            options)
          }, extra), collapse = "\n")
}
