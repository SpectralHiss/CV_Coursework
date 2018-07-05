function task2()
%% load and filter data

load('PB_data.mat')

indeces_1  = find(phno == 1);
indeces_2  = find(phno == 2);

p1_f1 = f1(indeces_1);
p1_f2 = f2(indeces_1);
p1 = [p1_f1,p1_f2];

p2_f1 = f1(indeces_2);
p2_f2 = f2(indeces_2);
p2 = [p2_f1, p2_f2];

%% run mog on p1 k=3 , save model


s1 = mog(p1,3, false);


save('p1_k3' ,'s1');

%% run mog on p1 k=6

mog(p1,6, false)

%% run mog on p2 k=3 , save model

s2 = mog(p2,3, false);
save('p2_k3','s2');

end