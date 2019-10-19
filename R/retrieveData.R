#' Retrieve datasets
#'
#' Retrieve original datasets from dryad <https://datadryad.org>.
#'
#' @param dir path to folder where the data will be stored.
#'
#' @importFrom utils unzip download.file
#' @export

retrieveData <- function(dir = "input") {
  from <- "https://datadryad.org/"
  share <-"stash/share/b4O2vW0ePcurU-9iT2M3D6_mBitauHCLKK6dsfPNP10"
  dir.create(dir, showWarnings = FALSE)
  nmz <- "tmp.zip"
  download.file(paste0(from, share), destfile = nmz)
  unzip(nmz, exdir = dir)
  unlink(nmz)
  NULL
}
