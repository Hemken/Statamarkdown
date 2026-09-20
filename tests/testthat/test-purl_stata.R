indoc <- paste(c(
  "Some text.",
  "",
  "```{r setup}",
  "library(Statamarkdown)",
  "```",
  "",
  "```{stata first-Stata, collectcode=TRUE}",
  "sysuse auto, clear",
  "generate gpm = 1/mpg",
  "```",
  "",
  "```{stata second-Stata}",
  "regress price gpm",
  "```"
), collapse = "\n")

test_that("purl_stata() extracts only the Stata chunks", {
  res <- purl_stata(text = indoc)

  expect_true(any(grepl("sysuse auto, clear", res, fixed = TRUE)))
  expect_true(any(grepl("regress price gpm", res, fixed = TRUE)))
  # R chunk code is not extracted
  expect_false(any(grepl("library(Statamarkdown)", res, fixed = TRUE)))
})

test_that("documentation = TRUE records the chunk headers as comments", {
  res <- purl_stata(text = indoc)
  expect_true(any(grepl("*%% first-Stata, collectcode=TRUE ----",
                        res, fixed = TRUE)))

  res2 <- purl_stata(text = indoc, documentation = FALSE)
  expect_false(any(grepl("*%%", res2, fixed = TRUE)))
})

test_that("purl_stata() writes a do-file which is overwritten on re-run", {
  local_test_dir()
  writeLines(indoc, "doc.Rmd")

  out <- purl_stata("doc.Rmd")
  expect_identical(out, "doc.do")
  expect_true(file.exists("doc.do"))
  first <- readLines("doc.do")

  # running again overwrites rather than appends
  purl_stata("doc.Rmd")
  expect_identical(readLines("doc.do"), first)
})

test_that("purl = FALSE and eval = FALSE chunks are skipped", {
  doc <- paste(c(
    "```{stata yes}",
    "display 1",
    "```",
    "",
    "```{stata no-purl, purl=FALSE}",
    "display 2",
    "```",
    "",
    "```{stata no-eval, eval=FALSE}",
    "display 3",
    "```",
    "",
    "```{stata yaml-opts}",
    "#| purl: false",
    "display 4",
    "```"
  ), collapse = "\n")

  res <- purl_stata(text = doc)
  expect_true(any(grepl("display 1", res, fixed = TRUE)))
  expect_false(any(grepl("display 2", res, fixed = TRUE)))
  expect_false(any(grepl("display 3", res, fixed = TRUE)))
  expect_false(any(grepl("display 4", res, fixed = TRUE)))
})

test_that("#| option comments are not copied into the do-file", {
  doc <- paste(c(
    "```{stata opts}",
    "#| collectcode: true",
    "sysuse auto",
    "```"
  ), collapse = "\n")

  res <- purl_stata(text = doc)
  expect_true(any(grepl("sysuse auto", res, fixed = TRUE)))
  expect_false(any(grepl("#|", res, fixed = TRUE)))
})

test_that("the older engine='stata' chunk syntax is recognised", {
  doc <- paste(c(
    "```{r old-style, engine='stata'}",
    "sysuse auto",
    "```"
  ), collapse = "\n")

  res <- purl_stata(text = doc)
  expect_true(any(grepl("sysuse auto", res, fixed = TRUE)))
})

test_that("a document without Stata chunks warns and writes nothing", {
  local_test_dir()
  writeLines("```{r}\n1 + 1\n```", "doc.Rmd")

  expect_warning(res <- purl_stata("doc.Rmd"), "No Stata code chunks")
  expect_identical(res, character())
  expect_false(file.exists("doc.do"))
})

test_that("output must differ from input", {
  local_test_dir()
  writeLines(indoc, "doc.Rmd")
  expect_error(purl_stata("doc.Rmd", output = "doc.Rmd"), "different")
})

test_that("documentation = 2 includes the document text as comments", {
  res <- purl_stata(text = indoc, documentation = 2)

  # prose becomes Stata comments
  expect_true(any(grepl("* Some text.", res, fixed = TRUE)))
  # code is not commented
  expect_true(any(grepl("^sysuse auto, clear$", res)))
  # non-Stata chunk code is still excluded
  expect_false(any(grepl("library(Statamarkdown)", res, fixed = TRUE)))
  # blank lines stay blank rather than becoming "* "
  expect_false(any(grepl("^\\*\\s*$", res)))
})

test_that("documentation = 0 and FALSE give code only", {
  expect_identical(purl_stata(text = indoc, documentation = 0),
                   purl_stata(text = indoc, documentation = FALSE))
  res <- purl_stata(text = indoc, documentation = 0)
  expect_false(any(grepl("^\\*", res)))
})

test_that("invalid documentation values error", {
  expect_error(purl_stata(text = indoc, documentation = 3), "documentation")
  expect_error(purl_stata(text = indoc, documentation = "yes"), "documentation")
})

test_that("option comments are split from the code as knitr does", {
  doc <- paste(c(
    "```{stata}",
    "*| label: scatterplot",
    "*| stata.fig: true",
    "*| fig-cap: \"Mileage against weight\"",
    "scatter mpg weight",
    "```",
    "",
    "```{stata}",
    "*| purl: false",
    "display 1",
    "```",
    "",
    "```{stata}",
    "*| eval: false",
    "display 2",
    "```",
    "",
    "```{r old-style, engine='stata'}",
    "#| purl: false",
    "display 3",
    "```"
  ), collapse = "\n")

  res <- purl_stata(text = doc)
  expect_true(any(grepl("scatter mpg weight", res, fixed = TRUE)))
  # option comment lines are not copied into the do-file as code ...
  expect_false(any(grepl("^[[:space:]]*(\\*|#)[|]", res)))
  # ... but are recorded as plain Stata comments
  expect_true(any(grepl('* fig-cap: "Mileage against weight"', res, fixed = TRUE)))
  # purl: false and eval: false in option comments are honoured, in a
  # stata chunk (*|) and in the older engine='stata' form (#|)
  expect_false(any(grepl("display 1", res, fixed = TRUE)))
  expect_false(any(grepl("display 2", res, fixed = TRUE)))
  expect_false(any(grepl("display 3", res, fixed = TRUE)))

  # with documentation = 0 the option comments are dropped entirely
  res0 <- purl_stata(text = doc, documentation = 0)
  expect_false(any(grepl("fig-cap", res0)))
})

test_that("a //| line is kept as code, as knitr treats it", {
  # knitr only recognises *| (and #|) as option comments, so a //|
  # line is Stata code, and a Stata comment at that
  doc <- paste(c("```{stata}", "//| label: x", "sysuse auto", "```"),
               collapse = "\n")

  res <- purl_stata(text = doc, documentation = 0)
  expect_identical(res, c("//| label: x", "sysuse auto"))
})
