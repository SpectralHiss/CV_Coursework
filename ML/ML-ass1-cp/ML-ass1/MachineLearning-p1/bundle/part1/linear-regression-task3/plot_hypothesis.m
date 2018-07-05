function plot_hypothesis(X, y, theta)
    figure(1);
    
    clf(1);
    plot(X(:, 2), y, 'rx');

    hold on;
    plot(X(:, 2), hypothesis_to_vector(X, theta));
    xlabel('x'); ylabel('y=f(x)');
end