test_that("spinstata() converts marked-up Stata comments to a knitr document", {
  skip_on_cran()

  indoc <- paste(c("/*' ",
                   "# Spin Example",
                   "",
                   "Some explanatory text.",
                   "'*/",
                   "",
                   "/*+ dosomething, engine='stata' +*/",
                   "sysuse auto",
                   "summarize"),
                 collapse = "\n")

  res <- spinstata(text = indoc, knit = FALSE)
  txt <- paste(res, collapse = "\n")

  # document text is passed through as markdown
  expect_match(txt, "# Spin Example", fixed = TRUE)
  expect_match(txt, "Some explanatory text.", fixed = TRUE)
  # the chunk header comment becomes a fenced code chunk, for Stata.
  # knitr >= 1.53 puts the engine in the fence itself (```{stata ...}),
  # earlier versions use an R fence with the engine chunk option.
  expect_match(txt, "```[{](r|stata) dosomething")
  expect_match(txt, "engine='stata'", fixed = TRUE)
  # the Stata code is inside the document
  expect_match(txt, "sysuse auto", fixed = TRUE)
  expect_match(txt, "summarize", fixed = TRUE)
})

test_that("Stata chunks get engine='stata' without it being written in the header", {
  indoc <- paste(c("/*' ",
                   "# Engine Example",
                   "'*/",
                   "",
                   "/*+ setup +*/",
                   "/*R",
                   "library(Statamarkdown)",
                   "R*/",
                   "",
                   "/*+ stata-chunk +*/",
                   "sysuse auto",
                   "summarize",
                   "",
                   "/*+ explicit, engine='stata' +*/",
                   "describe"),
                 collapse = "\n")

  txt <- paste(spinstata(text = indoc, knit = FALSE), collapse = "\n")

  # a chunk of Stata code is marked as such
  expect_match(txt, "stata-chunk, engine='stata'", fixed = TRUE)
  # a chunk of R code is left as an R chunk
  expect_match(txt, "{r setup}", fixed = TRUE)
  expect_no_match(txt, "setup, engine='stata'", fixed = TRUE)
  # a header which sets the engine itself is left alone
  expect_match(txt, "explicit, engine='stata'", fixed = TRUE)
  expect_no_match(txt, "engine='stata', engine='stata'", fixed = TRUE)
})

test_that("spinstata() supports the output formats of knitr::spin()", {
  indoc <- paste(c("/*' ", "# Formats", "'*/", "",
                   "/*+ chunk1 +*/", "sysuse auto"), collapse = "\n")

  # qmd, which the vendored copy of spin() did not support
  qmd <- paste(spinstata(text = indoc, knit = FALSE, format = "qmd"), collapse = "\n")
  expect_match(qmd, "chunk1, engine='stata'", fixed = TRUE)

  rnw <- paste(spinstata(text = indoc, knit = FALSE, format = "Rnw"), collapse = "\n")
  expect_match(rnw, "\\documentclass{article}", fixed = TRUE)
  expect_match(rnw, ">>=", fixed = TRUE)
})

test_that("a spun document runs its Stata and R chunks with the right engines", {
  skip_on_cran()
  skip_if_no_stata()
  skip_if_not_installed("markdown")
  local_test_dir()

  writeLines(c("/*' ",
               "# Mixed Example",
               "'*/",
               "",
               "/*+ setup, include=FALSE +*/",
               "/*R",
               "x <- 6 * 7",
               "R*/",
               "",
               "/*+ from-r +*/",
               "/*R",
               "cat('r-ran', x)",
               "R*/",
               "",
               "/*+ from-stata +*/",
               "sysuse auto, clear",
               "summarize price"),
             "mixed.do")

  # for a file, spinstata() returns the path to the output document
  out <- spinstata("mixed.do")
  expect_true(file.exists(out))
  html <- paste(readLines(out, warn = FALSE), collapse = "\n")

  expect_match(html, "r-ran 42", fixed = TRUE)   # the R chunks ran as R
  expect_match(html, "Std. dev.", fixed = TRUE)  # the Stata chunk ran as Stata
})
