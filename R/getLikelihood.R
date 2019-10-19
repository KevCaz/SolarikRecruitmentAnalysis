#' Compute the likelihood.
#'
#' This function computes the likelihood associated to a specific set of
#' parameters, i.e. a specific. Note that the parameters included determine the
#' ecological processes considered.
#'
#' @importFrom magrittr %>% %<>%
#'
#' @param pars vector of parameters values.
#' @param obs vector of observations of recruitment for each plots of the stand.
#' @param zero_infl a logical. If `TRUE` then a zero-inflated poisson distribution is used, otherwise a poisson distribution is used.
#' @param neigh a vector of the size of `obs` describing the surrounding neighborhood. If `NULL` (the default setting) then neighborhood is not included in the model.
#' @param disp a vector of the size of `obs` of the surrounding trees of the focal species where seeds may be dispersed from. If `NULL` then dispersal is not included in the model.
#' @param favo a vector of the size of `obs` describing the composition of all parcel. If `NULL` then the soil favourability is not included in the model.
#' @param SDBH a numeric vector of standardized DBH (Diameter at breast heights).
#' @param kernel a character string indicating which kernel should be used (either [diskers::kern_lognormal()] or [diskers::kern_exponential_power()].
#' @param pstr position of parameter `str` in the vector of parameter values.
#' @param ppz position of `pz` parameter within the vector of parameter values.
#' @param pscal position of the scale parameter (of the dispersal kernel) within the vector of parameter values.
#' @param pshap the position of the shape parameter (of the dispersal kernel) within the vector of parameter values.
#' @param pfav the position of the five favourability values within the vector of parameter values.
#' @param pneigh position of the parameter associated to the neighborhood effect in the vector of parameter values.
#' @param quiet a logical. If `FALSE` then parameters and likelihood estimations are printed.
#' @param record a connection, or a character string naming the file to print to. If `NULL` then this step is skipped.
#'
#' @export
#'
#' @details
#' The parameter `pz` have a value even if it is not included in the analysis (meaning a poisson distribution is used).
#'
#' @importFrom stats weighted.mean dpois
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

    ## Neighborhood
    if (!is.null(neigh)) {
        stopifnot(length(neigh) == nbq | is.na(pars[pneigh]))
        ne <- exp(-pars[pneigh] * neigh)
    } else ne <- 1
    ## Dispersal
    if (!is.null(disp)) {
        stopifnot(length(disp) == nbq | is.na(pars[pscal]) | is.na(pars[pshap]))
        ##
        kernel <- paste0("diskers::", kernel)
        di0 <- disp %>% lapply(kernel, shap = pars[pshap], scal = pars[pscal])
        di <- sapply(1:nbq, FUN = function(x) sum(di0[[x]] * SDBH[[x]])) %>% unlist
    } else di <- 1
    ## Favourability
    if (!is.null(favo)) {
        stopifnot(nrow(favo) == nbq | is.na(pars[pfav]))
        fa <- apply(favo, 1, weighted.mean, pars[pfav])
    } else fa <- 1

    ## Computing R
    R <- STR * rep(1, nbq) * di * fa * ne

    ## Fitting (include the selection of the proper distribution)
    if (zero_infl) {
        Pz <- pars[ppz]
        ## Zero-inflated Poisson distribution
        lik = double(length(obs))
        if (length(obs == 0) > 0)
            lik[obs == 0] = Pz + (1 - Pz) * dpois(obs[obs == 0],
              lambda = R[obs == 0])
        if (length(obs > 0) > 0)
            lik[obs > 0] = (1 - Pz) * dpois(obs[obs > 0], lambda = R[obs >
                0])
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
    ##
    out
}
