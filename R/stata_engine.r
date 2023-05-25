stata_engine <- function (options)
{
  code <- {
    if (is.null(options$savedo) || options$savedo==FALSE) {
      f <- basename(tempfile(pattern="stata", tmpdir=".", fileext=".do"))
      on.exit(unlink(f), add = TRUE)
    } else {
      f <- basename(paste0(options$label, ".do"))
    }
# print(options$code)
# print(options$eval)
    if (is.numeric(options$eval)) {
      if (all(options$eval < 0)) {
        pre <- rep("", length(options$code))
        pre[abs(options$eval)] <- "* "
      } else if (all(options$eval > 0)) {
        pre <- rep("* ", length(options$code))
        pre[abs(options$eval)] <- ""
      } else {
        message("eval option must be all negative or positive")
        pre <- rep("", length(options$code))
      }
      options$code <- paste0(pre, options$code)
    }
    writeLines(options$code, f)


    logf = sub("[.]do$", ".log", f)
    if (is.null(options$savedo) || options$savedo==FALSE)
      on.exit(unlink(logf), add = TRUE)
    paste(switch(Sys.info()[["sysname"]],
                 Windows = "/q /e do",
                 Darwin = "-q -e do",
                 Linux = "-q -b do",
                 "-q -b do"),
          switch(Sys.info()[["sysname"]],
                 Windows = shQuote(normalizePath(f)),
                 Darwin = paste0("\'\"", normalizePath(f), "\"\'"),
                 Linux  = paste0("\'\"", normalizePath(f), "\"\'"),
                 shQuote(normalizePath(f))))
  }

  if (is.list(options$engine.opts)) {
    code = paste(options$engine.opts[[options$engine]], code, options$doargs)
  } else { # backwards compatability
    code = paste(options$engine.opts, code, options$doargs)
  }
# print(code)

  cmd = options$engine.path
  if (is.list(options$engine.path)) {
    cmd = options$engine.path[[options$engine]]
  } else { # backwards compatability
    cmd = options$engine.path
  }

  out = if (!all(options$eval==FALSE)) {
    if (!is.null(options$noisey) && options$noisey==TRUE) message("running: ", cmd, " ", code)
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
  if (!all(options$eval==FALSE) && options$engine == "stata" && file.exists(logf))
    out = c(readLines(logf), out)
#  stataengine_output(options, options$code, out)
# print("log file read")
# print(out)
# print(knitr::engine_output)
  knitr::engine_output(options, options$code, out)
}
