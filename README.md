
# seedlingsRecruitmentAnalysis

:book: Solarik et al. (2019) DOI:XXX - research compendium

[![Build status](https://ci.appveyor.com/api/projects/status/xcsiox3ufc4bab69?svg=true)](https://ci.appveyor.com/project/KevCaz/seedlingsrecruitmentanalysis)
[![Build Status](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis.svg?branch=master)](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis)

Code to reproduce the analyses carried out in Solarik *et al.* (2019). We used a
standard R package to share our code and ensure that our study is reproducible.
Moreover this repository is an appropriate platform to discuss and fix potential
code issues.

The whole analysis pipeline is described in the package's vignette and
accessible as a [webpage](https://github.com/KevCaz/diskers/).



## How to use this R package

Note that in the analysis presented, we used a Rcpp implementation of dispersal
kernel available as a separate R package
[diskers](https://github.com/KevCaz/diskers) as well as two other packages that
include a couple of handy functions. All these three packages must be installed
to reproduce the analysis. A convenient way of installing them, is to use of the
`remotes` package available on CRAN :

```r
install.packages('remotes')
remotes::install_github(c('KevCaz/diskers', 'inSileco/inSilecoMisc', 'inSileco/graphicsutils'))
```

Once installed, you can install this package:

```r
remotes::install_github('KevCaz/seedlingsRecruitmentAnalysis')
```
