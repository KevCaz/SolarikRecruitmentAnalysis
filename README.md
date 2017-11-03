seedlingsRecruitmentAnalysis
============================

This repository includes all the R functions to reproduce the analyses we carry out in Solarik *et al.* XXXX. The form of a standard R package is convenient to share code and ensure Operating System (OS) interoperability. Moreover this repository is an appropriate platform to discuss and handle code issues related issues.

In this package we use a Rcpp implementation of dispersal kernel available as a separate package ([recruitR](https://github.com/KevCaz/recruitR)). The whole analysis we undertook is described in the package's vignette.

Notes: 1. Function's names are written using Camel case (*e.g.* `formatData()`).

How to use the package
----------------------

A couple of Github package are required. To install them we recommend the use of the `devtools` package one can get it on CRAN using the `install.packages()` function:

``` r
install.packages('devtools')
```

Once loaded, `install_guthub()` eases the installation of the other packages:

``` r
library(devtools)
install_github(c('KevCaz/recruitR', 'inSileco/letiRmisc', 'inSileco/graphicsUtils'))
```

including this package:

``` r
install_github('KevCaz/seedlingsRecruitmentAnalysis')
```

Current status
--------------

[![Build status](https://ci.appveyor.com/api/projects/status/xcsiox3ufc4bab69?svg=true)](https://ci.appveyor.com/project/KevCaz/seedlingsrecruitmentanalysis) [![Build Status](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis.svg?branch=master)](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis) [![codecov](https://codecov.io/gh/KevCaz/seedlingsRecruitmentAnalysis/branch/master/graph/badge.svg)](https://codecov.io/gh/KevCaz/seedlingsrecruitmentanalysis)

To do
-----

-   \[ \] Include data as rda files
-   \[ \] Complete vignette (~30% complete)
-   \[ \] Improve the code coverage
-   \[ \] Adding Links to the paper and the datasets once published.
