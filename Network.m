classdef Network
    
    properties
        
        neural;
        gamma;
        size;
        layers;
        
    end
    
    methods
        
        function obj = Network(net, rate, neuron_layers)
            
            obj.gamma = rate;
            obj.layers = neuron_layers;
            obj.size = net;
            
            for i = 1 : neuron_layers
               
                for j = 1 : net(i)
                   
                    if i == 1
                       
                        layer(j) = Neuron(true);
                    
                    else
                       
                        layer(j) = Neuron(net(i - 1));
                        
                    end
                    
                end
                
                obj.neural{i} = {layer(1 : net(i))};
                
            end
        end
        
        function r = run(obj, data)
           
            for i = 1 : obj.size(1)
            
                obj.neural{1}{1}(i).output = data(i);
                
            end
            
            data = zeros(1, max(obj.size));
            
            for i = 2 : obj.layers
                
               for k = 1 : obj.size(i - 1)
                    
                    data(k) = obj.neural{i - 1}{1}(k).output;
                    
               end
                
                for j = 1 : obj.size(i)
                                       
                    d = data(1 : obj.size(i - 1));
                    obj.neural{i}{1}(j) = Activate(obj.neural{i}{1}(j), d);
                    
                end
                
            end
            
            r = obj;
            
        end
        
        function r = learning(obj, data, answers)
           
            obj = run(obj, data);
            
            for i = 1 : obj.size(end)
               
                delta = answers(i) - obj.neural{end}{1}(i).output;
                delta = delta * DerivateSigmoid(obj.neural{end}{1}(i));
                obj.neural{end}{1}(i).error = delta;
                
            end
            
            obj = DeltaDistribution(obj);
            dat = zeros(1, max(obj.size));
                       
            for i = 2 : obj.layers
                
                 for k = 1 : obj.size(i - 1)
                    
                    dat(k) = obj.neural{i - 1}{1}(k).output;
                    
                 end
               
                for j = 1 : obj.size(i)
                   
                    d = dat(1 : obj.size(i - 1));
                    obj.neural{i}{1}(j) = WeightChange(obj.neural{i}{1}(j), obj.gamma, d);
                    
                end
                
            end
            
            r = obj;
        end
        
        function r = DeltaDistribution(obj)
           
            for i = obj.layers - 1 : -1 : 2
                
                for j = 1 : obj.size(i)
                    
                    sum = 0;
                   
                    for k = 1 : obj.size(i + 1)
                       
                        del = obj.neural{i + 1}{1}(k).error;
                        sum = sum + obj.neural{i + 1}{1}(k).error * obj.neural{i + 1}{1}(k).weights(j); 
                        
                    end
                    
                    sum = sum * DerivateSigmoid(obj.neural{i}{1}(j));
                    obj.neural{i}{1}(j).error = sum;
                    
                end
                
                r = obj;
                
            end
            
        end
        
    end
end