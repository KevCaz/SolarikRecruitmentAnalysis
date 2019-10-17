#' Simulations design
#'
#' Design of the simulations as carried out in Solarik et al. 2018. Each row
#' represents one simulation, i.e. a combination of a site, a tree species, a
#' year, an age if a zero-inflated distribution was used (`pz` column) and
#' also whether favourability (`favo`) and neighborhood (`neigh`)
#' effect were used.
#'
#' @docType data
#' @keywords datasets
#' @author Kevin Cazelles
#' @name simuDesign
#' @usage simuDesign
#' @format A data frame of 2240 rows and 8 columns.
"simuDesign"


#' Parameters values for the best models
#'
#' Running all the simulations took hours. Tht is the reason why kept the parameters values for the best models in this dataset.
#'
#' @docType data
#' @keywords datasets
#' @author Kevin Cazelles
#' @name res_bestModels
#' @usage res_bestModels
#' @format A data frame of 49 rows and 28 columns.
"res_bestModels"
