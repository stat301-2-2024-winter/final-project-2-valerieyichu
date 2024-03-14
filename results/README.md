## Results

This is the results folder. It contains the data for the models and recipes.



## The Organization of the Results Folder

- `avocado_folds.rda` - folded data

- `avocado_recipe_param.rda` - kitchen sink parametric recipe

- `avocado_recipe_tree.rda` - kitchen sink tree recipe

- `avocado_split.rda` - split, testing, training data

- `fit_lasso.rda` - fitted lasso model

- `fit_lm.rda` - fitted ols model

- `fit_null.rda` - fitted null model

- `fit_ridge.rda` - fitted ridge model

- `simple_tbl_result.rda` - table to display *all* models, their RMSE, and their RSQ

- `tbl_result.rda` - table to display the RMSE and standard error for the model with the lowest RMSE for each model type.

- `tuned_bt.rda` - tuned boosted tree model

- `tuned_knn.rda` - tuned k nearest neighbors model

- `tuned_rf.rda` - tuned random forest model

Files that end with "_2" are the equivalents of the rest of their file names, but they were created using the feature engineered recipe instead of the kitchen sink recipe. 

