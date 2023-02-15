# Statamarkdown
This is a collection of R functions that extends knitr's capability 
for using Stata as a language engine.  They have no use if you do not 
also have Stata installed.

You can install this as an R package from CRAN:

```r
install.packages("Statamarkdown")
```

or from GitHub:
```
devtools::install_github("Hemken/Statamarkdown")
```

You can check your installation with
```
library(Statamarkdown)
example("stata_engine", package="Statamarkdown")
```
If the package was installed, you should see an example created in a
temporary directory.

Additional documentation can be found at https://www.ssc.wisc.edu/~hemken/Stataworkshops/Statamarkdown/stata-and-r-markdown.html .

If you would like to contribute to this project, please "fork" it on Github and then clone it back to your computer.  Make your changes and enhancements, push them back to your Github repository, then initiate a "pull" request.

You are also welcome to open issues, or email me directly.
