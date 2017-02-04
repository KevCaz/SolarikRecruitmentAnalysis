#' Functions to format data.
#'
#' Apply a couple of simple steps to get data formated and therefore
#' ready to be analysed.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#'
#' @return
#' A list of dataset includin a set of trees and their location, 2 regen files
#' one for 2015, the author for 2016 including the seedling recruitment and
#' the favorability of all plots and also all disctance between plots and trees
#' and the list to indicate the trees including in a buffer.
#'
#' @param fl_trees a character string indicating path to the .csv file including the georeferenced trees.
#' @param fl_regen a character string indicating path to the .csv file including the plots' data for 2015 (seedling and favorability).
#' @param fl_regen2 a character string indicating path to the .csv file including the plots' data for 2016.
#' @param treesp a vector of abbreviation indicating the tree species considered.
#' @param abbr_site a character string giving the abbreviation of the site considered.
#' @param path_out a character string indicating the path to write the data files.
#' @param dist_buffer the buffering distance (in meters).
#' @param export logical. If \code{TRUE} then formated data are written as .rds files.
#'
#' @export

formatData <- function(fl_trees, fl_regen, fl_regen2, treesp, abbr_site, path_out = ".", 
    dist_buffer = 20, export = TRUE) {
    
    ## Import the data based on the path to the files given as arguments.  tree data
    trees <- read.csv(fl_trees, header = TRUE, stringsAsFactors = FALSE)
    # Regeneration data for 2015
    regen <- read.csv(fl_regen, header = TRUE, stringsAsFactors = FALSE)
    # Regeneration data for 2016
    regen2 <- read.csv(fl_regen2, header = TRUE, stringsAsFactors = FALSE)
    
    ## Subsetting (some plot are removed due to the border effect)
    regen %<>% subset(X > -5 & X < 165 & Y > 15 & Y < 185)
    regen2 %<>% subset(X > -5 & X < 165 & Y > 15 & Y < 185)
    
    ## List of distances between plots and
    lsdist <- list()
    for (i in 1:nrow(regen)) {
        lsdist[[i]] <- as.matrix(trees[, c("UTMX", "UTMY")]) %>% spDistsN1(as.matrix(regen[i, 
            c("UTMX", "UTMY")]))
    }
    
    ## Add basal area (with dist_buffer meters): total per species
    iddist <- lapply(lsdist, . %>% is_less_than(dist_buffer))
    regen$ba_tot <- regen2$ba_tot <- lapply(lsdist, function(x) (pi * 2.5e-05 * trees$DBH[x < 
        dist_buffer]^2) %>% sum) %>% unlist
    
    ## Buffering
    for (i in treesp) {
        id <- which(trees$SP != i)
        regen[paste0("ba_", i)] <- lapply(lsdist, function(x) (pi * 2.5e-05 * trees$DBH[id][x[id] < 
            dist_buffer]^2) %>% sum) %>% unlist
        regen2[paste0("ba_", i)] <- lapply(lsdist_abi, function(x) (pi * 2.5e-05 * 
            trees$DBH[id][x[id] < dist_buffer]^2) %>% sum) %>% unlist
    }
    
    ## Exporting R objects
    if (export) {
        saveRDS(trees, file = paste0(path_out, "/trees", abbr_site, ".rds"))
        saveRDS(regen, file = paste0(path_out, "/regen", abbr_site, "2015.rds"))
        saveRDS(regen2, file = paste0(path_out, "/regen", abbr_site, "2016.rds"))
        saveRDS(lsdist, file = paste0(path_out, "/lsdist", abbr_site, ".rds"))
        saveRDS(iddist, file = paste0(path_out, "/iddist", abbr_site, ".rds"))
    }
    
    ## Return all the data as a list.
    return(list(trees, regen, regen2, lsdist, iddist))
}