# Valerie Chu's STAT 301-2 Final Project 
# Define and fit random forest model

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


## Random Forest Model ----

set.seed(301)
# model specifications ----
rf_spec_2 <- 
  rand_forest(min_n = tune(), 
              mtry = tune(),
              trees = 1000) %>%
  set_engine("ranger") %>% 
  set_mode("regression")

# define workflows ----
rf_wflow_2 <- 
  workflow() |> 
  add_model(rf_spec_2) |> 
  add_recipe(avocado_recipe_tree_2)

# hyperparameter tuning values ----
rf_params_2 <- extract_parameter_set_dials(rf_spec_2) |> 
  update(mtry = mtry(range = c(1, 17)))

rf_grid_2 <- grid_regular(rf_params_2, levels = 5)

# fit workflows/models ----
tuned_rf_2 <- tune_grid(rf_wflow_2,
                      avocado_folds,
                      grid = rf_grid_2,
                      control = control_grid(save_workflow = TRUE))



# write out results (fitted/trained workflows) ----
save(tuned_rf_2, file = here("results/tuned_rf_2.rda"))

# autoplot
autoplot(tuned_rf_2, metric = "rmse") +
  labs(title = "Random Forest")


tuned_rf_2 |> select_best(metric = "rmse")

tbl_rf_2 <- tuned_rf_2 |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest")

