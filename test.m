function [ y_n, u_n ] = test( net, F, G, C, w, norm )
%Test procedure of neural network
%net neural network
%F matix of system dynamic
%G matrix of inputs
%C matrix of outputs
%w control vector
%norm norm coeficients for network
%output y_n- output of system
%output u_n

    q = zeros(size(F, 1), 501);
    q(:, 1) = [1, 2, 3, 4]';
    u_n = zeros(4, 500);
    y_n = zeros(2, 500);
    len = length(w);
    u_limit = 200;

    for i = 1 : len
            
            y_n(1, i) = C(1, :) * q(:, i);
            y_n(2, i) = C(2, :) * q(:, i);
            
            dat = [w(i) - q(1, i), -q(3,i), q(1,i), q(2,i), q(3,i), q(4,i)];
            net = Run(net, dat);
            u_n(1, i) = net.neural{3}{1}(1).input;
            
            if u_n(1, i) > u_limit
            
                u_n(1, i) = u_limit;
                
            end;
            
            if u_n(1, i) < (-u_limit)
                
                u_n(1, i) = -u_limit;
                
            end;

            q(:, i + 1) = F * q(:, i) + G * u_n(1,i);
    end

end

