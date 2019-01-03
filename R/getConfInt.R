#' Get Confidence Intervals.
#'
#' This function returns confidence interval of paramters associated to a givem simulation output file.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>%
#' @importFrom magrittr %T>%
#'
#' @param filename a character string, giving the path of output file to be read.
#' @param iter a interger indentifying the iteration.
#' @param simu a data frame describing the simulation.
#' @param basename_out basename of the file where results are written.
#' @param quiet logical. If \code{FALSE} then the id of the simulation is printed.
#'
#' @return
#' A list including the likelihood and the parameters estimates as well as the confident interval associates to the parameters.
#'
#' @export

# getConfInt('inst/res/test.txt', simuDesign, 16)

getConfInt <- function(filename, simu, iter, basename_out = "inst/resf_", quiet = TRUE) {
    #
    sim <- simu[iter, ]
    ## read *id* simue of datasim
    out <- getParameters(disp = (sim$disp > 0), favo = sim$favo, neigh = sim$neigh)
    ## the estimation in the minimum not the last one!
    tmp <- try(utils::read.table(filename, dec = ".", sep = ""))
    if (class(tmp) != "try-error") {
        idmn <- which.min(tmp[, 1L])
        vec <- 2 * (tmp[, 1L] - tmp[idmn, 1L])
        val <- which(vec < stats::qchisq(0.95, df = 1L))
        for (i in 1L:ncol(out)) {
            out[1L, i] <- tmp[idmn, i + 1]
            out[2L, i] <- min(tmp[val, i + 1])
            out[3L, i] <- max(tmp[val, i + 1])
        }
        lik <- tmp[idmn, 1L]
    } else {
        lik <- Inf
    }
    ## Make the list to be returned
    ls_out <- list(likelihood = lik, pars = out) %T>% saveRDS(file = paste0(basename_out, sprintf("%04d", iter), ".rds"))
    ##
    ls_out
}


getIter <- function(filename, rm_pat = "codekev12") {
    ## The names of the files to be read countains the id, we get below.
    filename %>% gsub(pattern = rm_pat, replacement = "") %>% gsub(pattern = "\\D",
        replacement = "") %>% as.numeric
}
