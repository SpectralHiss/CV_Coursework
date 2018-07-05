function [theta,cost_array]=gradient_descent(X,y,theta,alpha,iterations)
   %%
   %% do Gradient Descent for a given X, y, theta, alpha
   %% for a specified no. of iterations
   %%
    m = size(X,1); % no. training examples
    cost_array = zeros(iterations,1); % will store the results of our cost function
    for it =1:iterations
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % gradient descent
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        theta_temp =theta;

        for t= 1:length(theta)
            sigma = 0.0;
            for i =1:m
                hypothesis = calculate_hypothesis(X,theta,i);
                output = y(i)
                sigma = sigma+(hypothesis - output)*X(i,t);
            end
            theta_temp(t) = theta_temp(t) - alpha*sigma;
        end
        theta = theta_temp;

        % update cost_array
        cost_array(it)=compute_cost(X, y, theta);
    end
    % this plots our cost over time:
    h=plot_cost(cost_array);
    %END OF FUNCTION
    

    