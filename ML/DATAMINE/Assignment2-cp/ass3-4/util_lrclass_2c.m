function y = util_lrclass_2c(X,w)
%% function ll = util_lrclass_2c(x,w)
% logistic regression binary classifier p(C|x,w)
% Input:
%   w: row sized [1, nParams]
%   X: column    [nInstance, nFeats]
% Output:
%   p(C|X,w)

%Make sure data feats & weight params # match.
assert(size(X,2)==numel(w)-1);


% Logistic regression prediction: y=1./(1+exp(-w'x)) 
y = 1./(1+exp(-w * [ones(size(X,1),1), X]'))';