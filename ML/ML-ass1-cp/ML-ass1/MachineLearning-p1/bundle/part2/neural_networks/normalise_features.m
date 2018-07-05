function [N,mu,sigma]=normalise_features(X)
    %%
    %%Normalise our features by subtracting the mean
    %%and dividing by the standard deviation
    %%
    mu = mean(X);
    sigma = std(X);
    t = ones(length(X),1);
    N = (X - (t*mu))./(t * sigma);
    
    

