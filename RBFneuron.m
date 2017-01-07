classdef RBFneuron
   
    properties
       
        input;
        output;
        weights;
        layer_length;
        
    end
    
    methods
       
        function obj = RBFneuron(data)
           
            obj.layer_length = length(data) + 1;
            obj.weights = zeros(1, obj.layer_length);
            
            for i = 1 : obj.layer_length - 1
                
                obj.weights(i) = data(i);
                
            end
            
            obj.weights(obj.layer_length) = 10;
            
        end
        
        function obj = Activate(obj, data)
           
            obj.input = Distance(obj, data);
            out = exp(-(obj.input^2 / (2 * obj.weights(obj.layer_length)^2)));
            obj.output = exp(-(obj.input^2 / (2 * obj.weights(obj.layer_length)^2)));
            
        end
        
        function r = Distance(obj, data)
           
            len = length(data);
            r = sqrt(sum((data - obj.weights(1 : len)).^2));
            
        end
        
        function [obj, maximum] = WeightsChange(obj, gamma, data)
           
            
            for i = 1 : obj.layer_length - 1
               
                delta = gamma * (data(i) - obj.weights(i));
                obj.weights(i) = obj.weights(i) + delta;
                
                if i == 1
                   
                    maximum = abs(delta);
                    
                elseif abs(delta) > maximum
                    
                    maximum = delta;
                    
                end
                
            end
            
        end
        
    end
    
end