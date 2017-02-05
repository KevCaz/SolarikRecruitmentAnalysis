#' Recruitement analayis .
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
#' @param site site name.
#' @param year year (2015 or 2016) name.
#' @param tree abbreviation of the tree species names of the species.
#' @param age age of the species (1 or 2).
#' @param mat_par a matrix of parameters (see \link[seedlingsRecruitmentAnalysis]{getParameters}).
#' @param path a character string giving the path to access the data.
#' @param zero_infl logical. If \code{TRUE} then a zero-inflated poisson distribution is used, otherwose a poisson distribution is used.
#' @param disp a logical. If \code{TRUE}, then dispersal parameters are used.
#' @param favo a logical. If \code{TRUE}, then favorability parameters are used.
#' @param neigh a logical. If \code{TRUE}, then neighborhood effect parameter is used.
#' @param clip a numeric vector of standarized DBH (Diameter at breast heights).
#' @param kernel a character string indicating which kernel should be used (either \code{kern_lognormal} or \code{kern_exponential_power}). See \link[recruitR]{kernels} for further details.
#' @param mxt a numeric. Maximum running time in seconds (see \link[GenSA]{GenSA}).
#' @param quiet logial. If \code{TRUE} details about the state of simulations are printed.
#' @param record a connection, or a character string naming the file to print to. If \code{NULL}, the default values, no record is done.
#' @param iter a interget
#' @param simu_file
#'
#' @export
#'
#' @details
#' The parameter \code{pz} have a value even if it is not included in the analysis (meaning a poisson distrubution is used).
#'
#' @return
#' The log-likelihood values associated to a given set of parameters.

recuitmentAnalysis <- function(site, year, tree, age, mat_par, path = "dataReady/", 
    zero_infl = FALSE, disp = FALSE, favo = FALSE, neigh = FALSE, clip = NULL, kernel = "kern_lognormal", 
    mxt = 100, quiet = TRUE, record = NULL) {
    ## Importing the data
    reg <- paste0(path, "regen", site, year, ".Rds") %>% readRDS
    tre <- paste0(path, "trees", site, ".Rds") %>% readRDS
    ## Getting the observations
    obs <- reg[, paste0(convertTreeAbbr(tree), "_", age)]
    ## 
    ker <- FALSE
    if (kernel == "kern_lognormal") {
        ker <- TRUE
    }
    pars <- getParameters(disp, favo, neigh, kernel = ker)
    ## Finding the index of parameters
    pstr <- which(colnames(pars) == "STR")
    ppz <- which(colnames(pars) == "Pz")
    pscal <- which(colnames(pars) == "scal")
    pshap <- which(colnames(pars) == "shap")
    pfav <- which(colnames(pars) %in% c("pm", "pl", "pn", "pd", "ps"))
    pneigh <- which(colnames(pars) == "pb")
    
    ## 
    id_tre <- which(tre$SP == tree)
    nbq <- length(obs)
    ##-- disp
    if (disp) {
        disp0 <- paste0(path, "lsdist", site, ".Rds") %>% readRDS %>% lapply(FUN = function(x) x[id_tre])
        ##-- Getting a liste of distances/dbh matrices, one per quadrat.
        SDBH0 <- (tre$DBH[id_tre] * tre$DBH[id_tre])/900
        ## clipping
        if (!is.null(clip)) {
            ls_id <- lapply(disp0, function(x) which(x < clip))
            disp <- list()
            SDBH <- list()
            for (i in 1:nbq) {
                disp[[i]] <- disp0[[i]][ls_id[[i]]]
                SDBH[[i]] <- SDBH0[ls_id[[i]]]
            }
        } else {
            disp <- disp0
            SDBH <- rep(list(SDBH0), nbq)
        }
    } else {
        disp <- NULL
        SDBH <- NULL
    }
    if (!quiet) 
        print(pars)
    ## 
    if (favo) {
        ## same order as in the parameters dataframe
        favo <- 0.01 * reg[, c("moss", "leaf", "needle", "deciduous", "soft")]
    } else favo <- NULL
    ##-- neigh
    if (neigh) {
        ## basal area of heterospecific spcirs clipped at 20m
        neigh <- reg[, paste0("ba_", tree)]
    } else neigh <- NULL
    
    # Call of the GenSA function, according to the documentation of GenSa function
    # for problems with reasonable complexity, we can quickly get a good estimate
    # even if the minimum is not reached therefore we used the argument maxtime!
    if (!quiet) 
        cat("Calling GenSA for a maxtime of", mxt, "sec \n  ")
    ####### 
    resSA <- GenSA::GenSA(par = pars[1L, ], fn = lik_all, lower = pars[2L, ], upper = pars[3L, 
        ], control = list(verbose = TRUE, max.time = mxt, smooth = FALSE), obs = obs, 
        zero_infl = zero_infl, disp = disp, SDBH = SDBH, kernel = "kern_lognormal", 
        neigh = neigh, favo = favo, quiet = quiet, pstr = pstr, ppz = ppz, pscal = pscal, 
        pshap = pshap, pfav = pfav, pneigh = pneigh, record = record)
    # 
    return(resSA)
}


#' @describeIn recuitmentAnalysis Lauch the analysis for a given row of the simulation dataframe.
#' @export
launchIt <- function(iter, simu_file = "dataReady/simu_all.Rds", mxt = 100, record = "test.txt", 
    quiet = TRUE) {
    ## 
    simu <- readRDS(simu_file)
    simu$site %<>% as.character
    simu$tree %<>% as.character
    simu$age %<>% as.character
    sim <- simu[iter, ]
    if (!quiet) 
        print(sim)
    ## 
    if (sim$disp > 0) {
        disp <- TRUE
        ## 
        if (sim$disp > 2) {
            kernel = "kern_exponential_power"
        } else kernel = "kern_lognormal"
        ## even => non-clipped / odd => clip
        if (sim$disp%%2) {
            clip = 20
        } else clip = NULL
        ## 
        res <- recuitmentAnalysis(sim$site, sim$year, sim$tree, sim$age, favo = sim$favo, 
            disp = TRUE, neigh = sim$neigh, zero_infl = sim$pz, kernel = kernel, 
            clip = clip, quiet = quiet, mxt = mxt, record = record)
    } else {
        res <- recuitmentAnalysis(sim$site, sim$year, sim$tree, sim$age, favo = sim$favo, 
            disp = FALSE, neigh = sim$neigh, zero_infl = sim$pz, mxt = mxt, quiet = quiet, 
            record = record)
    }
    return(res)
}
