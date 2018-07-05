% this loads our data
[X,y] = load_data_ex1();
% now we want to normalise our data
[X,mean,std] = normalise_features(X);
% after normalising we add the bias
X=[ones(size(X,1),1) X];
h=plot_data_function(X,y);