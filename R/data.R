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



#' Abitibi dataset
#'
#' Trees and regeneration data for Abitibi site.
#'
#' @docType data
#' @keywords datasets
#' @name dat_abitibi
#' @usage dat_abitibi
#' @format
#' A list of 5 objects:
#' * `trees` that includes identity and position of trees;
#' * `regen2015` and `regen2016` regeneration and favourability data for 2015 and 2016 respectively (note that favourability values are the same for both years);
#' * `lsdist` a list of distances: for every plot it gives the distance of all surrounding tree including in the site.
#' * `iddist` a list of logicals of the same format as `lsdist` that states whether the tree is included in the buffer.
"dat_abitibi"


#' Le bic dataset
#'
#' Trees and regeneration data for Le Bic site.
#'
#' @docType data
#' @keywords datasets
#' @name dat_lebic
#' @usage dat_lebic
#' @format
#' A list of 5 objects:
#' * `trees` that includes identity and position of trees;
#' * `regen2015` and `regen2016` regeneration and favourability data for 2015 and 2016 respectively (note that favourability values are the same for both years);
#' * `lsdist` a list of distances: for every plot it gives the distance of all surrounding tree including in the site.
#' * `iddist` a list of logicals of the same format as `lsdist` that states whether the tree is included in the buffer.
"dat_lebic"


#' Sutton dataset
#'
#' Trees and regeneration data for Sutton site.
#'
#' @docType data
#' @keywords datasets
#' @name dat_sutton
#' @usage dat_sutton
#' @format
#' A list of 5 objects:
#' * `trees` that includes identity and position of trees;
#' * `regen2015` and `regen2016` regeneration and favourability data for 2015 and 2016 respectively (note that favourability values are the same for both years);
#' * `lsdist` a list of distances: for every plot it gives the distance of all surrounding tree including in the site.
#' * `iddist` a list of logicals of the same format as `lsdist` that states whether the tree is included in the buffer.
"dat_sutton"


#' Parameters values for the best models
#'
#' Running all the simulations took hours. Tht is the reason why kept the parameters values for the best models in this dataset.
#'
#' @docType data
#' @keywords datasets
#' @name res_bestModels
#' @usage res_bestModels
#' @format A data frame of 49 rows and 28 columns.
"res_bestModels"
