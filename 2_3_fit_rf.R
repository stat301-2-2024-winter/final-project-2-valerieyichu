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
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## Random Forest Model ----

set.seed(301)
# model specifications ----
rf_spec <- 
  rand_forest(min_n = tune(), 
              mtry = tune(),
              trees = 1000) %>%
  set_engine("ranger") %>% 
  set_mode("regression")

# define workflows ----
rf_wflow <- 
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(avocado_recipe_tree)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(range = c(1, 9)))

rf_grid <- grid_regular(rf_params, levels = 5)

# fit workflows/models ----
tuned_rf <- tune_grid(rf_wflow,
                      avocado_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))



# write out results (fitted/trained workflows) ----
save(tuned_rf, file = here("results/tuned_rf.rda"))

# autoplot
autoplot(tuned_rf, metric = "rmse") +
  labs(title = "Random Forest")


tuned_rf |> select_best(metric = "rmse")

tbl_rf <- tuned_rf |> 
  show_best("rmse") |> 
  slice_min(mean) |> 
  select(mean, n, std_err) |> 
  mutate(model = "Random Forest")

