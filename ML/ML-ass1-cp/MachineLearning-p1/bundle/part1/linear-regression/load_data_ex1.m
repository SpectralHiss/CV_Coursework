function [X, y] = load_data_ex1()
%loads the data for excercise 1
    
    %read our data from a text file
    data = dlmread('ex1data1.txt');

    %load from the first column into X
    X = data(:, 1);
    %load from the second column into y
    y = data(:, 2);

    %add 1 to the input vector
    X = [ones(size(X, 1), 1), X];
end
