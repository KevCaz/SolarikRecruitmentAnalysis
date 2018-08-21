Current status
--------------

[![Build
status](https://ci.appveyor.com/api/projects/status/xcsiox3ufc4bab69?svg=true)](https://ci.appveyor.com/project/KevCaz/seedlingsrecruitmentanalysis)
[![Build
Status](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis.svg?branch=master)](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis)
<!-- [![codecov](https://codecov.io/gh/KevCaz/seedlingsRecruitmentAnalysis/branch/master/graph/badge.svg)](https://codecov.io/gh/KevCaz/seedlingsrecruitmentanalysis)
 -->

seedlingsRecruitmentAnalysis
============================

This repository includes all the R functions to reproduce the analyses
we carry out in Solarik *et al.* (XXS). The form of a standard R package
is convenient to share code and ensure Operating System (OS)
interoperability. Moreover this repository is an appropriate platform to
discuss and handle potential code issues.

The whole analysis pipeline is described in the package’s vignette and
accessible as a
[webpage](https://kevcaz.github.io/seedlingsRecruitmentAnalysis/).

Functions of package names are written using Camel case (*e.g.*
`formatData()`).

How to use this R package
-------------------------

Note that in the analysis presented, we have used a Rcpp implementation
of dispersal kernel available as a separate R package
[recruitR](https://github.com/KevCaz/recruitR) as well as two other
packages that include our own handy functions. All these three packahes
needs to be installed to reproduce our analysis. The easiest way to
install them, is to use of the `devtools` package available on CRAN:

    install.packages('devtools')

Once loaded, `install_github()` enables the installation of the other
packages:

    library(devtools)
    install_github(c('KevCaz/recruitR', 'inSileco/inSileco', 'inSileco/graphicsutils'))

Now, you can install this package:

    install_github('KevCaz/seedlingsRecruitmentAnalysis')

To do
-----

-   \[ \] Include data as `.rda` files
-   \[ \] Complete vignette (~40% complete) up to provide an example for
    on line of `simuDesign`
-   \[ \] Turn Solarik.Rmd as a real vignette
-   \[ \] Adding links to the paper and the datasets once published.
