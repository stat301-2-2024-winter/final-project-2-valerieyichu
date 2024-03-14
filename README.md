## Overview

This is a project about avocados. More specifically, my goal is to predict the average price of a single avocado (`average_price`) so that I can pinpoint and eventually move to a city with the cheapest avocados...

This Avocado Prices dataset is from Kaggle:
**[https://www.kaggle.com/datasets/neuromusic/avocado-prices](https://www.kaggle.com/datasets/neuromusic/avocado-prices)**

Justin Kiggins, the owner of the dataset, writes that this data was downloaded from the Hass Avocado Board website in May of 2018 & compiled into a single CSV. There are 18,249 observations in this dataset and 14 variables. 

`average_price` is the variable I want to predict, so this is a regression problem. Using this dataset, I will create null, ordinary linear regression, lasso, ridge, random forest, boosted tree, and k nearest neighbors models, then assess how good they were at predicting the average prices of avocados through primarily rmse, but also rsq and mae. Each model type will use two recipes — one kitchen sink recipe and one feature engineered recipe. 

## Organization

In `0_initial_data_checks.R`, I did an initial data exploration. 

In `1_exploration_fe.R`, I did an in-depth exploration of the target variable, average price, and other variables in the dataset to inform my feature engineered recipe. 

In `1_initial_setup.R`, I split the avocado data into training and testing data using a used a 70-30 split. I also used folded the data using 10 folds and 5 repeats. 

In `2_recipes.R`, I created a kitchen sink parametric recipe and a kitchen sink tree recipe. 

In `3_fit_baseline.R`, I fitted a null model as the baseline model. 

In `3_fit_bt.R`, I tuned and fitted a boosted tree model. 

In `3_fit_knn.R`, I tuned and fitted a k nearest neighbors tree model. 

In `3_fit_parametric.R`, I fitted an ordinary linear regression model, a lasso model, and a ridge model. 

In `3_fit_rf.R`, I tuned and fitted a random forest model. 

In `4_model_analysis.R`, I made a table that shows the RMSE and standard error for the model with the lowest RMSE for each model type. 

In `5_final_fit.R`, I conducted my final model analysis, fitting the winning model to the testing dataset and creating a graph of predicted vs. true average prices.

R files that start with "2_" are the equivalents of the rest of their file names, but they were created using the feature engineered recipe instead of the kitchen sink recipe. 

