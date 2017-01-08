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
bop     <- rgb(184, 65, 31, max = 255)
my_gray <- rgb(76, 76, 76, max = 255)

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


# ------------------------------------------------------------------------------
# uninformative versus informative priors
# example from garamszegi2009

pearson_ci <- function(r, n) {

  # convert r to z using fisher's z transformation
  z <- 0.5 * log((1 + r) / (1 - r))
  sd <- sqrt(1 / (n - 3))

  # z space lower and upper limits for 95% CI
  CI_z_inf <- z - z * 1.96
  CI_z_sup <- z + z * 1.96

  # convert back z space values to r
  CI_r_inf <- (exp(2 * CI_z_inf) - 1) / (exp(2 * CI_z_inf) + 1)
  CI_r_sup <- (exp(2 * CI_z_sup) - 1) / (exp(2 * CI_z_sup) + 1)

  # return the results
  return(c(CI_r_inf, CI_r_sup))
}

# meta analysis
r_met <- 0.463
r_met_inf <- 0.290
r_met_sup <- 0.608

# nht framwork
r_nht <- 0.266
n_nht <- 15
r_nht_inf <- pearson_ci(r_nht, n_nht)[1]
r_nht_sup <- pearson_ci(r_nht, n_nht)[2]

# bayesian with uninformative prior
r_bun <- 0.262
r_bun_inf <- -0.269
r_bun_sup <- 0.669

# bayesian with informative prior
r_bin <- 0.422
r_bin_inf <- 0.102
r_bin_sup <- 0.657

d <- data.frame(test  = c("META", "NHT", "BUN", "BIN"),
                r     = c(r_met, r_nht, r_bun, r_bin),
                inf   = c(r_met_inf, r_nht_inf, r_bun_inf, r_bin_inf),
                sup   = c(r_met_sup, r_nht_sup, r_bun_sup, r_bin_sup))
d$test <- factor(d$test,
                 levels = c("META", "NHT", "BUN", "BIN"))

p <-
  ggplot(d, aes(x = r, y = test, group = test)) +
  geom_errorbarh(aes(xmin = inf, xmax = sup, group = test),
                 height = 0.2, colour = my_gray) +
  geom_point(size = 4.5, colour = bop) +
  geom_vline(xintercept = 0, lty = "dotted") +
  xlab("\\textit{r} de Pearson") +
  ylab("") +
  theme_bw() +
  theme(panel.grid = element_blank(),
        axis.line.x = element_line(size = 0.5, colour = "black"),
        axis.text.x = element_text(size = 9),
        axis.ticks.y = element_blank(),
        axis.title = element_text(size = 10),
        panel.border = element_blank())

tikz("../latex/img/dyn_pearson.tex", width = 3.3, height = 1.6)
plot(p)
dev.off()


