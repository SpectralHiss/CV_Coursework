function [X,y]=load_data_ex1()
	%%
	%%loads data for exercise 2
	%%
	% read our data from a text file
	data=load('iris.dat');
	% load from the first two columns into x
	X=data(:,1:4);
	% load from the third column into y
	yy=data(:,5:5);

	y = [];
	for t= 1:length(yy)
		target = [0,0,0];
		target(1,yy(t)+1) = 1;
		y=[y;target];
    end


