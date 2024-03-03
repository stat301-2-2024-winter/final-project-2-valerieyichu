# Valerie Chu's STAT 301-2 Final Project 
# Define and fit boosted tree model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

## Recipes ----
load(here("results/avocado_split.rda"))
load(here("results/avocado_folds.rda"))
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## Boosted Tree Model ----

set.seed(301)
# model specifications ----

# boosted tree
bt_spec <- boost_tree(mode = "regression", 
                       min_n = tune(),
                       mtry = tune(), 
                       learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflows ----
bt_workflow <- workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(avocado_recipe_tree)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec) |> 
  update(mtry = mtry(range = c(1, 9))) |> 
  update(min_n = min_n(range = c(1, 9))) |> 
  update(learn_rate = learn_rate(range = c(-5, -0.2)))

bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
tuned_bt <- tune_grid(bt_workflow,
                      avocado_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt, file = here("results/tuned_bt.rda"))

# # autoplot
# autoplot(tuned_bt, metric = "rmse") +
#   labs(title = "Boosted Tree")
# 
# 
# tuned_bt |> select_best(metric = "rmse")
# 
# tbl_bt <- tuned_bt |> 
#   show_best("rmse") |> 
#   slice_min(mean) |> 
#   select(mean, n, std_err) |> 
#   mutate(model = "Boosted Tree")

# WHEN YOU TUNE AGAIN: 
autoplot(tuned_bt)
# when learn rate increases, rmse decreases -> so take the lowest learn rate. And remember that it's exponential. 
# and then mtry and min_n don't seem to affect rmse too much so probably don't need to tune them

