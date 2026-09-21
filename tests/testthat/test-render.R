test_that("an Rmd file with a Stata chunk renders to HTML", {
  skip_on_cran()
  skip_if_no_stata()
  skip_if_not_installed("rmarkdown")
  skip_if(!rmarkdown::pandoc_available("2.0"), "pandoc not available")
  local_test_dir()

  writeLines(c("---",
               "title: \"Statamarkdown render test\"",
               "output: html_document",
               "---",
               "",
               "```{r setup, include=FALSE}",
               "library(Statamarkdown)",
               "```",
               "",
               "```{stata}",
               "display \"stata-render-ok\"",
               "```"),
             "test.Rmd")

  # mathjax = NULL avoids pandoc >= 3.11 warning about deprecated --mathjax flag
  outfile <- rmarkdown::render("test.Rmd", quiet = TRUE,
                               output_options = list(mathjax = NULL))

  expect_true(file.exists(outfile))
  html <- paste(readLines(outfile, warn = FALSE), collapse = "\n")
  expect_match(html, "stata-render-ok", fixed = TRUE)
})
