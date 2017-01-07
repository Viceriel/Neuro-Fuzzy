classdef RBFnetwork
   
    properties
    
        neural;
        gamma;
        size;
        layers = 3;
        
    end
    
    methods
       
        function obj = RBFnetwork(net, rate, data)
           
            obj.gamma = rate;
            obj.size = net;
            
            for i = 1 : 3
               
               for j = 1 : obj.size(i)
               
                   if i == 1
                      
                       layer(j) = Neuron(true);
                   
                   elseif i == 2
                       
                       layerR(j) = RBFneuron(data(j, :));
                       
                   else
                       
                       layer(j) = Neuron(net(i - 1));
                       
                   end
                                      
               end
               
             if i ~= 2  
                
                 obj.neural{i} = {layer(1 : net(i))};
                 
             else
                 
                 obj.neural{i} = {layerR(1 : net(i))};
            
             end
            
           end
        end
        
        function obj = UncontrolledLearning(obj, dataset, epsilon)
            
            delta = 5;
            len = length(dataset);
            
            while abs(delta) >= epsilon
               
                delta = 0;
                
                for i = 1 : len
                   
                    obj = Run(obj, dataset(i, :));
                    index =  Minimal(obj);
                    [obj.neural{2}{1}(index), delt] = WeightsChange(obj.neural{2}{1}(index), obj.gamma, dataset(i, :));
                    delta = delta + abs(delt);
                    
                end
                     
                delta = delta / len
                
            end
            
            beta = 0.3;
            
            for i = 1 : obj.size(2)
               
                mini = 0;
                
                for j = 1 : obj.size(2)
                    
                    if j ~= i
                       
                        obj.neural{2}{1}(j) = Activate(obj.neural{2}{1}(j), obj.neural{2}{1}(i).weights(1 : end - 1));
                        
                        if mini == 0
                       
                            mini =  obj.neural{2}{1}(j).input;
                        
                        elseif obj.neural{2}{1}(j).input < mini
                        
                            mini = obj.neural{2}{1}(j).input;
                            
                        end
                        
                    end
                        
                end
                
                obj.neural{2}{1}(i).weights(end) = mini / beta;
                    
             end
                
        end
        
        function obj = Learning(obj, data, answers)
           
            obj = Run(obj, data);
            
            for i = 1 : obj.size(3)
              
               obj.neural{3}{1}(i).error = answers(i) - obj.neural{3}{1}(i).input;
               obj.neural{3}{1}(i).err = abs(obj.neural{3}{1}(i).error);
               
               for j = 1 : obj.size(2)
                  
                   obj.neural{3}{1}(i).weights(j) = obj.neural{3}{1}(i).weights(j) + obj.gamma * obj.neural{3}{1}(i).error * obj.neural{2}{1}(j).output;
                   
               end
               
               obj.neural{3}{1}(i).weights(obj.size(2) + 1) = obj.neural{3}{1}(i).weights(obj.size(2) + 1) - obj.gamma * obj.neural{3}{1}(i).error;
               
            end
                  
        end
        
        function r = Minimal(obj)
           
            mini = obj.neural{2}{1}(1).input;
            r = 1;
            
            for i = 2 : obj.size(2)
               
                if mini > obj.neural{2}{1}(i).input
                   
                    mini = obj.neural{2}{1}(i).input;
                    r = i;
                    
                end
                
            end
            
        end
        
        function obj = Run(obj, data)
               
            for i = 1 : obj.size(1)
               
                obj.neural{1}{1}(i).output = data(i); 
                
            end
            
            datas = zeros(1, max(obj.size));
            
            for i = 2 : 3
               
                for j = 1 : obj.size(i)
                

                    for k = 1 : obj.size(i - 1)
                    
                        datas(k) = obj.neural{i - 1}{1}(k).output;
                        
                    end
                    
                    obj.neural{i}{1}(j) = Activate(obj.neural{i}{1}(j), datas(1 : obj.size(i - 1)));
                
                end
                
            end
            
        end
        
    end
    
end