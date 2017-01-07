function [ dataset, norm ] = createDataset(F, G, C, K, delta, optional)
%Creating a dataset for neural network trainning
%F matrix of system dynamic
%G matrix of inputs
%C matrix of outputs
%K feedback gain
%delta periode
%output dataset- created dataset
%output norm- norm coeficients for neural network

    dataset=[];
    I = eye(size(F));
    N = 1/(C(1, :) * ((I - (F - G * K))^(-1)) * G);

    for amplitude=0.5:0.2:4
        
        for hertz=0.5:0.1:5
    
            time = 600;
            C1 = [1 0 0 0];
            C2 = [0 0 1 0];
            y_step_stairs = delta * [0:time-1];

            u_limit = 200;

            % Sine wave:
            Fc = hertz;                                 % hertz
            w = sin(2*pi*Fc*y_step_stairs)*amplitude;
            q = zeros(size(F, 1), time+1);
            q(:, 1) = [3, 6, 9, 7]';
            u_w = zeros(4, time);
            y_w = zeros(2, time);
            e = zeros(6,time);
            y_w(1, 1) = C1 * q(:, 1);
            y_w(2, 1) = C2 * q(:, 1);
        
            for i = 1 : time
                
                u_w(:, i) = -K * q(:, i) + N * w(1, i);
                
                if u_w(1,i)>u_limit
                    
                    u_w(1,i)=u_limit;
                
                end
                if u_w(1,i)<(-u_limit)
                    
                    u_w(1,i)=-u_limit;
                    
                end

                q(:, i+1) = F*q(:, i)+G*u_w(1,i);
                y_w(1, i) = C1*q(:, i);
                y_w(2, i) = C2*q(:, i);
                e(1,i)= w(i) -q(1,i);
                e(2,i)= -q(3,i);
                e(3, i) = q(1,i);
                e(4, i) = q(2,i);
                e(5,i)= q(3,i);
                e(6,i)= q(4,i);

            end
        
        dataset_h = [e; u_w(1,:)];
        dataset = [dataset dataset_h];
        
        end
        
    end
    
    if optional == 1
        
        norm(1) = max(max(dataset(1, :)), -min(dataset(1, :)));
        norm(2) = max(max(dataset(2, :)), -min(dataset(2, :)));
        norm(3) = max(max(dataset(3, :)), -min(dataset(3, :)));
        norm(4) = max(max(dataset(4, :)), -min(dataset(4, :)));
        norm(5) = max(max(dataset(5, :)), -min(dataset(5, :)));
        norm(6) = max(max(dataset(6, :)), -min(dataset(6, :)));
        norm(7) = max(max(dataset(7, :)), -min(dataset(7, :)));
    
        dataset(1, :) = (dataset(1, :) / (max(max(dataset(1, :)), -min(dataset(1, :)))) + 1) / 2;
        dataset(2, :) = (dataset(2, :) / (max(max(dataset(2, :)), -min(dataset(2, :)))) + 1) / 2;
        dataset(3, :) = (dataset(3, :) / (max(max(dataset(3, :)), -min(dataset(3, :)))) + 1) / 2;
        dataset(4, :) = (dataset(4, :) / (max(max(dataset(4, :)), -min(dataset(4, :)))) + 1) / 2;
        dataset(5, :) = (dataset(5, :) / (max(max(dataset(5, :)), -min(dataset(5, :)))) + 1) / 2;
        dataset(6, :) = (dataset(6, :) / (max(max(dataset(6, :)), -min(dataset(6, :)))) + 1) / 2;
        dataset(7, :) = (dataset(7, :) / (max(max(dataset(7, :)), -min(dataset(7, :)))) + 1) / 2;
        
    else
        
        norm = 0;
        
    end
    
end

