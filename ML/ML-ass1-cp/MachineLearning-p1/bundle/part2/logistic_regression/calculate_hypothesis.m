function result=calculate_hypothesis(X,theta,training_example)
    hypothesis = theta*X(training_example,:)';
    %%%%%%%%%%%%%%%%%%%%%%%%
    %Calculate the hypothesis for the i-th training example in X.
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    result=sigmoid(hypothesis);
%END OF FUNCTION
    

