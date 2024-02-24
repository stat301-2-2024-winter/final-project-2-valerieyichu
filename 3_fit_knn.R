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
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## KNN Model ----

set.seed(301)
# model specifications ----
knn_spec <- nearest_neighbor(mode = "regression",
                              neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_workflow <- workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(avocado_recipe)

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_spec)

knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
tuned_knn <- tune_grid(knn_workflow,
                       avocado_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))


# write out results (fitted/trained workflows) ----
save(tuned_knn, file = here("results/tuned_knn.rda"))

# autoplot
autoplot(tuned_knn, metric = "rmse") +
  labs(title = "K Nearest Neighbors")


tuned_knn |> select_best(metric = "rmse")

tbl_knn <- tuned_knn |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "K Nearest Neighbors")

