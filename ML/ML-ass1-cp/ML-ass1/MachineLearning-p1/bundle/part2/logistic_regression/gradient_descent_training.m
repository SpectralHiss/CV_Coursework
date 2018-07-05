function [theta,cost_array_training]=gradient_descent_training(X,y,test_X,test_y,theta,alpha,iterations)
    %%
    %%do Gradient Descent for a given X, y, theta, alpha
    %%for a specified no. of iterations
    %%
    m = size(X,1); % no. training examples
    cost_array_training = zeros(1,iterations); % will store the results of our cost function
    cost_array_test = zeros(1,iterations); % will store the results of our cost function
    for it =1:iterations
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % gradient descent
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        theta_temp = theta;

        for t =1:length(theta)
            sigma = 0.0;
            for i =1:m
                hypothesis = calculate_hypothesis(X,theta,i);
                output = y(i);
                sigma =sigma+ (hypothesis - output)*X(i,t);
            end
            theta_temp(t) = theta_temp(t) - alpha*sigma;
        end
        theta = theta_temp;

        % update cost_array
        % add code here: to update cost_array_training and cost_array_test
        cost_array_training(it) =  compute_cost(X,y,theta);
        cost_array_test(it) =   compute_cost(test_X, test_y, theta);
    end
    % this plots our cost over time:
    h=plot_cost2(cost_array_training,cost_array_test)
    display('Press Enter')
    pause
    close(h)
    
    %END OF FUNCTION


