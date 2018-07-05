function J = compute_cost(X, y, theta)
    %COMPUTE_COST Compute cost for linear regression. Takes as input
    %matrix X of training examples, a parameter vector, theta, and an
    %output vector y

    J = 0.0; %cost
    m = size(y, 1); %number of training examples

    for i = 1:m
        hypothesis = calculate_hypothesis(X, theta, i);
        output = y(i);
        squared_error = (hypothesis - output) ^ 2;
        J = J + squared_error;
    end

    J = J * (1.0 / (2 * m));
end