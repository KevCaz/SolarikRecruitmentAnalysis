#' Get Confidence Interval.
#'
#' A function to get confidence interval of paramters associated to one simulation.
#'
#' @author
#' Kevin Cazelles
#'
#' @param filename of the file to be
#' @param rm_pat a pattern to be removed.
#' @param basename_out basename of the file where results are written.
#' @param datasim the path of the file of simulatipon.
#' @param quiet logical. If \code{FALSE} then the id of the simulation is printed.
#'
#' @export

getConfInt <- function(filename, rm_pat = "codekev12", basename_out = "../codekev12/resf/resf_", 
    datasim = "dataReady/simu_all.Rds", quiet = TRUE) {
    
    ## The names of the files to be read countains the id, we get below.
    id <- filename %>% gsub(pat = rm_pat, rep = "") %>% gsub(pat = "\\D", rep = "") %>% 
        as.numeric
    ## 
    if (!quiet) 
        print(id)
    ## read *id* line of datasim
    lin <- readRDS(file = datasim)[id, ]
    ## disp = TRUE, favo = TRUE, neig
    out <- getParameters(disp = (lin$disp > 0), favo = lin$favo, neigh = lin$neigh)
    ## the estimation in the minimum not the last one!
    tmp <- try(read.table(filename, dec = ".", sep = ""))
    if (class(tmp) != "try-error") {
        idmn <- which.min(tmp[, 1L])
        vec <- 2 * (tmp[, 1L] - tmp[idmn, 1L])
        val <- which(vec < qchisq(0.95, df = 1L))
        for (i in 1L:ncol(out)) {
            out[1L, i] <- tmp[idmn, i + 1]
            out[2L, i] <- min(tmp[val, i + 1])
            out[3L, i] <- max(tmp[val, i + 1])
        }
        lik <- tmp[idmn, 1L]
    } else {
        lik <- Inf
    }
    ## make the list to be returned
    ls_out <- list(likelihood = lik, pars = out) %T>% saveRDS(file = paste0(basename_out, 
        letiRmisc::adjustString(id, 4L), ".Rds"))
    # 
    return(ls_out)
}
