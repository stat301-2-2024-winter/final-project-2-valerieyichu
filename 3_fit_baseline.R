# Valerie Chu's STAT 301-2 Final Project 
# Define and fit null model

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

library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

# Null Model
null_spec <- null_model() %>% 
set_engine("parsnip") %>% 
  set_mode("regression") 

null_workflow <- workflow() %>% 
  add_model(null_spec) %>% 
  add_recipe(avocado_recipe_param)

fit_null <- null_workflow |> 
  fit_resamples(
    resamples = avocado_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

save(fit_null,file = here("results/fit_null.rda"))




