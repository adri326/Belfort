rm(list=ls())

# Ici on définit l'espace de travail. MODIFIEZ-LE pour que cela corresponde
# à l'emplacement sur votre propre ordinateur
# setwd("~/Documents/Projets R/CaraNetwork")

# Ici on charge le package igraph qui sert à faire de l'analyse de réseaux
# Installation (si besoin) et chargement des packages requis
packages <- c("igraph", "RColorBrewer", "networkD3", "stringr", "ggraph", "ggplot2", "extrafont")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())), repos = "http://cran.us.r-project.org")
}

library(RColorBrewer)
library(networkD3)
library(extrafont)

source("src/create_graph.R")
source("src/shapes.R")
source("src/plotnework.R")

# Create the out/ directory if it isn't already there
if (!dir.exists(c("out"))[1]) {
  dir.create("out/")
}

#############################
### LA CREATION DU RESEAU ###
#############################

args <- commandArgs(trailingOnly = TRUE)

g <- create_graph(fichier = args[3],
  attr1 = if (length(args) < 4) {""} else {args[4]},
  attr2 = if (length(args) < 5) {""} else {args[5]},
  seuil = as.numeric(args[2])
)

# Alternate layout would be "stress"
plot <- ggraph::ggraph(g, layout = "fr") +
  ggraph::geom_edge_link(ggplot2::aes(width = weight))

if (length(args) == 4) {
  plot <- plot +
    ggraph::geom_node_point(ggplot2::aes(size = igraph::degree(g), color = id1)) +
    ggplot2::scale_colour_brewer(palette = "Set1", "Attribut 1")
} else if (length(args) > 4) {
  plot <- plot +
    ggraph::geom_node_point(ggplot2::aes(size = igraph::degree(g), fill = id1, shape = id2)) +
    ggplot2::scale_shape_manual(values = c(21, 22, 23, 24, 25, 8), "Attribut 2") +
    ggplot2::scale_fill_brewer(palette = "Set1", "Attribut 1") +
    ggplot2::guides(
      fill = ggplot2::guide_legend(order = 1, override.aes = list(shape = 21))
    )
} else {
  plot <- plot + ggraph::geom_node_point(ggplot2::aes(size = igraph::degree(g)))
}

plot <- plot +
  ggraph::scale_edge_width_continuous(range = c(.1, 2), "Poids") +
  ggraph::geom_node_label(
    ggplot2::aes(label = name),
    size = 2,
    repel = TRUE,
    family = "Helvetica",
  ) +
  ggplot2::scale_size_area(max_size = 5, "Degré") +
  ggplot2::ggtitle(args[1], subtitle = paste("Seuil:", args[2])) +
  ggplot2::theme(
    plot.background = ggplot2::element_rect(fill = "white"),
    plot.title = ggplot2::element_text(hjust = 0.5, size = 17),
    plot.subtitle = ggplot2::element_text(hjust = 0.5, face = "italic"),
    panel.background = ggplot2::element_rect(fill = "white"),
    legend.key = ggplot2::element_rect(fill = "white"),
  )

ggplot2::ggsave(paste("out/", trimws(args[1]), "-", args[2], ".pdf", sep = ""), plot, width = 10, height = 7)
ggplot2::ggsave(paste("out/", trimws(args[1]), "-", args[2], ".png", sep = ""), plot, width = 10, height = 7)
