%% This loads our data
[X, y] = load_data_ex2();

%% Normalise and initialize.
[X, mean_vec, std_vec] = normalise_features(X);

%after normalising we add the bias
X = [ones(size(X, 1), 1), X];

%initialise theta
theta = [0.0, 0.0, 0.0];
alpha = 0.3;
iterations = 100;

%% 
t = gradient_descent(X, y, theta, alpha, iterations);

fprintf("Theta is: %s\n" , sprintf('%d ', t));
%%
%1650 sq. ft. and 3 bedrooms cost
house1_features = [1650, 3];
house2_features = [3000,4];

% we reuse the normalise features function

norm_features = normalise_features([house1_features;house2_features]);

features_w_bias = [ones(2,1),norm_features];

P=features_w_bias*t';
%t 3000 sq. ft. and 4 bedrooms


fprintf("House 1 costs: %1.2f\nHouse 2 costs: %1.2f\n",P(1),P(2));
disp 'Press enter to exit!';
pause;

