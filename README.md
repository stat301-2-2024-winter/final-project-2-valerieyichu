## Overview

This is a project about avocados. More specifically, my goal is to determine the combination of variables that contribute to the lowest average price of an avocado. Eventually, I hope to move to a city with the cheapest avocados.

This Avocado Prices dataset is from Kaggle:
**[https://www.kaggle.com/datasets/neuromusic/avocado-prices](https://www.kaggle.com/datasets/neuromusic/avocado-prices)**

Justin Kiggins, the owner of the dataset, writes that this data was downloaded from the Hass Avocado Board website in May of 2018 & compiled into a single CSV. There are 18,249 observations in this dataset and 14 variables. 

`average_price` is the variable I want to predict, so this is a regression problem. Using this dataset, I want to create OLS, lasso, ridge, and random forest models, then assess how good they were at predicting the average prices of avocados through rmse, rsq and mae. 
