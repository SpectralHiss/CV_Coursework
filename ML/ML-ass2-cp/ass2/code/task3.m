function task3
%% partition data into training set and test set
load('PB12');

[ sp1 , ~  ] = size(X1);
[ sp2 , ~ ] = size(X2);
num_test_1 = floor(sp1 * 8 / 10);
num_test_2 = floor(sp2 * 8 / 10);

% using standard randomised 80/20 split
m1_perm = randperm(sp1);
m2_perm = randperm(sp2);

training_set_m1 = X1(m1_perm(1:num_test_1),:);
training_set_m2 = X2(m2_perm(1:num_test_2),:);

test_set = [X1(m2_perm(num_test_1+1:end),:); X2(m2_perm(num_test_2 + 1:end),:)];

%% learn model 1  (learned with points 1)
m1 = mog(training_set_m1,3 , false);

figure(2);

%% learn model 2
m2 = mog(training_set_m2,3 , false);


%% classify data & check accuracy

confusion_mat = zeros([2 2]);

% we use the fact that we created the test set by concatenating p1 and p2
% test set.
% elements 1 to p1_last are harmonics of phoneme 1
% elements onwards are harmonics of phoneme 2

p1_last = (sp1 - num_test_1);

for p1_idx = 1:p1_last
    
    p1_datum = test_set(p1_idx,:);
    
    if comp_mix_like(p1_datum,m1) > comp_mix_like(p1_datum, m2)
        % good match
        confusion_mat(1,1) = confusion_mat(1,1) + 1;
    else
        confusion_mat(2,1) = confusion_mat(2,1) + 1;
    end
end

[ p2_last , ~ ] = size(test_set);
 
for p2_idx = p1_last + 1:p2_last
    p2_datum = test_set(p2_idx,:);
    
    if comp_mix_like(p2_datum,m2) > comp_mix_like(p2_datum, m1)
        % good match
        confusion_mat(2,2) = confusion_mat(2,2) + 1;
    else
        confusion_mat(1,2) = confusion_mat(1,2) + 1;
    end
end

confusion_mat

mis_class_rate = (confusion_mat(1,2) + confusion_mat(2,1)) / sum(confusion_mat(:))

end
