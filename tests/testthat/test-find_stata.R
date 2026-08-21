test_that("find_stata() locates a Stata executable", {
  skip_on_cran()
  stataexe <- suppressMessages(find_stata(message = FALSE))
  skip_if(!nzchar(stataexe), "Stata not available")

  expect_true(file.exists(stataexe))
  # the found executable is registered as the knitr engine path
  expect_identical(knitr::opts_chunk$get("engine.path")$stata, stataexe)
})

test_that("find_stata() only messages when message = TRUE", {
  # stub the filesystem lookups so that the search fails on any platform
  f <- find_stata
  e <- new.env(parent = environment(f))
  e$dir.exists  <- function(...) FALSE
  e$file.exists <- function(...) FALSE
  e$Sys.which   <- function(x) stats::setNames("", x)
  environment(f) <- e

  expect_silent(res <- f(message = FALSE))
  expect_identical(res, "")
  expect_message(f(message = TRUE), "No Stata executable found")
})
