# seedlingsRecruitmentAnalysis

## Current status

[![Build status](https://ci.appveyor.com/api/projects/status/xcsiox3ufc4bab69?svg=true)](https://ci.appveyor.com/project/KevCaz/seedlingsrecruitmentanalysis)
[![Build Status](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis.svg?branch=master)](https://travis-ci.org/KevCaz/seedlingsRecruitmentAnalysis)


Note: functions are written using Camel case (*e.g.* `formatData()`).


## Description

This repository includes all the R functions to reproduce the analysis for the article *Priority effects will prevent range shifts of temperate tree species into the boreal forest* by Solarik et al. (2019). The form of a standard R package is
a convenient way to share code and ensure Operating System (OS) interoperability.
Moreover, this GitHub repository is an appropriate platform to discuss and handle
potential code issues.

The whole analysis pipeline is described in the package's vignette and
accessible as a [webpage](https://kevcaz.github.io/seedlingsRecruitmentAnalysis/).



## How to use this package

Several packages available only on GitHub were used for this analysis:

- [diskers](https://github.com/KevCaz/diskers): a Rcpp implementation of dispersal kernels;
- [graphicsutils](https://github.com/inSileco/graphicsutils): a collection of plotting functions.

To install these packages, use of the `devtools` package:

```r
install.packages('devtools')
library(devtools)
install_github(c('KevCaz/diskers', 'inSileco/graphicsutils'))
```

Now, use `devtools` once again to install this package:

```r
install_github('KevCaz/seedlingsRecruitmentAnalysis')
```

## Analysis pipeline

See [XXX]() for more information. 
