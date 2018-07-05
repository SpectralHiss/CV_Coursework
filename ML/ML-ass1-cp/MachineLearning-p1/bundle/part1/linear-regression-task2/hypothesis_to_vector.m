function hypothesis_vec = hypothesis_to_vector(X, theta)
    hypothesis_vec = [];

    for i = 1:size(X, 1)
        hypothesis_vec = [hypothesis_vec; calculate_hypothesis(X, theta, i)];
    end
end