
function [X,y]=load_data_ex1()
	%%
	%%loads data for exercise 2
	%%
	
    % read our data from a text file
	data=load('ex4x.dat');

	% load from the first two columns into x
	X=data(:,1:2);
	% load from the third column into y
	data=load('ex4y.dat');
	y=data;
    
	
