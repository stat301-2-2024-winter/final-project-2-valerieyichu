# Valerie Chu's STAT 301-2 Final Project 
# Initial data checks

# load packages
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


# Load Dataset
avocado <- read_csv(here("data/avocado.csv")) |> 
  janitor::clean_names()


# Checking Data Complexity
naniar::gg_miss_var(avocado)

skimr::skim(avocado)


# Exploring `average_price`
avocado |> 
  ggplot(aes(x = average_price)) +
  geom_boxplot() +
  scale_x_continuous(breaks = seq(0, 4, 0.5)) +
  theme_minimal()

avocado |> 
  select(average_price) |> 
  summary(mean = mean(average_price, na.rm = TRUE),
          median = median(average_price, na.rm = TRUE)) |> 
  knitr::kable()


# Making a correlation plot
cor <- avocado |> 
  select(average_price, total_volume, x4046, x4225, x4770, total_bags, small_bags, large_bags, x_large_bags) |> 
  cor() |> 
  knitr::kable()

# Exploring whether `type` and `region` should be dummied

avocado |> select(type) |> distinct()
# There are only 2 types of avocados - organic, and conventional. 
# So in my feature engineered recipes, `type` will be dummied

avocado |> select(region) |> distinct()
# There are 54 regions these avocados are grown in. 
# So in my feature engineered recipes, I will remove `region` instead of dummying it. 

