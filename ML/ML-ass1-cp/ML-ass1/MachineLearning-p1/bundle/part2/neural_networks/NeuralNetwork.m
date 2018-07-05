
classdef NeuralNetwork < handle
    %
    %The neural network data structure
    %
    properties (Hidden)
      hidden_weights
      output_weights
      hidden_neurons
      output_neurons
      no_hidden_neurons
      weight_change_hidden
      weight_change_output
    end
    
    methods 
        
        function m=create_weights_matrix(neuralNetwork,no_inputs, no_outputs, filling)
            %
            %Makes a matrix of no_inputs (rows) x no_outputs (columns)
            %
            
            m = [];
            for i=1:no_inputs
                if exist('filling')
                    row=filling*ones(1,no_outputs);
                else
                    row=unifrnd(-1,1,[1,no_outputs]);
                end
                m=[m;row];
            end

        end

        function reset_activations(neuralNetwork)
            neuralNetwork.hidden_neurons = zeros(1,neuralNetwork.no_hidden_neurons);
            neuralNetwork.output_neurons = zeros(1,length(neuralNetwork.output_neurons));

        end  
        
    end
    
    methods (Static)
        
        function neuralNetwork=NeuralNetwork(no_input_neurons,no_hidden_neurons,no_output_neurons)
            
            neuralNetwork.hidden_weights = neuralNetwork.create_weights_matrix(no_input_neurons,no_hidden_neurons);
            neuralNetwork.output_weights = neuralNetwork.create_weights_matrix(no_hidden_neurons+1,no_output_neurons);
            neuralNetwork.hidden_neurons = zeros(1,no_hidden_neurons);
            neuralNetwork.output_neurons = zeros(1,no_output_neurons);
            neuralNetwork.no_hidden_neurons = no_hidden_neurons;
            neuralNetwork.weight_change_hidden = neuralNetwork.create_weights_matrix(no_input_neurons,no_hidden_neurons,0.0);
            neuralNetwork.weight_change_output = neuralNetwork.create_weights_matrix(no_hidden_neurons+1,no_output_neurons,0.0);
        end
        
        function [errors,nn,training_errors,test_errors]=train(patterns_input,patterns_output,no_hidden_neurons,iterations,learning_rate,test_set_input,test_set_output,is_iris)
            %
            %Trains the network.
            %
            
            no_inputs = length(patterns_input(1,:));
            no_inputs =no_inputs+1; % add bias
            no_targets = length(patterns_output(1,:));
            nn = NeuralNetwork(no_inputs,no_hidden_neurons,no_targets);
            errors = [];
            test_errors = [];
            training_errors = [];
            for i=1:iterations
                error = 0.0;
                for p=1:size(patterns_input,1)
                    inputs = [1.0,patterns_input(p,:)];
                    targets = patterns_output(p,:);
                    NeuralNetwork.forward_propagate(inputs,nn);
                    error =error+ NeuralNetwork.back_propagate(inputs,nn,targets,learning_rate);
                end
                error = error*(1.0/length(patterns_input));
                if exist('is_iris')
                    if is_iris
                        
                        training_errors=[training_errors, NeuralNetwork.get_error(patterns_input,patterns_output,nn)];
                        
                        test_errors=[test_errors, NeuralNetwork.get_error(test_set_input,test_set_output,nn)];
                    end
                end
                if mod(i , 10) == 0
                    display([ 'cost = ',num2str(error)])
                end
                if exist('is_iris')
                    if is_iris
                        if mod(i, 100) == 0
                            NeuralNetwork.test_iris(patterns_input,patterns_output,nn)
                        end
                    end
                end
                errors=[errors error];
            end
        end
    end
    
     methods (Static)
        function test_xor(patterns_input,patterns_output,nn)
            for p =1:4
                inputs = [1.0,patterns_input(p,:)];
                display(['target output:',num2str(patterns_output(p,:)), 'actual output', num2str(NeuralNetwork.forward_propagate(inputs,nn))])
            end
        end
     
        
        
        function J=back_propagate(inputs,nn,targets,learning_rate,batch)
            %
            %Backpropagates the error and performs gradient descent on the network weights
            %
            % Step 1. Output deltas (used to change weights from hidden --> output)
            output_deltas = zeros(1,length(nn.output_neurons));
            outputs=nn.output_neurons;
            for i=1:length(outputs)
                % we need to use the pre-sigmoidal output in the
                % deriverative, this is the linear combination of the
                % activation of the hidden layer with the output weights.
                output_deltas(i) = (outputs(i)-targets(i))*sigmoid_derivative(nn.output_neurons(i));
            end
            % Step 2. Hidden deltas (used to change weights from input --> output).
            hidden_deltas = zeros(1,length(nn.hidden_neurons));
            % hint... create a for loop here to iterate over the hidden neurons and for each
            % hidden neuron create another for loop to iterate over the ouput neurons
            for hidden_neuron_idx = 1:length(nn.hidden_neurons)
                sum_delta_weights = 0;
                for w = 1:length(outputs)
                    sum_delta_weights = sum_delta_weights + output_deltas(w) * nn.output_weights(hidden_neuron_idx);
                end
                
                hidden_deltas(hidden_neuron_idx) = sigmoid_derivative(nn.hidden_neurons(hidden_neuron_idx)) * sum_delta_weights;
             end

            % Step 3. update weights output --> hidden
            for i=1:length(nn.hidden_neurons)
                for j=1:length(output_deltas)
                    nn.output_weights(i,j) =nn.output_weights(i,j) -(output_deltas(j) * nn.hidden_neurons(i) * learning_rate);
                end
            end

            % here we are removing the bias from the hidden neurons as there is no
            % connection to it from the layer below
            hidden_deltas = hidden_deltas(2:end);

            % Step 4. update weights input --> hidden.
            % hint, use a similar process to step 3, except iterate over the input neurons and hidden deltas
            for i=2:length(inputs)
                for j=1:length(hidden_deltas)
                    nn.hidden_weights(i,j) = nn.hidden_weights(i,j) - (hidden_deltas(j) * inputs(i) * learning_rate);
                end
            end

            % this is our cost function
            J = 0.0;
            for t =1:length(targets)
                J = J + 0.5*(nn.output_neurons(t)-targets(t))^2;
            end
        end
        
        function propagation=forward_propagate(inputs,nn)
            %
            %Calculates the output by feeding the inputs forward through the network
            %
            nn.reset_activations()
            % activate hiddens_neurons
            for i=1:length(nn.hidden_neurons)
                hidden_neuron = 0.0;
                for j=1:length(inputs)
                    hidden_neuron =hidden_neuron + inputs(j) * nn.hidden_weights(j,i);
                end
                nn.hidden_neurons(i) = sigmoid(hidden_neuron);
            end
            nn.hidden_neurons = [1.0,nn.hidden_neurons];
            % activate output_neurons
            for i=1:length(nn.output_neurons)
                output_neuron = 0.0;
                for j=1:length(nn.hidden_neurons)
                    output_neuron = output_neuron+ nn.hidden_neurons(j) * nn.output_weights(j,i);
                end
                nn.output_neurons(i) = sigmoid(output_neuron);
            end

            propagation=nn.output_neurons;
        end
     
      
        function test_iris(patterns_input,patterns_output,nn)
            for p =1:5
                inputs = [1.0,patterns_input(p,:)];
                display(['target output:',num2str(patterns_output(p,:)), 'actual output', num2str(NeuralNetwork.forward_propagate(inputs,nn))])
            end
            for p =26:30
                inputs = [1.0,patterns_input(p,:)];
                display(['target output:',num2str(patterns_output(p,:)), 'actual output', num2str(NeuralNetwork.forward_propagate(inputs,nn))])
            end
            for p =51:55
                inputs = [1.0,patterns_input(p,:)];
                display(['target output:',num2str(patterns_output(p,:)), 'actual output', num2str(NeuralNetwork.forward_propagate(inputs,nn))])
            end
        end
      end
      methods (Static)  
        function error=get_error(patterns_input,patterns_output,nn)
            error = 0.0;
            for p= 1:size(patterns_input,1)
                inputs = [1.0,patterns_input(p,:)];
                NeuralNetwork.forward_propagate(inputs,nn);
                J = 0.0;
                
                for t=1:length(patterns_output(p,:))
                    J = J + (nn.output_neurons(t)-patterns_output(p,t))^2;
                end
                error = error+ J;
            end
            
        end
      
    end
end