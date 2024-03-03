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
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## Ordinary Linear Regression Model ----

## 1. A linear regression (`linear_reg()`) with the `"lm"` engine ----

set.seed(301)
# model specifications ----
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <- 
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(avocado_recipe_param)

# fit workflows/models ----
fit_lm <- fit_resamples(
  lm_wflow,
  resamples = avocado_folds,
  control = control_resamples(
    save_workflow = TRUE,
    parallel_over = "everything"
  )
)

# write out results (fitted/trained workflows) ----
save(fit_lm,file = here("results/fit_lm.rda"))

# inspecting model fit
# fit_lm |> tidy()




## 2. A ridge regression ---- 

set.seed(301)
# model specifications ----
ridge_spec <- 
  linear_reg(penalty = tune(), mixture = 0) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
ridge_wflow <- 
  workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(avocado_recipe_param)

# fit workflows/models ----
ridge_params <- extract_parameter_set_dials(ridge_spec)

ridge_grid <- grid_regular(ridge_params, levels = 5)

tuned_ridge <- tune_grid(ridge_wflow,
                         avocado_folds,
                         grid = ridge_grid,
                         control = control_grid(save_workflow = TRUE))

save(tuned_ridge, file = here("results/tuned_ridge.rda"))




## 3. A lasso regression ----


set.seed(301)
# model specifications ----
lasso_spec <- 
  linear_reg(penalty = tune(), mixture = 1) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
lasso_wflow <- 
  workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(avocado_recipe_param)

# fit workflows/models ----
lasso_params <- extract_parameter_set_dials(lasso_spec)

lasso_grid <- grid_regular(lasso_params, levels = 5)

tuned_lasso <- tune_grid(lasso_wflow,
                      avocado_folds,
                      grid = lasso_grid,
                      control = control_grid(save_workflow = TRUE))

save(tuned_lasso, file = here("results/tuned_lasso.rda"))



