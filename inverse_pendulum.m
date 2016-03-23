% Linearized inverted pendulum for upward position
clc, clear, close all;
% PRVA ZMENA
% Druha zmena
% TRETIA ZMENA

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
