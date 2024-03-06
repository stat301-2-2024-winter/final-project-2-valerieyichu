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

# Kitchen Sink Parametric Recipe
# Recipe for ordinary linear regression, lasso, ridge
avocado_recipe_param <- recipe(average_price ~ ., data = avocado_train) |> 
  step_rm(x1, date, region) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_param) |> 
  bake(new_data = NULL)

save(avocado_recipe_param, file = "results/avocado_recipe_param.rda")


# Kitchen Sink Tree-Based Recipe
load(here("results/avocado_split.rda"))
load(here("results/avocado_folds.rda"))

avocado_recipe_tree <- recipe(average_price ~ ., 
                          data = avocado_train) |> 
  step_rm(x1, date, region) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |> 
  step_normalize(all_predictors())

prep(avocado_recipe_tree) |> 
  bake(new_data = NULL)

save(avocado_recipe_tree, file = "results/avocado_recipe_tree.rda")



