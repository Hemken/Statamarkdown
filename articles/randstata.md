# Combining Stata and R

One of the virtues of processing your dynamic documents through R is
that you can use more than one programming language in a single
document. Many of us are multi-lingual, and it is often quicker and
easier to execute part of a project in one language, while completing
your work in another. This is especially common when you are in the
process of learning a new language, or if part of your work involves a
specialized language with limited capabilities.

## Some Setup for Stata

Some initial setup is required to use Stata to process commands. You
would include an initial fenced code block ("code chunk") to do this.
Use the `include=FALSE` chunk option to hide this from your readers.

```` markdown
```{r Statasetup}
library(Statamarkdown)
```
````

Then, to switch languages, you just indicate the language in the code
fence.

## Using Stata

```` markdown
```{stata auto}
sysuse auto
regress mpg weight
```
````

``` stata
sysuse auto
regress mpg weight
```

    (1978 automobile data)

          Source |       SS           df       MS      Number of obs   =        74
    -------------+----------------------------------   F(1, 72)        =    134.62
           Model |   1591.9902         1   1591.9902   Prob > F        =    0.0000
        Residual |  851.469256        72  11.8259619   R-squared       =    0.6515
    -------------+----------------------------------   Adj R-squared   =    0.6467
           Total |  2443.45946        73  33.4720474   Root MSE        =    3.4389

    ------------------------------------------------------------------------------
             mpg | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
    -------------+----------------------------------------------------------------
          weight |  -.0060087   .0005179   -11.60   0.000    -.0070411   -.0049763
           _cons |   39.44028   1.614003    24.44   0.000     36.22283    42.65774
    ------------------------------------------------------------------------------

## Using R

```` markdown
```{r cars}
summary(lm(mpg ~ wt, data=mtcars))
```
````

``` r

summary(lm(mpg ~ wt, data=mtcars))
```


    Call:
    lm(formula = mpg ~ wt, data = mtcars)

    Residuals:
        Min      1Q  Median      3Q     Max
    -4.5432 -2.3647 -0.1252  1.4096  6.8727

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)
    (Intercept)  37.2851     1.8776  19.858  < 2e-16 ***
    wt           -5.3445     0.5591  -9.559 1.29e-10 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 3.046 on 30 degrees of freedom
    Multiple R-squared:  0.7528,    Adjusted R-squared:  0.7446
    F-statistic: 91.38 on 1 and 30 DF,  p-value: 1.294e-10
