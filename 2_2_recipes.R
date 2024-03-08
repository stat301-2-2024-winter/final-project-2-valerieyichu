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
  step_dummy(type, region) |> 
  step_interact(~ total_volume:starts_with("type_")) |> 
  step_interact(~ x4770:x_large_bags) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_param_2) |> 
  bake(new_data = NULL)

save(avocado_recipe_param_2, file = "results/avocado_recipe_param_2.rda")


# Feature Engineered Tree-Based Recipe
load(here("results/avocado_split.rda"))

avocado_recipe_tree_2 <- recipe(average_price ~ ., data = avocado_train) |> 
  step_rm(x1, date, year) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_interact(~ total_volume:starts_with("type_")) |> 
  step_interact(~ x4770:x_large_bags) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_tree_2) |> 
  bake(new_data = NULL)

save(avocado_recipe_tree_2, file = "results/avocado_recipe_tree_2.rda")



