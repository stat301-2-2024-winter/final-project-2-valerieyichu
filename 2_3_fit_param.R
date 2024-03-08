# Valerie Chu's STAT 301-2 Final Project 
# Define and fit parametric models

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


## Ordinary Linear Regression Model ----

## 1. A linear regression (`linear_reg()`) with the `"lm"` engine ----

set.seed(301)
# model specifications ----
lm_spec_2 <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_2 <- 
  workflow() |> 
  add_model(lm_spec_2) |> 
  add_recipe(avocado_recipe_param_2)

# fit workflows/models ----
fit_lm_2 <- fit_resamples(
  lm_wflow_2,
  resamples = avocado_folds,
  control = control_resamples(
    save_workflow = TRUE,
    parallel_over = "everything"
  )
)

lm_results_2 <- collect_metrics(fit_lm_2) |> 
  mutate(model = "lm")

# write out results (fitted/trained workflows) ----
save(fit_lm_2,file = here("results/fit_lm_2.rda"))

# inspecting model fit
# fit_lm |> tidy()




## 2. A ridge regression ---- 

set.seed(301)
# model specifications ----
ridge_spec_2 <- 
  linear_reg(penalty = tune(), mixture = 0) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
ridge_wflow_2 <- 
  workflow() |> 
  add_model(ridge_spec_2) |> 
  add_recipe(avocado_recipe_param_2)

# fit workflows/models ----
ridge_params_2 <- extract_parameter_set_dials(ridge_spec_2)

ridge_grid_2 <- grid_regular(ridge_params_2, levels = 5)

tuned_ridge_2 <- tune_grid(ridge_wflow_2,
                         avocado_folds,
                         grid = ridge_grid_2,
                         control = control_grid(save_workflow = TRUE))

ridge_results_2 <- collect_metrics(tuned_ridge_2) |> 
  mutate(model = "ridge")

save(tuned_ridge_2, file = here("results/tuned_ridge_2.rda"))




## 3. A lasso regression ----


set.seed(301)
# model specifications ----
lasso_spec_2 <- 
  linear_reg(penalty = tune(), mixture = 1) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
lasso_wflow_2 <- 
  workflow() |> 
  add_model(lasso_spec_2) |> 
  add_recipe(avocado_recipe_param_2)

# fit workflows/models ----
lasso_params_2 <- extract_parameter_set_dials(lasso_spec_2)

lasso_grid_2 <- grid_regular(lasso_params_2, levels = 5)

tuned_lasso_2 <- tune_grid(lasso_wflow_2,
                      avocado_folds,
                      grid = lasso_grid_2,
                      control = control_grid(save_workflow = TRUE))

lasso_results_2 <- collect_metrics(tuned_lasso_2) |> 
  mutate(model = "lasso")

save(tuned_lasso_2, file = here("results/tuned_lasso_2.rda"))



