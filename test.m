function [ y_n, u_n ] = test( net, F, G, C, w, norm )
%   Test procedure of neural network

    q = zeros(size(F, 1), 501);
    q(:, 1) = [3, 6, 9, 7]';
    u_n = zeros(4, 500);
    y_n = zeros(2, 500);
    len = length(w);
    u_limit = 200;

    for i = 1 : len
            
            y_n(1, i) = C(1, :) * q(:, i);
            y_n(2, i) = C(2, :) * q(:, i);
            
            net = run(net,[(((w(i) - q(1, i)) / norm(1)) + 1) / 2, ((-q(3,i) / norm(2)) + 1) / 2, ((q(1,i) / norm(3)) + 1) / 2, ((q(2,i) / norm(4)) + 1) / 2, ((q(3,i) / norm(5)) + 1) / 2, ((q(4,i) / norm(6)) + 1) / 2]);
            u_n(1, i) = net.neural{3}{1}(1).output * 400 - 200;
            
            if u_n(1, i) > u_limit
            
                u_n(1, i) = u_limit;
                
            end;
            
            if u_n(1, i) < (-u_limit)
                
                u_n(1, i) = -u_limit;
                
            end;

            q(:, i + 1) = F * q(:, i) + G * u_n(1,i);
    end

end

