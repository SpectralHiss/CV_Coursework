

	

    function [training_input,training_output,test_input,test_output]=return_test_set(X,y,test)
	% create a list of random indexes
	scrambled_indexes = randperm(size(X,1));
	
	training_input=X(scrambled_indexes(1:test),:);
    training_output=y(scrambled_indexes(1:test),:);
    
    test_input=X(scrambled_indexes(test+1:end),:);
    test_output=y(scrambled_indexes(test+1:end),:);