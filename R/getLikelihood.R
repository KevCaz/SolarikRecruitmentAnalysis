#' Compute the likelihood.
#'
#' This function computes the likelihood associated to a specific set of parameters.
#' The specification of parameters determines the ecological processes involved.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#'
#' @param pars vector of parameters values, the size must
#' @param obs vector of observations of recruitement for each plots of the stand.
#' @param zero_infl logical. If \code{TRUE} then a zero-inflated poisson distribution is used, otherwose a poisson distribution is used.
#' @param neigh a logical. If \code{NULL} (the default setting) the is  TRUE then neighborhood
#' @param disp a logical. If \code{NULL} (the default setting) the is  TRUE then neighborhood
#' @param favo a logical. If \code{NULL} (the default setting) the is  TRUE then neighborhood
#' @param SDBH a numeric vector of standarized DBH (Diameter at breast heights).
#' @param kernel a character string indicating which kernel should be used (either \code{kern_lognormal} or \code{kern_exponential_power}). See \link[recruitR]{kernels} for further details.
#' @param pstr position of paraneter in thevector of parameter values.
#' @param ppz the position of \code{pz} parameter within the vector of parameter values.
#' @param pscal An integer gving the position of the scale parameter (of the dispersal kernel) witin the vector of parameter values.
#' @param pshap An integer gving the position of the shape parameter (of the dispersal kernel) witin the vector of parameter values.
#' @param pfav A vector of integer indicating the position of the five favorability values within the vector of parameter values.
#' @param pneigh position of the parameter associated to the neighborhood effect in the vector of parameter values.
#' @param quiet logial. If \code{FALSE} then parameters and likelyhood estimations are printed.
#' @param record a connection, or a character string naming the file to print to. If \code{NULL}, the default values, no record is done.
#'
#' @export
#'
#' @details
#' The parameter \code{pz} have a value even if it is not included in the analysis (meaning a poisson distrubution is used).
#'
#' @return
#' The log-likelihood values associated to a given set of parameters.

getLikelihood <- function(pars, obs, zero_infl = FALSE, neigh = NULL, disp = NULL, 
    favo = NULL, SDBH = NULL, kernel = "kern_lognormal", pstr = NA, ppz = NA, pscal = NA, 
    pshap = NA, pfav = NA, pneigh = NA, quiet = TRUE, record = NULL) {
    
    ## Number of quadrats
    nbq <- length(obs)
    ## 
    STR <- pars[pstr]
    
    ## Favorability
    if (!is.null(favo)) {
        stopifnot(nrow(favo) == nbq | is.na(pars[pfav]))
        fa <- apply(favo, 1, weighted.mean, pars[pfav])
    } else fa <- 1
    ## Dispersal
    if (!is.null(disp)) {
        stopifnot(length(disp) == nbq | is.na(pars[pscal]) | is.na(pars[pshap]))
        ## 
        kernel %<>% paste0("recruitR::", .)
        di0 <- disp %>% lapply(kernel, shap = pars[pshap], scal = pars[pscal])
        di <- sapply(1:nbq, FUN = function(x) sum(di0[[x]] * SDBH[[x]])) %>% unlist
    } else di <- 1
    ## Neighborhood
    if (!is.null(neigh)) {
        stopifnot(length(neigh) == nbq | is.na(pars[pneigh]))
        ne <- exp(-pars[pneigh] * neigh)
    } else ne <- 1
    
    ## Computing R
    R <- STR * rep(1, nbq) * di * fa * ne
    
    ## Fitting (include the selection of the proper distribution)
    if (zero_infl) {
        Pz <- pars[ppz]
        ## Zero-inflated Poisson distribution
        lik = double(length(obs))
        if (length(obs == 0) > 0) 
            lik[obs == 0] = Pz + (1 - Pz) * dpois(obs[obs == 0], lambda = R[obs == 
                0])
        if (length(obs > 0) > 0) 
            lik[obs > 0] = (1 - Pz) * dpois(obs[obs > 0], lambda = R[obs > 0])
    } else lik <- dpois(obs, lambda = R)
    
    ## Sum of log-likelihood
    out <- -sum(log(lik))
    if (!is.null(record)) {
        if (!is.infinite(out)) 
            cat(c(out, pars), "\n", file = record, append = TRUE)
    }
    if (!quiet) {
        print(pars)
        print(out)
    }
    
    return(out)
}
