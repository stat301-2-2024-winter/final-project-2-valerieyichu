# Valerie Chu's STAT 301-2 Final Project 
# Model Analysis

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(yardstick)
library(doMC)


# handle common conflicts
tidymodels_prefer()

## Recipes ----
load(here("results/avocado_split.rda"))
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

# Find our best model
lm_results <- collect_metrics(fit_lm) |> 
  mutate(model = "lm")

lasso_results <- collect_metrics(fit_lasso) |> 
  mutate(model = "lasso")

ridge_results <- collect_metrics(fit_ridge) |> 
  mutate(model = "ridge")

rf_results <- collect_metrics(fit_rf) |> 
  mutate(model = "rf")

lm_results |> 
  bind_rows(lasso_results) |> 
  bind_rows(ridge_results) |> 
  bind_rows(rf_results) |> 
  select(-.config, -.estimator) |> 
  knitr::kable()



