%% This code is used to train different models and compare performance
clear
close
clc

% ##############################################################################################
% The data needs to be split into train and test. Different models are trained on the train data
% and tested on the test data for performance comparison.
% ##############################################################################################

%% NOTE

%% Load data and extract columns
rc_building_data = load_data_from_csv('rc_building_data.mat', 'Foglio1');
masonry_building_data = load_data_from_csv('masonry_building_data.mat', 'Foglio1');

%% Split train vs test dataset
random_state = 1
train_fraction = 0.9
[X_train_rc, Y_train_rc, X_test_rc, Y_test_rc] = split_train_test(rc_building_data(:,1:6), rc_building_data(:,7), train_fraction, random_state);
[X_train_masonry, Y_train_masonry, X_test_masonry, Y_test_masonry] = split_train_test(masonry_building_data(:,1:6), masonry_building_data(:,7), train_fraction, random_state);

%% Adjust response variable based on what the model is predicting
Y_train_rc(Y_train_rc~=3) = 0;
Y_train_rc(Y_train_rc==3) = 1;

Y_train_masonry(Y_train_masonry~=3) = 0;
Y_train_masonry(Y_train_masonry==3) = 1;

Y_test_rc(Y_test_rc~=3) = 0;
Y_test_rc(Y_test_rc==3) = 1;

Y_test_masonry(Y_test_masonry~=3) = 0;
Y_test_masonry(Y_test_masonry==3) = 1;


%% Train models
predvars = {'Damage to Vertical Structures', 'Damage to Floors', 'Damage to stairs', 'Damage to roof', 'Damge to infills/partitions', 'Damage to NSE'}

% Decision Tree
mdl_tree_rc = fitctree(X_train_rc, Y_train_rc, 'PredictorNames', predvars);
mdl_tree_masonry = fitctree(X_train_masonry, Y_train_masonry, 'PredictorNames', predvars);

% Logistic Regression
mdl_lr_rc = fitglm(X_train_rc, Y_train_rc);
mdl_lr_masonry = fitglm(X_train_masonry, Y_train_masonry);

% Naive Bayes
mdl_nb_rc = fitcnb(X_train_rc, Y_train_rc);
mdl_nb_masonry = fitcnb(X_train_masonry, Y_train_masonry);

% Random Forests
NumTrees = 100 % Try other numbers for this variable
mdl_rf_rc = TreeBagger(NumTrees, X_train_rc, Y_train_rc, 'Method','classification');
mdl_rf_masonry = TreeBagger(NumTrees, X_train_masonry, Y_train_masonry, 'Method','classification');


%% Generate predictions
% Decision Tree
Y_test_pred_tree_rc = predict(mdl_tree_rc, X_test_rc);
Y_test_pred_tree_masonry = predict(mdl_tree_masonry, X_test_masonry);

% Logistic Regression
Y_test_pred_lr_rc = predict(mdl_lr_rc, X_test_rc);
Y_test_pred_lr_masonry = predict(mdl_lr_masonry, X_test_masonry);

% Naive Bayes
Y_test_pred_nb_rc = predict(mdl_nb_rc, X_test_rc);
Y_test_pred_nb_masonry = predict(mdl_nb_masonry, X_test_masonry);

% Random Forests
Y_test_pred_rf_rc = predict(mdl_rf_rc, X_test_rc);
Y_test_pred_rf_masonry = predict(mdl_rf_masonry, X_test_masonry);


%% Model performance
% Accuracy
accuracy_tree_rc = length(find(Y_test_rc==Y_test_pred_tree_rc))/length(Y_test_pred_tree_rc);
accuracy_tree_masonry = length(find(Y_test_masonry==Y_test_pred_tree_masonry))/length(Y_test_pred_tree_masonry);

accuracy_lr_rc = length(find(Y_test_rc==Y_test_pred_lr_rc))/length(Y_test_pred_tree_rc);
accuracy_lr_masonry = length(find(Y_test_masonry==Y_test_pred_lr_masonry))/length(Y_test_pred_lr_masonry);

accuracy_nb_rc = length(find(Y_test_rc==Y_test_pred_nb_rc))/length(Y_test_pred_nb_rc);
accuracy_nb_masonry = length(find(Y_test_masonry==Y_test_pred_nb_masonry))/length(Y_test_pred_nb_masonry);

accuracy_rf_rc = length(find(Y_test_rc==Y_test_pred_rf_rc))/length(Y_test_pred_rf_rc);
accuracy_rf_masonry = length(find(Y_test_masonry==Y_test_pred_rf_masonry))/length(Y_test_pred_rf_masonry);

% AUC
[~,~,~,AUC_tree_rc] = perfcurve(Y_test_rc, Y_test_pred_tree_rc, '1');
[~,~,~,AUC_tree_masonry] = perfcurve(Y_test_masonry, Y_test_pred_tree_masonry, '1');

[~,~,~,AUC_lr_rc] = perfcurve(Y_test_rc, Y_test_pred_lr_rc, '1');
[~,~,~,AUC_lr_masonry] = perfcurve(Y_test_masonry, Y_test_pred_lr_masonry, '1');

[~,~,~,AUC_nb_rc] = perfcurve(Y_test_rc, Y_test_pred_nb_rc, '1');
[~,~,~,AUC_nb_masonry] = perfcurve(Y_test_masonry, Y_test_pred_nb_masonry, '1');

[~,~,~,AUC_rf_rc] = perfcurve(Y_test_rc, Y_test_pred_rf_rc, '1');
[~,~,~,AUC_rf_masonry] = perfcurve(Y_test_masonry, Y_test_pred_rf_masonry, '1');


