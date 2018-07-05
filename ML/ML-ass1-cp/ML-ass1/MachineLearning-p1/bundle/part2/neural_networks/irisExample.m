
training_set_input = [];
training_set_output = [];
[inputs,outputs] = load_data_ex1();
[normalise,mu,sigma] = normalise_features(inputs);
for p =1:length(normalise)
    training_set_input=[training_set_input;normalise(p,:)];
    training_set_output=[training_set_output;outputs(p,:)];
end
actual_training_set_input = [training_set_input(1:25,:);training_set_input(51:75,:);training_set_input(101:125,:)];
actual_training_set_output = [training_set_output(1:25,:);training_set_output(51:75,:);training_set_output(101:125,:)];
actual_test_set_input = [training_set_input(26:50,:);training_set_input(76:100,:);training_set_input(126:150,:)];
actual_test_set_output = [training_set_output(26:50,:);training_set_output(76:100,:);training_set_output(126:150,:)];

hidden_neurons = 10;
[errors,nn,tr_errors,t_errors] = NeuralNetwork.train(actual_training_set_input,actual_training_set_output,hidden_neurons,1000,0.1,actual_test_set_input,actual_test_set_output,true)
display([ 'Error training:',num2str(NeuralNetwork.get_error(actual_training_set_input,actual_training_set_output,nn))])
display([ 'Error testing:',num2str(NeuralNetwork.get_error(actual_test_set_input,actual_test_set_output,nn))])
display('plotting errors')
h=figure();
plot(errors)
xlabel('iterations')
ylabel('cost')
display('press enter:')
pause()
close(h)
display('plotting differences between training and test sets')
h=figure();
plot(tr_errors,'b-')
hold on,
plot(t_errors,'r-')
display('press enter:')
pause()
close(h)
