function task1()
    load('PB_data.mat');
    J = [f1,f2];
    
    f = figure();
    plot(J(:,1),J(:,2),'.');
    saveas(f, 'out/plot_f0f1','png');
end