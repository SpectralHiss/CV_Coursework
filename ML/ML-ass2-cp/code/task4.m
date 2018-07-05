function task4()


%% loading model trained on full data and k=3 in task 2
m1 = load('p1_k3');
m2 = load('p2_k3');
load('PB12')


%% generating  dataset which contains a random permutation of F1 values from X1 and X2,  and F2 values in the range of X1 and X2
[ sf1 , ~ ] = size(X1);
[ sf2 , ~ ] = size(X2);

allF1 = [X1(:,1);X2(:,1)];
allF2 = [X1(:,2);X2(:,2)];

all_data_size = sf1 + sf2;

x1 =  allF1(randperm(all_data_size));
x2 =  allF2(randperm(all_data_size));

%% using trained model on data to classify (what's the point?)
M = zeros([all_data_size, all_data_size])

for i = 1:all_data_size
    for j = 1:all_data_size
        datapoint = [x1(i), x2(j)];
        if comp_mix_like(datapoint, m1.s1) > comp_mix_like(datapoint,m2.s2)
            M(i,j) = 1;
        else
            M(i,j) = 2;
        end
    end
end

imagesc(M);



end