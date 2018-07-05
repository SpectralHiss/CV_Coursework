function [N, mean_vector, std_vector] = normalise_features(X)
    %NORMALISE_FEATURES Normalise our features by subtracting the mean and
    %dividing by the standard deviation

    num_rows = size(X, 1);

    mean_vector = mean(X);
    std_vector = std(X);

    %subtract column mean
    N = X - ones(num_rows, 1) * mean_vector;
    %divide each element by column standard deviation
    N = N ./ (ones(num_rows, 1) * std_vector);
end