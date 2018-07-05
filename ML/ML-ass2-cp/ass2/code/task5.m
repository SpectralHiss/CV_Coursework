function task5()
%% create new data
load('PB12')
J1 = [ X1, X1(:,1) + X1(:,2)];

%% train new models
m1 = mog(J1, 3, true);

end