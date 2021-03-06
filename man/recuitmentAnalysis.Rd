% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recruitmentAnalysis.R
\name{recuitmentAnalysis}
\alias{recuitmentAnalysis}
\alias{launchIt}
\title{Recruitment analaysis .}
\usage{
recuitmentAnalysis(site, year, tree, age, mat_par, path = "./",
  zero_infl = FALSE, disp = FALSE, favo = FALSE, neigh = FALSE,
  clip = NULL, kernel = "kern_lognormal", mxt = 100, quiet = TRUE,
  record = NULL)

launchIt(iter, simu = NULL, mxt = 100, record = "test.txt",
  quiet = TRUE, path = "output/")
}
\arguments{
\item{site}{site name.}

\item{year}{year (2015 or 2016) name.}

\item{tree}{abbreviation of the tree species names of the species.}

\item{age}{age of the species (1 or 2).}

\item{mat_par}{a matrix of parameters (see \code{getParameters}).}

\item{path}{a character string giving the path to access the data.}

\item{zero_infl}{logical. If \code{TRUE} then a zero-inflated poisson distribution is used, otherwise a poisson distribution is used.}

\item{disp}{a logical. If \code{TRUE}, then dispersal parameters are used.}

\item{favo}{a logical. If \code{TRUE}, then favorability parameters are used.}

\item{neigh}{a logical. If \code{TRUE}, then neighborhood effect parameter is used.}

\item{clip}{a numeric vector of standardized DBH (Diameter at breast heights).}

\item{kernel}{a character string indicating which kernel should be used (either \code{kern_lognormal} or \code{kern_exponential_power}). See \link[diskers]{kernels} for further details.}

\item{mxt}{a numeric. Maximum running time in seconds (see \link[GenSA]{GenSA}).}

\item{quiet}{logical. If \code{TRUE} details about the state of simulations are printed.}

\item{record}{a connection, or a character string naming the file to print to. If \code{NULL}, the default values, no record is done.}

\item{iter}{a integer identifying the iteration.}

\item{simu}{a data frame describing the simulation.}
}
\value{
The log-likelihood values associated to a given set of parameters.
}
\description{
This function computes the likelihood associated to a specific set of parameters.
The specification of parameters determines the ecological processes involved.
}
\details{
The parameter \code{pz} have a value even if it is not included in the analysis (meaning a poisson distribution is used).
}
\section{Functions}{
\itemize{
\item \code{launchIt}: Launch the analysis for a given row of the simulation data frame or file.
}}

\author{
Kevin Cazelles
}
