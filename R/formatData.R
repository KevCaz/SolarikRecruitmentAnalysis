#' Format data.
#'
#' Format datasets for the recruitment analysis. Note that this function was
#' used at a early stage if the development.
#'
#' @author
#' Kevin Cazelles
#'
#' @importFrom magrittr %>% %<>% %T>%
#'
#' @return
#' A list of datasets including a set of trees and their spatial coordinates, 2 #' '`regen` files: one for 2015 and the other for 2016 including the seedling
#' recruitment and the favourability of all plots and also all distances between
#' plots and trees and a list of trees included in a buffer.
#'
#' @param fl_trees a character string indicating path to the `.csv `file including the georeferenced trees.
#' @param fl_regen a character string indicating path to the `.csv` file including regeneration data for 2015 and 2016.
#' @param fl_favo a character string indicating path to the `.csv` file including favourability data.
#' @param treesp a vector of abbreviation indicating the tree species considered.
#' @param abbr_site a character string giving the abbreviation of the site considered.
#' @param path_out a character string indicating the path to write the data files.
#' @param dist_buffer the buffering distance (in meters).
#' @param export logical. If `TRUE`, then formatted data are written as `.rds` files.
#'
#' @importFrom utils read.csv
#' @importFrom sp spDistsN1
#' @export

formatData <- function(fl_trees, fl_regen, fl_favo = NULL,
    treesp = unique(simuDesign$tree), abbr_site = "abi", path_out = "output",
    dist_buffer = 20, export = TRUE) {

    ## Import the data based on the path to the files given as arguments.
    ## tree data
    trees <- read.csv(fl_trees, header = TRUE, stringsAsFactors = FALSE)
    ## remove trees with na as coordinates (for Sutton)
    trees <- trees[!is.na(trees$X),]
    ## Regeneration data for 2015 and 2016
    regen <- read.csv(fl_regen, header = TRUE, stringsAsFactors = FALSE)

    ## Subsetting (some plot are removed due to the border effect)
    regen2015 <- subset(regen[regen$Year == 2015, ],
        X > -5 & X < 165 & Y > 15 & Y < 185)
    regen2016 <- subset(regen[regen$Year == 2016, ],
        X > -5 & X < 165 & Y > 15 & Y < 185)


    ## List of distances between trees and plots. Note that plots were the same
    ## for regen2015 and regen2016
    lsdist <- list()
    for (i in seq_len(nrow(regen2015))) {
        lsdist[[i]] <- spDistsN1(as.matrix(trees[, c("X", "Y")]),
          as.matrix(regen2015[i, c("X", "Y")]))
    }

    ## Add basal area (with dist_buffer meters): total per species
    iddist <- lapply(lsdist, `<`, dist_buffer)
    regen2015$ba_tot <- regen2016$ba_tot <- unlist(
      lapply(lsdist, function(x) sum(pi*2.5e-5*trees$DBH[x <dist_buffer]^2))
    )

    ## Buffering (return the id of trees within 25m buffer and the basal area
    ## associated for all studied species)
    # ensure that species considered are present
    treesp <- treesp[treesp %in% unique(trees$SP)]
    for (i in treesp) {
        # exlude the focals species
        id <- which(trees$SP != i)
        regen2015[paste0("ba_", i)] <- unlist(
          lapply(lsdist,
            function(x) sum(pi*2.5e-5*trees$DBH[id][x[id] < dist_buffer]^2)
          ))
    }

    ## Exporting objects as files
    if (export) {
        export_file(trees, path_out, "/trees", abbr_site)
        export_file(regen2015, path_out, "/regen", abbr_site, "2015")
        export_file(regen2016, path_out, "/regen", abbr_site, "2016")
        export_file(lsdist, path_out, "/lsdist", abbr_site)
        export_file(iddist, path_out, "/iddist", abbr_site)
    }

    ## data as a list.
    list(trees, regen2015, regen2016, lsdist, iddist)
}

export_file <- function(obj, path, nmf, site, year = "") {
  saveRDS(obj, file = paste0(path, nmf, site, year, ".rds"))
}
