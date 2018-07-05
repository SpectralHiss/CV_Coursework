function J=compute_cost(X, y, theta)
    %
    %Compute cost for linear regression. Takes an input matrix X of training
    %examples, a parameter vector, theta, and an output vector y
    %
    J = 0.0; % cost
    m = size(X,1); % no. training examples
    for i=1:m
        hypothesis = calculate_hypothesis(X,theta,i);
        output = y(i);
        cost = -output*log(hypothesis)-(1-output)*log(1-hypothesis);
        % modify this to calculate the cost function, using hypothesis and output
        %cost = 0.0;
        J =J+cost;
        
    end
    J = J*(1.0/m);
    %END OF FUNCTION

