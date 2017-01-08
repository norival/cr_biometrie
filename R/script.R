# ------------------------------------------------------------------------------
# analyses and graphics for article comment
# ------------------------------------------------------------------------------

if(!interactive()) {
  setwd("R/")
}

# -- packages ------------------------------------------------------------------
library(ggplot2)
library(magrittr)
library(tikzDevice)

# -- new colors ----------------------------------------------------------------
bop <- rgb(184, 65, 31, max = 255)

# -- bibliometry analyses ------------------------------------------------------
# results for web of science query, using:
#   'TI=(bayes*) AND TS=(ecology OR biology)'

bib <- read.table("data/analyze.txt", header = TRUE, sep = "\t")
bib$year <-
  as.character(bib$year) %>%
  as.Date(., format = "%Y")

p <-
  bib[-nrow(bib), ] %>%
  ggplot(aes(x = year, y = records)) +
  geom_bar(stat = "identity", color = bop, fill = bop) +
  theme_bw() +
  xlab("Année") +
  ylab("Publications") +
  theme(panel.grid = element_blank(),
        axis.text.x = element_text(size = 9),
        axis.title = element_text(size = 10),
        panel.border = element_rect(colour = "black"))

tikz("../latex/img/dyn_bibliometry.tex", width = 3.3, height = 2.2)
p
dev.off()
