## Overview

This is a project about avocados. More specifically, my goal is to determine the combination of variables that contribute to the lowest average price of an avocado. Eventually, I hope to move to a city with the cheapest avocados.

This Avocado Prices dataset is from Kaggle:
**[https://www.kaggle.com/datasets/neuromusic/avocado-prices](https://www.kaggle.com/datasets/neuromusic/avocado-prices)**

Justin Kiggins, the owner of the dataset, writes that this data was downloaded from the Hass Avocado Board website in May of 2018 & compiled into a single CSV. There are 18,249 observations in this dataset and 14 variables. 

`average_price` is the variable I want to predict, so this is a regression problem. Using this dataset, I want to create OLS, lasso, ridge, random forest, boosted tree, and k nearest neighbors models, then assess how good they were at predicting the average prices of avocados through primarily rmse, but also rsq and mae. 

## Organization

In `1_initial_setup.R`, I split the avocado data into training and testing data using a used a 70-30 split. I also used folded the data using 10 folds and 5 repeats. 

In `2_recipes.R`, I created a kitchen sink parametric recipe and a kitchen sink tree recipe. 

In `3_fit_baseline.R`, I fitted a null model as the baseline model. 

In `3_fit_bt.R`, I tuned and fitted a boosted tree model. 

In `3_fit_knn.R`, I tuned and fitted a k nearest neighbors tree model. 

In `3_fit_parametric.R`, I fitted an ordinary linear regression model, a lasso model, and a ridge model. 

In `3_fit_rf.R`, I tuned and fitted a random forest model. 

In `4_model_analysis.R`, I made a table that shows the RMSE and standard error for the model with the lowest RMSE for each model type. 
