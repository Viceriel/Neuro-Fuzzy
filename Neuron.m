classdef Neuron
    
    properties
       
        input;
        output;
        error;
        weights;
        previous_layer;
        
    end
    
    methods
       
        function obj = Neuron(previous)
            
           if isnan(previous) == false
               
               obj.previous_layer = previous;
               len = length(previous) + 1;
                
               for i = 1 : len
                  
                   obj.weights(i) = rand() * 2 - 1;
                   
               end
               
           end
               
       end
           
        function r = Sigmoid(obj)
           
            r = 1 / (1 + exp(-obj.input));
            
        end
        
        function r = Activate(obj)
            
            len = length(obj.previous_layer);
            sum = 0;
            
            for i = 1 : len
                
                sum = sum + obj.weights(i) * obj.previous_layer(i).output;
                
            end
            
            obj.input = sum - obj.weights(i + 1);
            obj.output = obj.Sigmoid(obj);
            
        end
        
    end
end