function hypothesis=hypothesis_to_list(X,theta):
    %%
    %%returns the hypothesis as a vector
    %%
    hypothesis = zeros(size(X,1),1)
    for i =1:size(X,1)
        hypothesis(i)=calculate_hypothesis(X,theta,i);
    end
    %END OF FUNCTION

    