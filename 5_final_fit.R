# Valerie Chu's STAT 301-2 Final Project 
# Final Fit - The Winning Model was Random Forest

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
load(here("results/tuned_rf.rda"))


library(doMC)
registerDoMC(cores = parallel::detectCores(logical = TRUE))

# handle common conflicts
tidymodels_prefer()



## Training RF ----

# train the winning/best model identified in the last task on the entire training data set
# finalize workflow ----
final_wflow <- tuned_rf |> 
  extract_workflow(tuned_rf) |>  
  finalize_workflow(select_best(tuned_rf, metric = "rmse"))

# train final model ----
# set seed
set.seed(301)
final_fit <- fit(final_wflow, avocado_train)




## Final Fit ----
pred_final_fit <- 
  avocado_test |> 
  select(average_price) |> 
  bind_cols(predict(final_fit, avocado_test))

metricset <- metric_set (rmse, rsq, mae)

metrics_final_fit <- 
  pred_final_fit |> 
  metricset(truth = average_price, estimate = .pred)

save(pred_final_fit, file = here("results/pred_final_fit.rda"))
save(metrics_final_fit, file = here("results/metrics_final_fit.rda"))

metrics_final_fit |> 
  knitr::kable(digits = c(NA, NA, 4))


## Final Fit Plot ----
final_pred_plot <- pred_final_fit |> 
  ggplot(aes(x = average_price, y = .pred)) +
  geom_point(alpha = 0.5) +
  geom_abline(lty = 2) +
  labs(title = "Predicted Average Price of a Single Avocado \n vs. True Average Price of a Single Avocado",
       x = "Average Price of a Single Avocado",
       y = "Predicted Average Price of a Single Avocado") +
  theme_minimal() +
  coord_obs_pred()

save(final_pred_plot, file = here("results/final_pred_plot.rda"))


