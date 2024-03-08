# Valerie Chu's STAT 301-2 Final Project 
# Model Analysis

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(yardstick)
library(doMC)


# handle common conflicts
tidymodels_prefer()

## Recipes ----
load(here("results/avocado_split.rda"))
load(here("results/avocado_recipe_param_2.rda"))
load(here("results/avocado_recipe_tree_2.rda"))
load(here("results/fit_null_2.rda"))
load(here("results/fit_lm_2.rda"))
load(here("results/tuned_lasso_2.rda"))
load(here("results/tuned_ridge_2.rda"))
load(here("results/tuned_bt_2.rda"))
load(here("results/tuned_knn_2.rda"))
load(here("results/tuned_rf_2.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

# More complicated table; display RMSE, RSQ

null_results_2 <- collect_metrics(fit_null_2) |> 
  mutate(model = "null")

lm_results_2 <- collect_metrics(fit_lm_2) |> 
  mutate(model = "lm")

lasso_results_2 <- collect_metrics(tuned_lasso_2) |> 
  mutate(model = "lasso")

ridge_results_2 <- collect_metrics(tuned_ridge_2) |> 
  mutate(model = "ridge")

rf_results_2 <- collect_metrics(tuned_rf_2) |> 
  mutate(model = "rf")

bt_results_2 <- collect_metrics(tuned_bt_2) |> 
  mutate(model = "bt")

knn_results_2 <- collect_metrics(tuned_knn_2) |> 
  mutate(model = "knn") 

simple_tbl_result_2 <- null_results_2 |> 
  bind_rows(lm_results_2) |> 
  bind_rows(lasso_results_2) |> 
  bind_rows(ridge_results_2) |> 
  bind_rows(rf_results_2) |> 
  bind_rows(bt_results_2) |> 
  bind_rows(knn_results_2) |> 
  select(-.config, -.estimator) |> 
  knitr::kable()

save(simple_tbl_result_2, file = "results/simple_tbl_result_2.rda")


# model results
model_results_2 <- as_workflow_set(
  null = fit_null_2,
  lm = fit_lm_2,
  lasso = tuned_lasso_2,
  ridge = tuned_ridge_2,
  bt = tuned_bt_2,
  rf = tuned_rf_2,
  knn = tuned_knn_2
)

# show the rmse and standard error for the model with the lowest rmse for each model type
tbl_result_2 <- model_results_2 |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id,
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Computations` = n) |> 
  distinct()

save(tbl_result_2, file = "results/tbl_result_2.rda")

