# endogCopulaPanel

Standalone R package for the fixed-effects Gaussian copula estimator for panel
data (Haschka, 2022). Ported from the original endogCopula scripts and
prepared for separate distribution.

## Installation (development)
```r
# install.packages("remotes")
remotes::install_github("ashgreat/endogCopulaPanel")
```

## Usage
```r
library(endogCopulaPanel)
# CopRegML_par(formula, index = c("id", "time"), data, ...)
```

This repository currently mirrors the research code; expect further refactoring
and documentation.
