% this loads our data
[X,y] = load_data_ex1();

% now we want to normalise our data
[X,mean,std] = normalise_features(X);

% after normalising we add the bias
X=[ones(size(X,1),1),X];

% initialise theta
theta=[1.0,1.0,1.0];
alpha = 0.1;
iterations = 100;

% run gradient descent
[t,cost_array]=gradient_descent(X,y,theta,alpha,iterations);

display(['Final error:',num2str(cost_array(end))]);
% plot our data and decision boundary
plot_data_function(X,y)
plot_boundary(X,t)

