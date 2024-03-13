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
load(here("results/tuned_lasso.rda"))
load(here("results/tuned_ridge.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_knn.rda"))
load(here("results/tuned_rf.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()




## Visualize Results ----

autoplot_lasso <- autoplot(tuned_lasso, metric = "rmse") +
  labs(title = "Lasso") +
  theme_minimal()
# A penalty of 1e^-07 leads to the lowest RMSE.  


autoplot_ridge <- autoplot(tuned_ridge, metric = "rmse") +
  labs(title = "Ridge") +
  theme_minimal()
# A penalty of 1e^-07 leads to the lowest RMSE. 


autoplot_bt <- autoplot(tuned_bt, metric = "rmse") +
  labs(title = "Boosted Tree") +
  theme_minimal()
# A learn rate of 0.630957 leads to the lowest RMSE. 
# A mtry ("# Randomly Selected Predictors") of 14 leads to the lowest RMSE. 
# A min_n ("Minimal Node Size") of 14 leads to the lowest RMSE. 


autoplot_knn <- autoplot(tuned_knn, metric = "rmse") +
  labs(title = "K Nearest Neighbors") +
  theme_minimal()
# A neighbors of 8 leads to the lowest RMSE. 


autoplot_rf <- autoplot(tuned_rf, metric = "rmse") +
  labs(title = "Random Forest") +
  theme_minimal()
# A mtry of 7 leads to the lowest RMSE. 
# A min_n of 2 leads to the lowest RMSE. 

save(autoplot_lasso, autoplot_ridge, autoplot_bt, autoplot_knn, autoplot_rf, file = "results/autoplots.rda")



## Select Best Hyperparameters ----
# best hyperparameters for each model type

tuned_lasso |> select_best(metric = "rmse")
# Best hyperparameter: Penalty = 0.0000000001

tuned_ridge |> select_best(metric = "rmse")
# Best hyperparameter: Penalty = 0.0000000001

tuned_bt |> select_best(metric = "rmse")
# Best hyperparameters: mtry = 14. min_n = 14. learn_rate = 0.631

tuned_knn |> select_best(metric = "rmse")
# Best hyperparameter: neighbors = 8

tuned_rf |> select_best(metric = "rmse")
# Best hyperparameter: mtry = 7. min_n = 2



## Table ----
null_results <- collect_metrics(fit_null) |> 
  mutate(model = "null")

lm_results <- collect_metrics(fit_lm) |> 
  mutate(model = "lm")

lasso_results <- collect_metrics(tuned_lasso) |> 
  mutate(model = "lasso")

ridge_results <- collect_metrics(tuned_ridge) |> 
  mutate(model = "ridge")

rf_results <- collect_metrics(tuned_rf) |> 
  mutate(model = "rf")

bt_results <- collect_metrics(tuned_bt) |> 
  mutate(model = "bt")

knn_results <- collect_metrics(tuned_knn) |> 
  mutate(model = "knn") 


# The simple table below shows all the rmses and rsqs for *every* model, so there are a lot of them.
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
  lasso = tuned_lasso,
  ridge = tuned_ridge,
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
         `Num Computations` = n) |> 
  distinct()

save(tbl_result, file = "results/tbl_result.rda")

