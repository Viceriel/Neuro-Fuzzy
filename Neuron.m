classdef Neuron
    
    properties
       
        input;
        output;
        error;
        weights;
        layer_length;
        
    end
    
    methods
       
        function obj = Neuron(size)
            
            if size ~= true
               
               obj.layer_length = size;
               len = size + 1;
                
               for i = 1 : len
                  
                   obj.weights(i) = rand() * 2 - 1;
                   
               end
               
           end
               
       end
           
        function r = Sigmoid(obj)
           
            r = 1 / (1 + exp(-obj.input));
            
        end
        
       function r = DerivateSigmoid(obj)
           
            r = (exp((-1.0) * obj.input) / ((1.0+exp((-1.0) * obj.input)) * (1.0 + exp((-1.0) * obj.input)))); 
            
        end
        
        function r = Activate(obj, data)
            
            data(end + 1) = -1;
            obj.input = data * obj.weights';
            
            obj.output = Sigmoid(obj);
            r = obj;
            
        end
        
        function r = WeightChange(obj, gamma, outputs)
            
            outputs(end + 1) = -1;
            obj.weights = obj.weights + gamma * obj.error * outputs;
            r = obj;
            
        end
        
    end
end