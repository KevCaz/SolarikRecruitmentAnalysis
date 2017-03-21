#' Draw kernels.
#'
#' A function used to display the kernels associated to the best models.
#'
#' @author
#' Kevin Cazelles
#'
#' @param datares the dataframe returned by the recruitement analysis.
#' @param filename a character string, giving the names of the figure to be drawn.
#' @param xlim numeric vectors of length 2, giving the x coordinates ranges.
#' @param ylim numeric vectors of length 2, giving the y coordinates ranges.
#'
#' @export

figKernels <- function(datares, filename = "../figs/fig1.pdf", xlim = c(0, 50), ylim = c(0, 
    0.015), colors = c("#771224", "#31679f", "#6db80f", "grey10")) {
    ## 
    nm_tre <- as.character(unique(datares$tree))
    ## Colors
    pal <- rep(colors, length.out = length(nm_tre))
    ## Line types
    lty <- rep(c(1, 2), each = 4, length.out = length(nm_tre))
    ## text size
    cex.txt <- 2
    ## 
    matlay <- cbind(7, rbind(8, matrix(1:6, 2), 9))
    matlay[c(1, 4), 1] <- 0
    seqd <- seq(xlim[1], xlim[2], 0.01)
    ## 
    datares$tosplit <- paste0(datares$site, datares$age)
    ls_tre <- split(datares, datares$tosplit)
    #### export as a pdf files.
    pdf(filename, height = 6.5, width = 9)
    layout(mat = matlay, widths = c(0.2, 1, 1, 1), heights = c(0.15, 1, 1, 0.5))
    par(mar = c(1.5, 2.25, 0.5, 1.25), las = 1, mgp = c(2.2, 0.75, 0))
    ## 
    for (i in 1:length(ls_tre)) {
        graphicsutils::plot0(xlim, ylim)
        axis(1, lwd = 0, lwd.tick = 0.5)
        axis(2, lwd = 0, lwd.tick = 0.5)
        for (j in 1:nrow(ls_tre[[i]])) {
            if (ls_tre[[i]]$disp[j]) {
                id <- as.numeric(ls_tre[[i]]$tree[j])
                if (ls_tre[[i]]$disp[j] > 2) {
                  seqy <- kern_exponential_power(seqd, scal = ls_tre[[i]]$scal[j], 
                    shap = ls_tre[[i]]$shap[j])
                } else {
                  seqy <- kern_lognormal(seqd, scal = ls_tre[[i]]$scal[j], shap = ls_tre[[i]]$shap[j])
                }
                lines(seqd, seqy, col = pal[id], lty = lty[id], lwd = 1.4)
            }
        }
        text(percX(80), percY(92), paste0("Age: ", 2 - i%%2), cex = 1.6)
        box2(1:2)
    }
    ## 
    par(mar = c(1.5, 0, 1, 0))
    graphicsutils::plot0()
    text(-0.2, 0, labels = "Density", srt = 90, cex = cex.txt)
    ## 
    par(mar = c(0.1, 2, 0, 1), xaxs = "i")
    graphicsutils::plot0(c(0, 3), c(0, 1))
    text(c(0.12, 1.17, 2.24), rep(0.5, 3), labels = c("ABI", "BIC", "SUT"), cex = cex.txt)
    ## 
    graphicsutils::plot0()
    text(0, 0.7, labels = "Distance (m)", cex = cex.txt)
    ## 
    legend("bottom", bty = "n", legend = nm_tre, lwd = 2.4, lty = lty, seg.len = 2, 
        col = pal, ncol = 4, cex = 1.8)
    dev.off()
    ## 
    return("DONE")
}
