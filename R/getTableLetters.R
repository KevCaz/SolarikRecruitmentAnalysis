#' Get tables describing best models with letters.
#'
#' Get tables describing best models with letters.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>%
#'
#' @param tmp a data.frame including results.
#' @param year the year for which the table is produce.
#'
#' @return
#' A character matrix indicating the processes involved in the best model for the different seedlings.
#'
#' @export


getTableLetters <- function(tmp, year) {
    ## 
    id <- which(tmp$year == year)
    tmp <- tmp[id, ]
    nsite <- length(unique(tmp$site))
    nspe <- length(unique(tmp$tree))
    addlet <- function(x, let) paste(c(x, let), collapse = "")
    nsage <- paste0(rep(as.character(unique(tmp$site)), each = 2), "_", 1:2)
    out <- matrix("absent", nrow = nspe, ncol = length(nsage))
    colnames(out) <- nsage
    rownames(out) <- unique(tmp$tree) %>% as.character
    ## Letters assigned for dispersion
    dislet <- c("dc", "d-", "Dc", "D-")
    ## 
    tmp2 <- tmp[tmp$best, ]
    # 
    for (i in 1:nrow(tmp2)) {
        let <- ""
        if (tmp2$pz[i]) {
            let <- addlet(let, "Z")
        } else let <- addlet(let, "-")
        ## Letter for dispersion
        if (tmp2$disp[i]) {
            let <- addlet(let, dislet[tmp2$disp[i]])
        } else let <- addlet(let, "--")
        ## Letter for favorability
        if (tmp2$favo[i]) {
            let <- addlet(let, "F")
        } else let <- addlet(let, "-")
        ## Letter for the neighborhood effect
        if (tmp2$neigh[i]) {
            let <- addlet(let, "N")
        } else let <- addlet(let, "-")
        ## 
        nr <- which(rownames(out) == as.character(tmp2$tree[i]))
        nc <- which(colnames(out) == paste0(as.character(tmp2$site[i]), "_", as.character(tmp2$age[i])))
        out[nr, nc] <- let
    }
    ## 
    return(out)
}
