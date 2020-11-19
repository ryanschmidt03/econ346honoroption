#Always start with a statement about the intent of the script

#load packages - though you may want to do this in a single script for the whole project
library(pacman)
p_load(tidyverse)

#You shouldn't need to set a working directory when you open the project
#setwd("~/Desktop/College/Honr346/econ346honoroption")

##############################################
#Note that I have moved dataset building to another script
# visitation <- read_csv(file = "data/visitation_with_policy_day_and_month_dummies.csv")  #jude switched this to read_csv which is a better version of read.csv
#head(visitation)


#Ryan's model with explicit dummies (written in a lazy way)
model_formula <- as.formula(str_c("visits ~ policy +",
                                  str_c(names(visitation %>% select(monday:september)),collapse = " + ")))
m1 <- lm(model_formula,data = visitation)

summary(m1)


#Using factor variables to auto generate dummies
visit_factor <- visitation %>%
  select(date:month) %>%
  mutate(day=factor(day),
         day=relevel(day,ref = "Sunday"),
         month=factor(month),
         month=relevel(month,ref = "June"))

m2 <- lm(visits ~ policy + day + month, data = visit_factor)

summary(m2)

#Interact policy with month
m2_interact <- lm(visits ~ policy*month + day, data = visit_factor)

summary(m2_interact)



###################################
# Creating those dummies is a way of doing
#what is called fixed effects regression.  Here is how you would implement your
#regression with a packaged specially designed for these types of problems.  
#I only do this for your reference.  As we discussed, I think it is useful for you
#to do this the way you understand first and then move on once you are comfortable.

library(fixest)

m3 <- feols(visits ~ policy | day + month,data = visit_factor)

summary(m3)

#look at the fixed effects (dummies for day and month)
fixef(m3) %>%
  plot()
