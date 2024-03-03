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
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))
load(here("results/fit_null.rda"))
load(here("results/fit_lm.rda"))
load(here("results/fit_lasso.rda"))
load(here("results/fit_ridge.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_rf.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()

# More complicated table; display RMSE, RSQ
fit_null |> collect_metrics(metric = "rmse")
null_results <- collect_metrics(fit_null) |> 
  mutate(model = "null")

lm_results <- collect_metrics(fit_lm) |> 
  mutate(model = "lm")

lm_results <- collect_metrics(fit_lm) |> 
  mutate(model = "lm")

lasso_results <- collect_metrics(fit_lasso) |> 
  mutate(model = "lasso")

ridge_results <- collect_metrics(fit_ridge) |> 
  mutate(model = "ridge")

rf_results <- collect_metrics(tuned_rf) |> 
  mutate(model = "rf")

bt_results <- collect_metrics(tuned_bt) |> 
  mutate(model = "bt")

knn_results <- collect_metrics(tuned_knn) |> 
  mutate(model = "knn") 

simple_tbl_result <- null_results |> 
  bind_rows(lm_results) |> 
  bind_rows(lasso_results) |> 
  bind_rows(ridge_results) |> 
  bind_rows(rf_results) |> 
  bind_rows(bt_results) |> 
  bind_rows(knn_results) |> 
  select(-.config, -.estimator) |> 
  knitr::kable()

save(simple_tbl_result, file = "results/simple_tbl_result.rda")


# model results
model_results <- as_workflow_set(
  null = fit_null,
  lm = fit_lm,
  lasso = fit_lasso,
  ridge = fit_ridge,
  bt = tuned_bt,
  rf = tuned_rf,
  knn = tuned_knn
)

# show the rmse and standard error for the model with the lowest rmse for each model type
tbl_result <- model_results |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id,
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Computations` = n) 

save(tbl_result, file = "results/tbl_result.rda")

