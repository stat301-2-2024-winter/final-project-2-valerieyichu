# Valerie Chu's STAT 301-2 Final Project 
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

## Recipes ----
load(here("results/avocado_split.rda"))

# Feature Engineered Parametric Recipe
# Recipe for ordinary linear regression, lasso, ridge
avocado_recipe_param_2 <- recipe(average_price ~ ., data = avocado_train) |> 
  step_rm(x1, date, year) |> 
  step_log(all_predictors()) |> 
  step_dummy(type, region) |> 
  step_interact(~ total_volume:starts_with("type_")) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_param_2) |> 
  bake(new_data = NULL)

save(avocado_recipe_param, file = "results/avocado_recipe_param.rda")


# Feature Engineered Tree-Based Recipe
load(here("results/avocado_split.rda"))

avocado_recipe_tree <- recipe(average_price ~ ., 
                          data = avocado_train) |> 
  step_rm(x1, date, type, year, region) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_tree) |> 
  bake(new_data = NULL)

save(avocado_recipe_tree, file = "results/avocado_recipe_tree.rda")



