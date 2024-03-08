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

## Density Plots to Determine if I should log transform ----

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
# total_volume *could* use log transform



avocado_train |> 
  ggplot(aes(x = x4046)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4046))) +
  geom_density()
# x4046 could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = x4225)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4225))) +
  geom_density()
# x4225 could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = x4770)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x4770))) +
  geom_density()
# x4770 could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = total_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(total_bags))) +
  geom_density()
# total_bags could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = small_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(small_bags))) +
  geom_density()
# small_bags could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = large_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(large_bags))) +
  geom_density()
# large_bags could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = x_large_bags)) +
  geom_density()

avocado_train |> 
  ggplot(aes(x = log(x_large_bags))) +
  geom_density()
# x_large_bags could use log transform, but it has several values of 0, 
# so doing so will produce NaN and I don't want that.



avocado_train |> 
  ggplot(aes(x = type)) +
  geom_density()
# type doesn't need log transform



avocado_train |> 
  ggplot(aes(x = year)) +
  geom_density()
# year doesn't need log transform

# region doesn't need log transform


## Determining interaction terms ----

# Starting with a correlation plot
avocado |> 
  select(average_price, total_volume, x4046, x4225, x4770, total_bags, small_bags, large_bags, x_large_bags) |> 
  cor()

avocado_train |> 
  ggplot(aes(x = type, y = total_volume)) +
  geom_boxplot()
# It seems like type and total volume are good interaction terms because 
# there are more conventional than organic avocados being sold 
# and there is a relationship between these two variables. 

avocado_train |> 
  ggplot(aes(x = small_bags, y = total_bags)) +
  geom_point()
# Small bags and total bags have a high correlation but are super linear, 
# so creating an interaction term between them won't be super interesting.

avocado_train |> 
  ggplot(aes(x = x4046, y = total_volume)) +
  geom_point() +
  geom_smooth()
# x4046 and total volume have a high correlation but are quite linear, 
# so creating an interaction term between them won't be super interesting.

avocado_train |> 
  ggplot(aes(x = x4770, y = x_large_bags)) +
  geom_point() +
  geom_smooth()
# x4770 and x_large_bags are somewhat correlated and also non-linear, 
# so creating an interaction term with them might be interesting. 

avocado_train |> 
  ggplot(aes(x = x4225, y = x_large_bags)) +
  geom_point() +
  geom_smooth()
# x4225 and total volume have a decently high correlation but are quite linear, 
# so creating an interaction term between them won't be super interesting.

# And there aren't any other potential interactions that I think are interesting to explore. 
# The types of avocados (the variables that start with x). 




## A note ----
# I was going to consider a step_ns, but the relationships between the predictor 
# variables and average price seem to be pretty linear, 
# and I don't see the need for it unless I run the risk of overfitting. 

## Determining spline

avocado_train |>
  ggplot(aes(x = log(total_volume), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(x4046), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(x4225), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(x4770), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(total_bags), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(small_bags), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(large_bags), y = average_price)) +
  geom_point() +
  geom_smooth()

avocado_train |>
  ggplot(aes(x = log(x_large_bags), y = average_price)) +
  geom_point() +
  geom_smooth()
