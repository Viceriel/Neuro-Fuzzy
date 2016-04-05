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

p1 = 0.8;
p2 = 0.85;
p3 = 0.9;
p4 = 0.95;
desired_dynamics = [p1, p2, p3, p4];
K = place(F, G, desired_dynamics);

Fu = (F-G*K);

time = 100;
x = zeros(length(A), time+1);
x(:, 1) = [3, 6, 9, 7]';
u = zeros(4, time);
y = zeros(2, time);

for i = 1:time
    u(:, i) = -K*x(:, i);
    x(:, i+1) = Fu*x(:, i);
    y(:, i) = C*x(:, i);
end

h = figure;
set(h, 'NumberTitle', 'off', ...
       'Name', 'Inverted Pendulum');
   
[y_step_stairs, y_stairs] = stairs(0:time-1, u(1, 1:end));%x(4, 1:end-1));
y_step_stairs = delta*y_step_stairs;
stairs(y_step_stairs, y_stairs);
xlabel('t[s]');
ylabel('y(i)');
title('Pendulum Position');
grid on;
xlim([0 max(y_step_stairs)]);

C = [1 0 0 0];
w = zeros(1, time);

stepStart = 3;
stepStop = 6;
amplitude = 3;
w((y_step_stairs>=stepStart)&(y_step_stairs<=stepStop)) = amplitude;
I = eye(size(F));

N = 1/(C*((I-(F-G*K))^(-1))*G);

q = zeros(size(A), time+1);
q(:, 1) = [3, 6, 9, 7]';
u_w = zeros(4, time);
y_w = zeros(2, time);

for i = 1:time
    u_w(:, i) = -K*q(:, i)+N*w(1, i);
    q(:, i+1) = Fu*q(:, i)+G*N*w(1, i);
    y_w(:, i) = C*q(:, i);
end

h = figure;
set(h, 'NumberTitle', 'off', ...
       'Name', 'Inverted Pendulum');
   
[y_step_stairs, y_stairs] = stairs(0:time-1, y_w(1, :));
y_step_stairs = delta*y_step_stairs;
stairs(y_step_stairs, y_stairs);
xlabel('t[s]');
ylabel('y(i)');
title('Pendulum Position');
grid on;
hold on;
xlim([0 max(y_step_stairs)]);

[y_step_stairs, y_stairs] = stairs(0:time-1, w(:));
y_step_stairs = delta*y_step_stairs;
stairs(y_step_stairs, y_stairs, 'r');
legend('Cart Position', 'Reference trajectory');
%%
clear all
clc

data = [0 0; 0 1; 1 0; 1 1];
net = Network([2 2 1], 0.2, 3);
w1 = net.neural{3}{1}(1).weights;

controller = readfis('TSK');
delta = 0;

for i = 1 : 50000
   
    error = 0;
    net = learning(net, data(1, :), 0);
    error = error + abs(net.neural{3}{1}.error);
    net = learning(net, data(2, :), 1);
    error = error + abs(net.neural{3}{1}.error);
    net = learning(net, data(3, :), 1);
    error = error + abs(net.neural{3}{1}.error);
    net = learning(net, data(4, :), 0);
    error = error + abs(net.neural{3}{1}.error);
    
    error = error / 4;
    delta = abs(error - delta);
    net.gamma = evalfis([error delta], controller);
    delta = error;
    
end

net = run(net, data(1, :));
a1 = net.neural{3}{1}(1).output;
net = run(net, data(2, :));
a2 = net.neural{3}{1}(1).output;
net = run(net, data(3, :));
a3 = net.neural{3}{1}(1).output;
net = run(net, data(4, :));
a4 = net.neural{3}{1}(1).output;
w2 = net.neural{3}{1}(1).weights;
