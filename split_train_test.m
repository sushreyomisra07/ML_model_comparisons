function [train_data_X, train_data_Y, test_data_X, test_data_Y] = split_train_test(X_data, Y_data, train_fraction, random_state)

rng(random_state);

shuffle = randperm(size(X_data,1));
X_data = X_data(shuffle,:);
Y_data = Y_data(shuffle,:);

boundary = round(train_fraction * size(X_data,1))

train_data_X = X_data(boundary + 1:end, :);
train_data_Y = Y_data(boundary + 1:end, :);

test_data_X = X_data(1:boundary, :);
test_data_Y = Y_data(1:boundary, :);