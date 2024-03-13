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



## Visualize Results ----

autoplot_lasso_2 <- autoplot(tuned_lasso_2, metric = "rmse") +
  labs(title = "Lasso") +
  theme_minimal()
# A penalty of 1e^-08 leads to the lowest RMSE.  


autoplot_ridge_2 <- autoplot(tuned_ridge_2, metric = "rmse") +
  labs(title = "Ridge") +
  theme_minimal()
# A penalty of 1e^-08 leads to the lowest RMSE. 


autoplot_bt_2 <- autoplot(tuned_bt_2, metric = "rmse") +
  labs(title = "Boosted Tree") +
  theme_minimal()
# A learn rate of 0.630957 leads to the lowest RMSE. 
# A mtry ("# Randomly Selected Predictors") of 19 leads to the lowest RMSE. 
# A min_n ("Minimal Node Size") of 17 leads to the lowest RMSE. 


autoplot_knn_2 <- autoplot(tuned_knn_2, metric = "rmse") +
  labs(title = "K Nearest Neighbors") +
  theme_minimal()
# A neighbors of 15 leads to the lowest RMSE. 


autoplot_rf_2 <- autoplot(tuned_rf_2, metric = "rmse") +
  labs(title = "Random Forest") +
  theme_minimal()
# A mtry of 9 leads to the lowest RMSE. 
# A min_n of 2 leads to the lowest RMSE. 




## Select Best Hyperparameters ----
# best hyperparameters for each model type

tuned_lasso_2 |> select_best(metric = "rmse")
# Best hyperparameter: Penalty = 0.0000000001

tuned_ridge_2 |> select_best(metric = "rmse")
# Best hyperparameter: Penalty = 0.0000000001

tuned_bt_2 |> select_best(metric = "rmse")
# Best hyperparameters: mtry = 17. min_n = 9. learn_rate = 0.631

tuned_knn_2 |> select_best(metric = "rmse")
# Best hyperparameter: neighbors = 15

tuned_rf_2 |> select_best(metric = "rmse")
# Best hyperparameter: mtry = 9. min_n = 2



## Table ----

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

# The simple table below shows all the rmses and rsqs for *every* model, so there are a lot of them.
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
  null_2 = fit_null_2,
  lm_2 = fit_lm_2,
  lasso_2 = tuned_lasso_2,
  ridge_2 = tuned_ridge_2,
  bt_2 = tuned_bt_2,
  rf_2 = tuned_rf_2,
  knn_2 = tuned_knn_2
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

