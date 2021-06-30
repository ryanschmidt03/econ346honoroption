library(pacman)
p_load(tidyverse,lubridate,conflicted)

scalefactordata <- read_csv(file = "data/scalefactordata.csv")

attach(scalefactordata)

scalefactor <- lm(rmnp_monthly_visits ~ safegraph_monthly_visits)

summary(scalefactor)


library(broom)
library(gtsummary)
scalefactor_table <- add_significance_stars(tbl_regression(scalefactor), thresholds = c(0.01, 0.05, 0.1))

