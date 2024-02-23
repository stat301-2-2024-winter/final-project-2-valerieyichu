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
load(here("results/avocado_recipe_param.rda"))

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()


## Ordinary Linear Regression Model ----

# 1. A linear regression (`linear_reg()`) with the `"lm"` engine

# load training data
load(here("results/avocado_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

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




# 2. A ridge regression (`linear_reg(penalty = 0.01, mixture = 0)`), with the `"glmnet"` engine,

set.seed(301)
# model specifications ----
ridge_spec <- 
  linear_reg(penalty = 0.01, mixture = 0) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
ridge_wflow <- 
  workflow() |> 
  add_model(ridge_spec) |> 
  add_recipe(avocado_recipe_param)

# fit workflows/models ----
fit_ridge <- fit_resamples(
  ridge_wflow,
  resamples = avocado_folds,
  control = control_resamples(
    save_workflow = TRUE,
    parallel_over = "everything"
  )
)

# write out results (fitted/trained workflows) ----
save(fit_ridge, file = here("results/fit_ridge.rda"))

# inspecting model fit
# fit_ridge |> tidy()




# 3. A lasso regression (`linear_reg(penalty = 0.01, mixture = 1)`), with the `"glmnet"` engine


set.seed(301)
# model specifications ----
lasso_spec <- 
  linear_reg(penalty = 0.01, mixture = 1) %>% 
  set_engine("glmnet") %>% 
  set_mode("regression")

# define workflows ----
lasso_wflow <- 
  workflow() |> 
  add_model(lasso_spec) |> 
  add_recipe(avocado_recipe_param)

# fit workflows/models ----
fit_lasso <- fit_resamples(
  lasso_wflow,
  resamples = avocado_folds,
  control = control_resamples(
    save_workflow = TRUE,
    parallel_over = "everything"
  )
)

# write out results (fitted/trained workflows) ----
save(fit_lasso, file = here("results/fit_lasso.rda"))

# inspecting model fit
# fit_lasso |> tidy()



