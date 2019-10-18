#' Functions to format data.
#'
#' Apply a couple of simple steps to get data formatted and therefore
#' ready to be analyzed.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>% %<>% %T>%
#'
#' @return
#' A list of dataset including a set of trees and their location, 2 `regen` files
#' one for 2015 and the other for 2016 including the seedling recruitment and
#' the favourability of all plots and also all distance between plots and trees
#' and the list to indicate the trees including in a buffer.
#'
#' @param fl_trees a character string indicating path to the `.csv `file including the georeferenced trees.
#' @param fl_regen a character string indicating path to the `.csv` file including the plots' data for 2015 (seedling and favourability).
#' @param fl_regen2 a character string indicating path to the `.csv` file including the plots' data for 2016.
#' @param treesp a vector of abbreviation indicating the tree species considered.
#' @param abbr_site a character string giving the abbreviation of the site considered.
#' @param path_out a character string indicating the path to write the data files.
#' @param dist_buffer the buffering distance (in meters).
#' @param export logical. If `TRUE` then formatted data are written as .rds files.
#'
#' @importFrom utils read.csv
#' @importFrom sp spDistsN1
#' @export

formatData <- function(fl_trees, fl_regen, fl_regen2, treesp, abbr_site, path_out = "output",
    dist_buffer = 20, export = TRUE) {

    ## Import the data based on the path to the files given as arguments.  tree data
    trees <- read.csv(fl_trees, header = TRUE, stringsAsFactors = FALSE)
    ## Regeneration data for 2015
    regen_0 <- read.csv(fl_regen, header = TRUE, stringsAsFactors = FALSE)
    ## Regeneration data for 2016
    regen2_0 <- read.csv(fl_regen2, header = TRUE, stringsAsFactors = FALSE)

    ## Subsetting (some plot are removed due to the border effect)
    regen <- subset(regen_0, X > -5 & X < 165 & Y > 15 & Y < 185)
    regen2 %<>% subset(regen_0, X > -5 & X < 165 & Y > 15 & Y < 185)

    ## List of distances between plots and
    lsdist <- list()
    for (i in seq_len(nrow(regen))) {
        lsdist[[i]] <- as.matrix(trees[, c("UTMX", "UTMY")]) %>%
            spDistsN1(as.matrix(regen[i, c("UTMX", "UTMY")]))
    }

    ## Add basal area (with dist_buffer meters): total per species
    iddist <- lapply(lsdist, `<`, dist_buffer)
    regen$ba_tot <- regen2$ba_tot <- lapply(lsdist,
        function(x) sum(pi * 2.5e-05 * trees$DBH[x <dist_buffer]^2)) %>% unlist

    ## Buffering (return the id of the tree withing the buffer and the basal area
    ## associated for all studied species)
    for (i in treesp) {
        id <- which(trees$SP != i)
        regen[paste0("ba_", i)] <- lapply(lsdist, function(x) sum(
          pi * 2.5e-05 * trees$DBH[id][x[id] < dist_buffer]^2)) %>% unlist
    }

    ## Exporting R objects
    if (export) {
        export_file(trees, path_out, "/trees", abbr_site)
        export_file(regen, path_out, "/regen", abbr_site, "2015")
        export_file(regen2, path_out, "/regen", abbr_site, "2016")
        export_file(lsdist, path_out, "/lsdist", abbr_site)
        export_file(iddist, path_out, "/iddist", abbr_site)
    }

    ## data as a list.
    list(trees, regen, regen2, lsdist, iddist)
}

export_file <- function(obj, path, nmf, site, year = "") {
  saveRDS(obj, file = paste0(path, nmf, site, year, ".rds"))
}
