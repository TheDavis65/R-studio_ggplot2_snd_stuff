############## Workflow Basics ##################

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes,
               ggvis,httr, lubridate, plotly, rio, rmarkdown, shiny,
               stringr, tidyr, caret, lars, tidyverse, psych, dygraphs, vioplot)







library(tidyverse)


1 / 200 * 30
(59 + 73 +2) / 3
sin(pi / 2)


x <- 3 * 4
x


seq(1, 10)

x <- "hello world"
x

y <- seq(1, 10, length.out = 5)
y

(y <- seq(1, 10, length.out = 5))




# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
detach("package:datasets", unload = TRUE)  # For base

# Clear plots
dev.off()  # But only if there IS a plot

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)
