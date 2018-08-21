#' Get parameters values.
#'
#' A function to get ranges and starting values for the parameters associated to
#' a given simulation.
#'
#' @author
#' Kevin Cazelles
#'
#' @param disp a logical. If \code{TRUE}, then dispersal parameters are returned.
#' @param favo a logical. If \code{TRUE}, then favorability parameters are returned.
#' @param neigh a logical. If \code{TRUE}, then neighborhood effect parameter is returned.
#' @param lognormal a logical. If \code{TRUE}, then the values of dispersal parameter are the one assocoated to a lognormal dispersal kernel, default is set to \code{FALSE}.
#' @param abbr an abbreviation for a tree species name.
#' @param full_names a logical. If \code{TRUE} teh scientific names of the tree species is returned.
#'
#' @return
#' A matrix including the parameters ranges and starting values.
#'
#' @export

getParameters <- function(disp = TRUE, favo = TRUE, neigh = TRUE, lognormal = FALSE) {
    cnm <- c("STR", "Pz", "scal", "shap", "pm", "pl", "pn", "pd", "ps", "pb")
    rnm <- c("start", "low", "high")
    delta <- 10^-5
    mat_par <- rbind(st <- c(100, 0.5, 1, 2, rep(0.5, 5), 1), lo <- c(0, 0, 0.02, 
        1, rep(0, 5), 0), hg <- c(10^6, 1, 20, 4, rep(1, 5), 1000))
    if (lognormal) {
        mat_par[, 3L] <- c(1, 0.01, 20)  # peak min = 1 cm max 20m
        mat_par[, 4L] <- c(1, delta, 5)
    }
    colnames(mat_par) <- cnm
    rownames(mat_par) <- rnm
    
    if (!disp) 
        mat_par <- mat_par[, !colnames(mat_par) %in% c("shap", "scal")]
    if (!favo) 
        mat_par <- mat_par[, !colnames(mat_par) %in% c("pm", "pl", "pn", "pd", "ps")]
    if (!neigh) 
        mat_par <- mat_par[, !colnames(mat_par) %in% c("pb")]
    
    mat_par
}


#' @describeIn getParameters Make the conversion between the two different abbreviation used for the names of tree species.
#' @export
convertTreeAbbr <- function(abbr, full_names = FALSE) {
    nm_sp <- c("ABBA", "ACRU", "ACSA", "BEAL", "BEPA", "FAGR", "POTR")
    nm_plt <- c("BF", "RM", "SM", "YB", "WB", "AB", "AS")
    nm_full <- c("Abies balsamea", "Acer rubrum", "Acer saccharum", "Betula alleghaniensis", 
        "Betula papyrifera", "Betula papyrifera", "Fagus grandifolia", "Populus tremuloides")
    # 
    stopifnot(abbr %in% nm_sp | abbr %in% nm_plt)
    # 
    vec1 <- nm_sp
    vec2 <- nm_plt
    if (abbr %in% nm_plt) {
        vec1 <- nm_plt
        vec2 <- nm_sp
    }
    # 
    if (full_names) {
        return(nm_full[which(vec1 == abbr)])
    } else {
        return(vec2[which(vec1 == abbr)])
    }
}
