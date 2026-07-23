# Changelog

## Statamarkdown (development version)

- Rendering several documents in one R session now works: knitr restores
  the chunk options and knit hooks after each document, which left the
  second document without the Stata executable path (failing with “error
  in running command”) and without the `collectcode` hook. The engine
  now falls back to the executable located when the package was
  attached, and re-registers the hook, so it is no longer necessary to
  `detach("package:Statamarkdown")` between documents.
- New chunk option `stata.fig=TRUE`: exports the graph drawn by a Stata
  chunk and includes it in the output document. The figure goes through
  knitr’s standard plot machinery, so `fig.cap`, `fig.alt` (alternative
  text, for accessibility), `out.width`, `out.height`, `fig.align`,
  `fig.link` and `fig.path` all work as for R chunks. The export format
  is set with `stata.fig.format` (default `"svg"`, which Stata batch
  mode supports on all platforms). In Rmd and Quarto documents the
  hyphenated spellings `stata-fig` and `stata-fig-format` are also
  accepted when using YAML style chunk options. (thanks
  [@kylebutts](https://github.com/kylebutts) in
  [\#28](https://github.com/Hemken/Statamarkdown/issues/28))
- New function
  [`purl_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/purl_stata.md),
  the Stata analogue of
  [`knitr::purl()`](https://rdrr.io/pkg/knitr/man/knit.html): extracts
  the code from the Stata chunks of an R Markdown or Quarto document
  into a do-file, recording each chunk’s header (label and options) as a
  Stata comment, and following
  [`knitr::purl()`](https://rdrr.io/pkg/knitr/man/knit.html)’s
  `documentation` levels (`2` also carries the document text over as
  Stata comments). Chunks with `purl=FALSE` or `eval=FALSE` are skipped,
  including via option comments in any of the forms knitr accepts in
  Stata chunks (`#|`, `*|`, `//|`). (thanks
  [@davidaarmstrong](https://github.com/davidaarmstrong) in
  [\#39](https://github.com/Hemken/Statamarkdown/issues/39))
- Fixed the `collectcode` chunk option when knitr evaluates chunks in a
  different directory to the document, for example for a document in a
  subfolder of an RStudio project with the “Evaluate chunks in
  directory: Project” option set, or when knitting with
  `rmarkdown::render(knit_root_dir=)`. The temporary `profile.do` is now
  created, and any pre-existing `profile.do` snapshot and restored, in
  the directory where the chunks (and therefore Stata) run. (thanks
  [@DaniMori](https://github.com/DaniMori) in
  [\#17](https://github.com/Hemken/Statamarkdown/issues/17))
- Switch from including the html docs files to including them within the
  package as precomputed vignettes using Quarto.
- Tweak helpfile examples such that they run within RStudio.
- Add markdown to Suggests dependencies because it is needed for a code
  path within spinstata (in fact the one in that helpfile).
- Guard two of the helpfile examples for the presence of the rmarkdown
  package.
- Only activate nocommands, nooutput and quietly when set to `TRUE`
- Add some tests
- Convert documentation to use roxygen2

## Statamarkdown 0.9.7

CRAN release: 2026-07-19

- Fixed loss of all chunk output when the Stata log does not contain an
  “end of do-file” line.
- [`spinstata()`](https://hemken.github.io/Statamarkdown/dev/reference/spinstata.md)
  no longer overwrites its input file; a `statafile` without a `.do`
  extension is now an error, and the extension check is
  case-insensitive.
- Fixed a crash in the `collectcode` chunk option when `engine.path` is
  given as a plain string rather than a list.
- The cleanup of the temporary `profile.do` created by `collectcode` now
  locates the [`knitr::knit()`](https://rdrr.io/pkg/knitr/man/knit.html)
  call on the call stack instead of assuming a hardcoded stack depth,
  making it robust to changes in knitr’s internals, child documents, and
  different ways of invoking knitr.
- `cleanlog=TRUE` now removes all lines of multi-line loop commands and
  wrapped (continued) command lines from the output.
- `cleanlog=TRUE` no longer deletes genuine output lines that begin with
  a decimal point.
- Fixed
  [`spinstata()`](https://hemken.github.io/Statamarkdown/dev/reference/spinstata.md)
  block tracking when a marked-up block starts and ends on the same
  line.
- Fixed an error in
  [`spinstata()`](https://hemken.github.io/Statamarkdown/dev/reference/spinstata.md)
  on R \>= 4.3 when producing `Rnw` or `Rtex` output.
- [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  on Windows now stops searching as soon as an executable is found, and
  the non-existent “StataNow19” directory stub has been removed from the
  search.
- Removed a duplicated “No Stata executable found” startup message when
  attaching the package without Stata installed.
- Minor performance improvements: the Stata executable is located once
  at package load, and per-chunk processing avoids repeated system calls
  and redundant vector allocations.
- Change of maintainer to Tom Palmer. Many thanks to Doug Hemken for
  creating and maintaining this amazing package.
- Add the precomputed vignettes to the distributed CRAN package

## Statamarkdown 0.9.6

CRAN release: 2025-10-07

- [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  now searches `/Applications/StataNow` on macOS, the StataNow
  directories on Windows, and two additional installation directories on
  Linux.
- Fixed bugs in the Windows directory search.
- Fixed help file cross-reference links for the new CRAN standard.

## Statamarkdown 0.9.4

CRAN release: 2025-08-23

- Updated
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  for Stata 19 and the SSCC installation path.

## Statamarkdown 0.9.3

- GitHub-only release, not published on CRAN.
- Updated
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  for Stata 19.

## Statamarkdown 0.9.2

CRAN release: 2023-12-04

- Cleaner Stata log output, and the log cleanup now accounts for unset
  chunk options.
- Fixed the `collectcode` chunk option for knitr \>= 1.45.
- Package setup switched from `.onAttach()` to `.onLoad()`.
- Cleaned up package dependencies and other CRAN submission issues.

## Statamarkdown 0.8.0

CRAN release: 2023-06-01

- Thoroughly reworked engine output processing and package loading.
- Edited the vignettes.

## Statamarkdown 0.7.4

CRAN release: 2023-05-25

- Fixed handling of Stata executable paths containing spaces on macOS
  and Unix.
- Updated the required knitr version.

## Statamarkdown 0.7.3

- GitHub-only release, not published on CRAN.
- Updated
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  for Stata 18.
- Improved the help file examples, in particular for
  [`spinstata()`](https://hemken.github.io/Statamarkdown/dev/reference/spinstata.md).
- Changed the vignette rendering, and pointed the README to CRAN.

## Statamarkdown 0.7.2

CRAN release: 2023-02-15

- Better removal of the “Running …/profile.do” line from the log for
  long installation paths.
- Added further Unix installation paths to
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md),
  suggested by Tom Palmer.

## Statamarkdown 0.7.1

- GitHub-only release, not published on CRAN.
- Improved the
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  directory search on Linux, using
  [`Sys.which()`](https://rdrr.io/r/base/Sys.which.html).

## Statamarkdown 0.7.0

- GitHub-only release, not published on CRAN.
- Updated
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  for Stata 17, with macOS fixes.
- Fixed a problem with factor variable names.

## Statamarkdown 0.6.0

- GitHub-only release, not published on CRAN.
- Cleaned up messages in “notebook” mode.
- Fixed a macOS path problem, and added StataIC to the macOS search.
- Fixed log cleanup of the “Running …” line for Stata 16, and the `eval`
  chunk option.
- Prebuilt the vignettes for the binary version of the package.
- Added Philipp Lepert as a contributor.

## Statamarkdown 0.4.4

- GitHub-only release, not published on CRAN.
- First tagged release: a knitr language engine for Stata with cleaned
  log output, the `collectcode` chunk option for linking code blocks,
  [`spinstata()`](https://hemken.github.io/Statamarkdown/dev/reference/spinstata.md)
  for spinning specially marked-up Stata do-files into reports, and
  [`find_stata()`](https://hemken.github.io/Statamarkdown/dev/reference/find_stata.md)
  to locate the Stata executable on Windows, macOS, and Linux.
