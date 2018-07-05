function [X, y] = load_data_ex2()
%loads the data for excercise 2

    %read our data from a text file
    data = dlmread('ex1data2.txt');

    %load from the first two columns into X
    X = data(:, 1:2);
    %load from the third column into y
    y = data(:, 3);
end