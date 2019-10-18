#' Draw kernels.
#'
#' Draws kernels of the best models.
#'
#' @author
#' Kevin Cazelles
#'
#' @param datares a data frame that contains the best models.
#' @param age age of the seedling for which the figure is drawn (either 1 or 2).
#' @param xlim numeric vectors of length 2, giving the x coordinates ranges.
#' @param ylim numeric vectors of length 2, giving the y coordinates ranges.
#' @param colors vector of colors.
#'
#' @importFrom graphicsutils plot0 percX percY
#' @importFrom graphics axis par layout legend lines points text box mtext
#' @importFrom diskers kern_exponential_power kern_lognormal
#'
#' @export
#'
#' @examples
#' figKernels(res_bestModels)



figKernels <- function(datares, age = 1, xlim = c(0, 50), ylim = c(0, 0.015),
  colors = c("#6b2934", "#4899c7", "#c8de86", "grey10")) {
    ##
    nm_tre <- as.character(unique(datares$tree))
    ## Colors
    pal <- rep(colors, length.out = length(nm_tre))
    ## Line types
    lty <- rep(c(1, 2), each = 4, length.out = length(nm_tre))
    ## text size
    cex.txt <- 1.1
    ## Layout matrix
    matlay <- cbind(7, rbind(matrix(1:6, 2), 8))
    matlay[3, 1] <- 0
    ##
    seqd <- seq(xlim[1], xlim[2], .01)
    ##
    # datares <- datares[datares$year == year, ]
    datares <- datares[datares$age == age, ]
    # datares$tosplit <- paste0(datares$site, datares$year)
    datares$tosplit <- paste0(datares$site, datares$year)
    ls_tre <- split(datares, datares$tosplit)

    regions <- c("Abitibi", "", "Le Bic",  "", "Sutton", "")
    ##
    layout(mat = matlay, widths = c(0.33, 1, 1, 1), heights = c(1, 1, 0.36))
    par(mar = c(1.2, 2, 0.5, .5), las = 1, cex.axis = .6, lend = 1, tck = -0.05)
    ##
    for (i in seq_along(ls_tre)) {
        plot0(xlim, ylim)
        mtext(regions[i], side = 3, line = -1, at = 40, cex = .7*cex.txt)
        par(mgp = c(1, 0.5, 0))
        axis(1, lwd = 0, lwd.ticks = .5, mgp = c(2, .2, 0))
        axis(2, lwd = 0, lwd.ticks = .5, mgp = c(2, .5, 0))
        for (j in seq_len(nrow(ls_tre[[i]]))) {
            if (ls_tre[[i]]$disp[j]) {
                id <- as.numeric(ls_tre[[i]]$tree[j])
                if (ls_tre[[i]]$disp[j] > 2) {
                  seqy <- kern_exponential_power(seqd, scal = ls_tre[[i]]$scal[j],
                    shap = ls_tre[[i]]$shap[j])
                } else {
                  seqy <- kern_lognormal(seqd, scal = ls_tre[[i]]$scal[j],
                    shap = ls_tre[[i]]$shap[j])
                }
                lines(seqd, seqy, col = pal[id], lty = lty[id], lwd = 1)
            }
        }
        box(bty = "l")
    }
    ##
    par(mar = c(1.2, 0, .5, 0))
    plot0()
    text(-0.4, 0, labels = expression("Probability Density (1/"*m^2*")"),
      srt = 90, cex = cex.txt)
    text(rep(0.6, 2), c(-.59,.59), labels = c(2016, 2015), srt = 90, cex = .9*cex.txt)
    ##
    # par(mar = c(0.1, 2, 0, 1), xaxs = "i")
    # plot0(c(0, 3), c(0, 1))
    # text(c(0.12, 1.17, 2.24), rep(0.5, 3), labels = c("Aitibi", "Bic", "Sutton"), cex = cex.txt)
    ##
    par(mar = c(.5, 0, .1, 0))
    plot0()
    text(0, 0.72, labels = "Distance (m)", cex = cex.txt)
    ##
    legend("bottom", bty = "n", legend = nm_tre, lwd = 1.4, lty = lty,
      seg.len = 2.7, col = pal, ncol = 7, cex = .77)
    ##
    invisible(NULL)
}

# png("fig5.png", width = 120, height = 80, units = "mm", res = 600)
#  figKernels(res_bestModels)
# dev.off()
# png("figSI_age2.png", width = 120, height = 80, units = "mm", res = 600)
#  figKernels(res_bestModels, age = 2)
# dev.off()
