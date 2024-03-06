# Valerie Chu's STAT 301-2 Final Project 
# Exploration for Feature Engineering

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# Load Data
load(here("results/avocado_split.rda"))
load(here("results/avocado_folds.rda"))
load(here("results/avocado_recipe_param.rda"))
load(here("results/avocado_recipe_tree.rda"))

## Density Plots to Determine if I should log transform

avocado_train |> 
  ggplot(aes(x = average_price)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(average_price))) +
  geom_density()

# average_price doesn't need log transform



avocado_train |> 
  ggplot(aes(x = total_volume)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(total_volume))) +
  geom_density()

# total_volume needs log transform



avocado_train |> 
  ggplot(aes(x = x4046)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4046))) +
  geom_density()

# x4046 needs log transform



avocado_train |> 
  ggplot(aes(x = x4225)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4225))) +
  geom_density()

# x4225 needs log transform



avocado_train |> 
  ggplot(aes(x = x4770)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4770))) +
  geom_density()

# x4770 needs log transform



avocado_train |> 
  ggplot(aes(x = total_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(total_bags))) +
  geom_density()

# total_bags needs log transform



avocado_train |> 
  ggplot(aes(x = small_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(small_bags))) +
  geom_density()

# small_bags needs log transform



avocado_train |> 
  ggplot(aes(x = large_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(large_bags))) +
  geom_density()

# large_bags needs log transform



avocado_train |> 
  ggplot(aes(x = x_large_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x_large_bags))) +
  geom_density()

# x_large_bags needs log transform



avocado_train |> 
  ggplot(aes(x = type)) +
  geom_density()

# type doesn't need log transform



avocado_train |> 
  ggplot(aes(x = year)) +
  geom_density()

# year doesn't need log transform

# region doesn't need log transform




