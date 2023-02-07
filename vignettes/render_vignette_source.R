library(rmarkdown)

try(detach("package:Statamarkdown", unload=TRUE))
render("vignettes/basicuse.rmd", output_format=html_vignette(),
       output_file="1_Basic_Use_of_Statamarkdown.html", output_dir="inst/doc")
render("vignettes/linkblocks.Rmd", output_format=html_vignette(),
       output_file="2_Linking_Stata_Code_Chunks.html", output_dir="inst/doc")
render("vignettes/randstata.rmd", output_format=html_vignette(),
       output_file="3_Combining_Stata_and_R.html", output_dir="inst/doc")
