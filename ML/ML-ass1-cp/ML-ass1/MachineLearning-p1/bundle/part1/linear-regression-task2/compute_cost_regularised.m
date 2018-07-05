function J = compute_cost_regularised(X, y, theta, l)
    %COMPUTE_COST_REGULARISED Compute cost for regularised linear regression.
    %Takes as input matrix X of training examples, a parameter vector, theta, 
    %lambda (l) and an output vector y

    total_squared_error = 0.0; %cost
    m = size(y, 1); %number of training examples

    for i = 1:m
        hypothesis = calculate_hypothesis(X, theta, i);
        output = y(i);
        squared_error = (hypothesis - output) ^ 2;
        total_squared_error = total_squared_error + squared_error;
    end

    total_regularised_error = 0.0;

    for i = 2:length(theta)
        total_regularised_error = total_regularised_error + theta(i) ^ 2;
    end

    total_regularised_error = total_regularised_error * l;

    J = (1.0 / (2 * m)) * (total_squared_error + total_regularised_error);
end