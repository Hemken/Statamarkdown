# Linking Code Blocks

Each code chunk in your dynamic markdown document runs as a separate
batch file in Stata. This means that the results of one code chunk do
***not*** automatically carry over to the next. You can make the results
of a chunk carry over to all subsequent chunks by using the
`collectcode=TRUE` chunk option.

Collected code accumulates, and runs silently before each subsequent
chunk.

## Setup Stata Engine

(If necessary, manually specify the Stata executable location.)

``` r

library(Statamarkdown)
```

    ## Stata found at /Applications/StataNow/StataMP.app/Contents/MacOS/StataMP

    ## The 'stata' engine is ready to use.

## An Example

In this example we load the data and calculate a new variable in a first
code chunk. Then in a later code chunk we also use the data, including
the new variable.

### First code block:

In the first code chunk, use the `collectcode` option.

`{stata first-Stata, collectcode=TRUE} sysuse auto, clear generate gpm = 1/mpg summarize price gpm`

Which looks like this in your document:

``` stata
sysuse auto, clear
generate gpm = 1/mpg
summarize price gpm
```

    (1978 automobile data)

        Variable |        Obs        Mean    Std. dev.       Min        Max
    -------------+---------------------------------------------------------
           price |         74    6165.257    2949.496       3291      15906
             gpm |         74    .0501928    .0127986   .0243902   .0833333

### Second code block:

Then you can use the data and the new variable in a later code chunk.

```` markdown
```{stata second-Stata}
regress price gpm
```
````

Which looks like this in your document:

``` stata
regress price gpm
```

          Source |       SS           df       MS      Number of obs   =        74
    -------------+----------------------------------   F(1, 72)        =     35.95
           Model |   211486574         1   211486574   Prob > F        =    0.0000
        Residual |   423578822        72  5883039.19   R-squared       =    0.3330
    -------------+----------------------------------   Adj R-squared   =    0.3238
           Total |   635065396        73  8699525.97   Root MSE        =    2425.5

    ------------------------------------------------------------------------------
           price | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
    -------------+----------------------------------------------------------------
             gpm |     132990   22180.86     6.00   0.000     88773.24    177206.7
           _cons |  -509.8827   1148.469    -0.44   0.658    -2799.314    1779.548
    ------------------------------------------------------------------------------
