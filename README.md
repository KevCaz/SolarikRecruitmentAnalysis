# seedlingsRecruitmentAnalysis

:book: Solarik et al. (2019) DOI:XXX - research compendium

[![Build Status](https://travis-ci.org/KevCaz/seedlingsRecruitment.svg?branch=master)](https://travis-ci.org/KevCaz/seedlingsRecruitment)
[![Build status](https://ci.appveyor.com/api/projects/status/xcsiox3ufc4bab69?svg=true)](https://ci.appveyor.com/project/KevCaz/seedlingsrecruitmentanalysis)

This packages includes the code to reproduce the analysis we carried out in
Solarik *et al.* (2019) XXX. The form of a standard R :package: is meant to ease
the sharing of the code. Moreover this repository is an appropriate platform to
discuss and fix potential code issues.

## Installation

Note that in the analysis presented, we used a Rcpp implementation of dispersal
kernel available as a separate R package
[diskers](https://github.com/KevCaz/diskers) as well as two other packages that
include a couple of handy functions and thus, these three packages are required.
A convenient way of installing them, is to use of the `remotes` package
available on CRAN :

```r
install.packages('remotes')
remotes::install_github(c('KevCaz/diskers', 'inSileco/inSilecoMisc', 'inSileco/graphicsutils'))
```

Once installed, you can install this package:

```r
remotes::install_github('KevCaz/seedlingsRecruitment')
```


## :link: How to reproduce the analysis

 Note that the data analysis pipeline is described in vignette ["How to
 reproduce the analysis"](https://kevcaz.github.io/seedlingsRecruitment/articles/Solarik.html).


