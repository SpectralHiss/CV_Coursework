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

[training_input,training_output,test_input,test_output] = return_test_set(X,y,10);

[new_theta,cost_array]=gradient_descent(training_input,training_output,theta,alpha,iterations);

display(['Training error:',num2str(compute_cost(training_input,training_output,new_theta))]);
h=plot_data_function(training_input,training_output);
plot_boundary(training_input,new_theta);
display('Press enter')
pause
close(h)

display(['Test error:',num2str(compute_cost(test_input,test_output,new_theta))])
plot_data_function(test_input,test_output);
plot_boundary(test_input,new_theta);

display('Press enter')
pause