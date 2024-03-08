# Valerie Chu's STAT 301-2 Final Project 
# Define and fit tree models

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

## Recipes ----
load(here("results/avocado_split.rda"))
load(here("results/avocado_folds.rda"))
load(here("results/avocado_recipe_param_2.rda"))
load(here("results/avocado_recipe_tree_2.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## KNN Model ----

set.seed(301)
# model specifications ----
knn_spec_2 <- nearest_neighbor(mode = "regression",
                              neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_workflow_2 <- workflow() |> 
  add_model(knn_spec_2) |> 
  add_recipe(avocado_recipe_tree_2)

# hyperparameter tuning values ----
knn_params_2 <- extract_parameter_set_dials(knn_spec_2)

knn_grid_2 <- grid_regular(knn_params_2, levels = 5)

# fit workflows/models ----
tuned_knn_2 <- tune_grid(knn_workflow_2,
                       avocado_folds,
                       grid = knn_grid_2,
                       control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(tuned_knn_2, file = here("results/tuned_knn_2.rda"))

# autoplot
autoplot(tuned_knn_2, metric = "rmse") +
  labs(title = "K Nearest Neighbors")


tuned_knn_2 |> select_best(metric = "rmse")

tbl_knn_2 <- tuned_knn_2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbors")



