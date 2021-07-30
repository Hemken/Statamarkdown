## ----library------------------------------------------------------------------
library(Statamarkdown)

## ----stataexe, eval=FALSE-----------------------------------------------------
#  stataexe <- "C:/Program Files/Stata16/StataSE-64.exe"
#  knitr::opts_chunk$set(engine.path = list(stata = stataexe))

## ----r detach, include=FALSE--------------------------------------------------
detach(package:Statamarkdown)
