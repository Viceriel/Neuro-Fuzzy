function [ net ] = train( net, dataset, cycles )
%Training procedure of neural network
%net neural network
%dataset data used for training
%number of training epochs
%output net- trained neural network
    
    %controller = readfis('TSK');
    lengt = length(dataset);
    delt = 0;

    for i = 1 : cycles
        
        error = 0;
    
        for j = 1 : lengt
        
            net = Learning(net, dataset(1 : 6, j), dataset(7, j));
            error = error + abs(net.neural{3}{1}(1).err);
                 
        end
    
        error = error / lengt;
        %delt = abs(error - delt);
        %net.gamma = evalfis([error delt], controller);
        %delt = error;
        error
       
    end
end

