build: docs
    Rscript -e "devtools::build()"
check: docs
    Rscript -e "devtools::check()"
docs:
    Rscript -e "devtools::document()"
install: docs
    Rscript -e "devtools::install(build_vignettes = TRUE)"
vigs:
    Rscript -e "source('vignettes/render_vignette_source.R')"
test:
    Rscript -e "devtools::test()"
dev:
    Rscript -e "pak::local_install_dev_deps()"
