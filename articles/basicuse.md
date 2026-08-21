# Basic Use of Statamarkdown

This discussion assumes you already have a basic understanding of
Markdown for document formatting, Rmarkdown to include executable code
in a document, and Stata to write the code.

## First attach the `Statamarkdown` library

Your first code chunk will look something like this:

```` markdown
```{r library}
library(Statamarkdown)
```
````

This will either report that Stata was found, or that you need to
specify its location yourself.

``` r

library(Statamarkdown)
```

    ## Stata found at /Applications/StataNow/StataMP.app/Contents/MacOS/StataMP

    ## The 'stata' engine is ready to use.

You can hide all of this so it does not appear in your final document by
using the `include=FALSE` chunk options.

## If Stata was not found

You will need to specify this yourself, as additional lines in the
"library" code block above.

``` r

stataexe <- "C:/Program Files/Stata18/StataSE-64.exe" # Windows
# stataexe <- "/Applications/Stata/StataSE.app/Contents/MacOS/StataSE" # Mac OS
# stataexe <- "/usr/local/stata18/stata-se" # Unix
knitr::opts_chunk$set(engine.path = list(stata = stataexe))
```

If you do not know where to find your Stata executable (app), open Stata
and issue the command `sysdir`. The line labeled `STATA:` is the folder
where your Stata executable is located. You can browse there with your
computer's file explorer to see the actual file name of the Stata
executable, which varies by operating system, Stata version, and Stata
flavor.

Then make the Stata executable path a default chunk option.

## Then set up Stata code chunks.

A simple code chunk in Rmarkdown might look like:

```` markdown
```{stata example}
sysuse auto
summarize
```
````

And in your document this would produce:

``` stata
sysuse auto
summarize
```

    (1978 automobile data)

        Variable |        Obs        Mean    Std. dev.       Min        Max
    -------------+---------------------------------------------------------
            make |          0
           price |         74    6165.257    2949.496       3291      15906
             mpg |         74     21.2973    5.785503         12         41
           rep78 |         69    3.405797    .9899323          1          5
        headroom |         74    2.993243    .8459948        1.5          5
    -------------+---------------------------------------------------------
           trunk |         74    13.75676    4.277404          5         23
          weight |         74    3019.459    777.1936       1760       4840
          length |         74    187.9324    22.26634        142        233
            turn |         74    39.64865    4.399354         31         51
    displacement |         74    197.2973    91.83722         79        425
    -------------+---------------------------------------------------------
      gear_ratio |         74    3.014865    .4562871       2.19       3.89
         foreign |         74    .2972973    .4601885          0          1
