check: docs
    R -e "devtools::check()"
docs:
    R -e "devtools::document()"
install: docs
    R -e "devtools::install(build_vignettes = TRUE)"
vigs:
    R -e "source('vignettes/render_vignette_source.R')"
test:
    R -e "devtools::test()"
dev:
    R -e "pak::local_install_dev_deps()"
