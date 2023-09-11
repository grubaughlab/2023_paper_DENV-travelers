
if (!require("pacman")) install.packages("pacman")
pacman::p_unload()

#packages used in the analysis
pacman::p_load("e1071", "broom.mixed",
               "Rcpp", "MASS", "ciTools", "modelr", "performance", "broom",
               "rcartocolor", "lubridate", "timechange", "forcats", "stringr",
               "dplyr", "purrr", "readr", "tidyr", "tibble", "ggplot2",
               "tidyverse", "patchwork")



## close windows, clear variables
graphics.off()
options(scipen = 10)
rm(list=ls(all=TRUE))

countries = c("Puerto Rico", "Dominican Republic", "Jamaica", "Cuba", "Haiti") 

## SET COLOR SCHEMES  ###
country_colors <- c(`Cuba (travel)` = "#CD4D5D", `Cuba (local)` = "#949494", 
                    `Dominican Republic (travel)` = "#FFBB84", `Dominican Republic (local)` = "#949494",
                    `Haiti (travel)` = "#F9E06A", `Haiti (local)` = "#949494",
                    `Jamaica (travel)` = "#93C58A", `Jamaica (local)` = "#949494",
                    `Puerto Rico (travel)` = "#58C7F1", `Puerto Rico (local)` = "#949494")

#SET COUNTRY COLORS
country_colors2 <- c(Cuba = "#CF4555",  
                     `Dominican Republic` = "#FEB27E", 
                     Haiti = "#FCDB68", 
                     Jamaica = "#83BD83",
                     `Puerto Rico` = "#4FC1E9", 
                     Other = "#C1BFA5",
                     pred_inc = "darkred")

local_colors <- c(`Local cases` = "#C1BFA5")

country_colors3 <- c(`Cuba (Observed)` = "#CF4555",  
                     `Dominican Republic (Observed)` = "#FEB27E", 
                     `Haiti (Observed)` = "#FCDB68", 
                     `Jamaica (Observed)` = "#83BD83",
                     `Puerto Rico (Observed)` = "#4FC1E9", 
                     `Predicted` = "darkred")

local_colors <- c(`Local cases` = "#C1BFA5")

fig_colors = c("Observed" = "grey40",
               "Predicted" = "darkred")

#OBSERVED AND PREDICTED COLOR SCHEMES
fig_color = "grey30"
obs_color = "grey40"
pred_color = "darkred"



#TEXT SIZE COLOR SCHEMES
title = 14
axis_title = 10
axis_text = 8
label_text = 3
face = "bold"
