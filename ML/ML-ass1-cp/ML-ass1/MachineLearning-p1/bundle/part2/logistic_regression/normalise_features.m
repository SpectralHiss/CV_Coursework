function [N,Mean,Std]=normalise_features(X)
    %%
    %%Normalise our features by subtracting the mean
    %%and dividing by the standard deviation
    %%
    columns = size(X,2);
    rows = size(X,1);
    N = zeros(rows,columns);
    Mean = mean(X);
    Std = std(X);
    for column = 1:columns
        N(:,column) = (X(:,column)-Mean(column))/Std(column);
    end
    %END OF FUNCTION
    
    
    
    
    