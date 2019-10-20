# RDA ANALYSIS - Chapter 3
# Abitibi Site Specific


rdaRegen <- function(dat) {

  ### start with regen formatted for 2016 / 2015
  ## and isolate substrate data and basal area data for different species
  # substrate <- data$regen2015[, 19:27]
  # basal2015 <- data$regen2014[, 13:18]
  # regen2015 <- data$regen2015[, 5:12]
  # regen2016 <- data$regen2015[, 5:12]


  ###################### Reshaping Overstorey -

  # http://seananderson.ca/2013/10/19/reshape.html

  # Creating a tree matrix. (FOR RELATIVE BASAL AREA - to change to TOTAL - switch
  # the 5 to a 3 and 'rel' to 'ba')

  #XXX
  # tree_matt <- dcast(id_regen ~ SP, data = ba_tree[, c(1:2, 3)], fill = 0, value.var = "ba")
  # tree_matt$id_regen <- as.numeric(tree_matt$id_regen)
  # class(tree_matt$id_regen)
  #
  # # Ordering Trees by Regeneration Plot
  # tree_order <- tree_matt[order(tree_matt$id_regen), ]
  # rownames(tree_order) <- tree_order$id_regen
  # head(tree_order)
  #
  # tree_ord <- tree_order[, -c(1)]
  # head(tree_ord)
  #
  ##################################################################################

  # Standardize Data - Scaling ... scl is explained: 0: none, 1: sites, 2:species,
  # 3: symmetric

  ##################################################################################

  # Overstorey
  treescale = as.data.frame(cbind(tree_order[, 1, drop = F], scale(tree_order[,
    2:5])))
  trees <- treescale[, -1]

  ########################## Substate
  head(substrate)


  `?`(`?`(decostand))
  subsqrt = as.data.frame(cbind(substrate[, 1:3, drop = F], scale(substrate[, 4:13])))

  substratescale = as.data.frame(cbind(substrate[, 1:3, drop = F], scale(substrate[,
    4:13])))
  substrateclean <- substratescale[, -c(1:3)]
  head(substrateclean)

  # 2016
  subsqrt = as.data.frame(cbind(substrate[, 1:3, drop = F], scale(substrate[, 4:12])))

  substratescale = as.data.frame(cbind(substrate[, 1:3, drop = F], scale(substrate[,
    4:12])))
  substrateclean <- substratescale[, -c(1:3)]
  head(substrateclean)

  ######################### Regeneration
  regensquare = as.data.frame(cbind(regen[, 1:3, drop = F], sqrt(regen[, 4:19])))
  head(regensquare)

  regen_scale = as.data.frame(cbind(regensquare[, 1:3, drop = F], scale(regensquare[,
    4:19])))
  regenscale <- regen_scale[, -c(1:3)]
  head(regenscale)

  ###################################################################################################




  # RDA ANALYSIS


  #################################### SUBSTRATE

  # Standardize Data - Scaling ... scl is explained: 0: none, 1: sites, 2:species,
  # 3: symmetric Substrate is the response matrix, and Trees are the explanatory
  # variable

  # Hellinger-Transformation

  head(substrate)
  sub.hel <- decostand(substrate, "hellinger")
  head(sub.hel)
  subhel <- sub.hel[, -c(1:4, 9, 11:13)]

  tiff("abitibi.tiff", width = 10, height = 10, units = "in", res = 300)
  RDAsubstrate <- rda(subhel, trees, scale = TRUE)
  scl <- 3
  plot(RDAsubstrate, scaling = scl, cex = 1.5, xlab = "RDA axis 1 (4.13% of variation explained)",
    ylab = ("RDA axis 2 = 1.48% of variation explained "))
  text(RDAsubstrate, display = "species", cex = 1.2, scaling = scl, col = 1, pos = 1)
  arrows(0, 0, scores(RDAsubstrate, lcol = "red", display = "species", choices = c(1),
    scaling = scl), scores(RDAsubstrate, display = "species", choices = c(2),
    scaling = scl, lwd = 1, code = 2, lty = 1))
  dev.off()


  summary(RDAsubstrate, display = NULL)
  RsquareAdj(RDAsubstrate)

  # Running ANOVA on data
  anova.cca(RDAsubstrate, step = 10000)


  # 2016
  head(substrate2)
  sub.hel2 <- decostand(substrate2, "hellinger")
  head(sub.hel2)
  subhel2 <- sub.hel2[, -c(1:4, 9, 11:12)]

  RDAsubstrate <- rda(subhel2, trees, scale = TRUE)
  scl <- 3
  plot(RDAsubstrate, scaling = scl, xlab = "RDA axis 1 (2.66% of variation explained)",
    ylab = ("RDA axis 2 = 0.91% of variation explained "))
  text(RDAsubstrate, display = "species", cex = 1, scaling = scl, col = 1)
  summary(RDAsubstrate, display = NULL)
  RsquareAdj(RDAsubstrate)

  # Running ANOVA on data
  anova.cca(RDAsubstrate, step = 10000)

}
