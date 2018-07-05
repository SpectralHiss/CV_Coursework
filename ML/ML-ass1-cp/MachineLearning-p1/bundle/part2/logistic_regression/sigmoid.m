function output=sigmoid(z)
 output = arrayfun(@(x)(1/(1+exp(-x))), z);
end