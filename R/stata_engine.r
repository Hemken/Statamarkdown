stata_engine <- function (options)
{
  code <- {
    if (is.null(options$savedo) || options$savedo==FALSE) {
      f <- basename(tempfile(pattern="stata", tmpdir=".", fileext=".do"))
    } else {
      f <- basename(paste0(options$label, ".do"))
    }
    logf = sub("[.]do$", ".log", f)

    paste(switch(Sys.info()[["sysname"]], Windows = "/q /e do",
                 Darwin = "-q -e do", Linux = "-q -b do", "-q -b do"),
          shQuote(normalizePath(f)))
    if (is.null(options$savedo) || options$savedo==FALSE)
      on.exit(unlink(c(logf)), add = TRUE)
    paste(f, options$doargs)
  }

  code = paste(options$engine.opts, code)
  # cmd = knitr:::get_engine_path(options$engine.path, options$engine)
  cmd = options$engine.path
  out = if (options$eval) {
    message("running: ", cmd, " ", code)
    tryCatch(system2(cmd, code, stdout = TRUE, stderr = TRUE,
                     env = options$engine.env), error = function(e) {
                       if (!options$error)
                         stop(e)
                       paste("Error in running command", cmd)
                     })
  }
  else ""
  if (!options$error && !is.null(attr(out, "status")))
    stop(paste(out, collapse = "\n"))
  if (options$eval && options$engine == "stata" && file.exists(logf))
    out = c(readLines(logf), out)
  knitr::engine_output(options, options$code, out)
}
