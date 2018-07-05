function mllab3()
    % load input data
    X = [-0.99768; -0.69574; -0.40373; -0.10236; 0.22024;  0.47742;  0.82229];

    % load output data
    y = [2.0885; 1.1646; 0.3287; 0.46013; 0.44808; 0.10013; -0.32952];

    % insert the bias into the input data
    X = [ones(size(X, 1), 1), X];

    % perform a polynomial expansion to the fifth order
    for j = 2:5
        X = [X, X(:, 2) .^ j];
    end

    % initialise theta
    theta = [1.0, 1.0, 1.0, 1.0, 1.0];

    alpha = 0.01;
    l = 0.0;
    iterations = 1000;
    do_plot = false;

    % run gradient descent
    % you will need to modify the gradient_descent function to accept an
    % additional argument lambda (l).
    theta = gradient_descent(X, y, theta, alpha, iterations, l, do_plot)

    % plot the original data
    original_x = [-0.99768; -0.69574; -0.40373; -0.10236; 0.22024;  0.47742;  0.82229];

    figure(1);
    plot(original_x, y, 'x');
    hold on;
        
    x = linspace(-1, 1, 1000);
    y = [];

    for index = 1:1000
        y = [y, get_hypothesis(x(index), theta)];
    end

    plot(x, y,'-');

    disp 'Press enter to exit.';
    pause;

    close(1);
end

function hypothesis = get_hypothesis(x, theta)
% helper function which we will use to calculate the
% hypothesis for a given x and theta

    hypothesis = 0.0;
    
    for t = 1:length(theta)
        hypothesis = hypothesis + theta(t) * (x ^ (t - 1));
    end
end