% Linearized inverted pendulum for upward position
clc, clear, close all;

M = .5; % Cart Mass
m = 0.2; % Pole Mass
b = 0.1; % Friction coefficient
I = 0.006; % Moment of Inertia
g = 9.8; % Gravity Acceleration
l = 0.3; % Pole Length

p = I*(M+m)+M*m*l^2; % Denominator in matrices A and B

% State Space Vector: [Cart Position, Cart Velocity, Pole Angle, Pole Angle Velocity]';

A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
 
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
    
C = [1 0 0 0;
     0 0 1 0];
 
D = [0;
     0];
 
% Discrete Model: 

delta = 0.1*(max(abs(real(eig(A)))))^(-1);
[F, G] = c2d(A, B, delta);

p1 = 0.7;
p2 = 0.8;
p3 = 0.9;
p4 = 0.95;
desired_dynamics = [p1, p2, p3, p4];
K = place(F, G, desired_dynamics);

%-------Algorithm----------
dataset=[];
for amplitude=0.5:0.2:4
    for hertz=0.5:0.1:5
    
        time = 600;
        u = zeros(4, time);
        y = zeros(2, time);
        C = [1 0 0 0];
        C1 = [1 0 0 0];
        C2 = [0 0 1 0];
        w = zeros(1, time);
        y_step_stairs = delta * [0:time-1];

        u_limit = 200;

        % Step wave
        stepStart = 2;
        stepStop = 5;
        %w((y_step_stairs>=stepStart)&(y_step_stairs<=stepStop)) = amplitude;

        % Sine wave:
        dt = delta;                   % seconds per sample
        Fc = hertz;                     % hertz
        w = sin(2*pi*Fc*y_step_stairs)*amplitude;
        

        I = eye(size(F));

        N = 1/(C*((I-(F-G*K))^(-1))*G);

        q = zeros(size(A, 1), time+1);
        q(:, 1) = [3, 6, 9, 7]';
        u_w = zeros(4, time);
        y_w = zeros(2, time);
        e=zeros(6,time);
        y_w(1, 1) = C1*q(:, 1);
        y_w(2, 1) = C2*q(:, 1);
        
        for i = 1:time
            u_w(:, i) = -K*q(:, i)+N*w(1, i);
            if u_w(1,i)>u_limit
                u_w(1,i)=u_limit;
            end;
            if u_w(1,i)<(-u_limit)
                u_w(1,i)=-u_limit;
            end;

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
        
        dataset_h=[e; u_w(1,:)];
        dataset=[dataset dataset_h];
    end;
end;

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

net = Network([6 10 1], 0.2, 3);
controller = readfis('TSK');
lengt = 400000;
delt = 0;

for i = 1 : 5
        
    error = 0;
    
    for j = 1 : lengt
        
          net = learning(net, dataset(1 : 6, j), dataset(7, j));
          error = error + abs(net.neural{3}{1}.err);
          
          if mod(j, 10000) == 0
              
              j
              
          end
          
    end
    
    error = error / lengt;
    delt = abs(error - delt);
    net.gamma = evalfis([error delt], controller);
    delt = error;
    error
    i
    
end

w(1 : 500) = 2;
q = zeros(size(A,1), 501);
q(:, 1) = [3, 6, 9, 7]';
u_n = zeros(4, 500);
y_n = zeros(2, 500);

for i = 1 : 500
            y_n(1, i) = C1*q(:, i);
            y_n(2, i) = C2*q(:, i);
            
            net = run(net,[(((w(i) - q(1, i)) / norm(1)) + 1) / 2, ((-q(3,i) / norm(2)) + 1) / 2, ((q(1,i) / norm(3)) + 1) / 2, ((q(2,i) / norm(4)) + 1) / 2, ((q(3,i) / norm(5)) + 1) / 2, ((q(4,i) / norm(6)) + 1) / 2]);
            u_n(1, i) = net.neural{3}{1}(1).output * 400 - 200;
            if u_n(1,i)>u_limit
                u_n(1,i)=u_limit;
            end;
            if u_n(1,i)<(-u_limit)
                u_n(1,i)=-u_limit;
            end;

            q(:, i+1) = F*q(:, i)+G*u_n(1,i);
end
 

plot(y_n(1, :));
hold all
plot(y_n(2, :));