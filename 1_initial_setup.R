# Valerie Chu's STAT 301-2 Final Project 
# Initial Setup

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


# Load Dataset
avocado <- read_csv(here("data/avocado.csv")) |> 
  janitor::clean_names()

# split the data
# set seed for random split
set.seed(301)
avocado_split <- avocado |> 
  initial_split(prop = 0.70, strata = average_price)
avocado_train <- training(avocado_split)
avocado_test <- testing(avocado_split)


# fold the data
avocado_folds <- vfold_cv(avocado_train, v = 10, repeats = 5,
                           strata = average_price)


# save to results
save(avocado_split, avocado_test, avocado_train, file = "results/avocado_split.rda")
save(avocado_folds, file = "results/avocado_folds.rda")



