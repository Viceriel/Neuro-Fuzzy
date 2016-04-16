function [ F, G, C, K, delta ] = pendulum( M, m, b, I, g, l )
%Creating a discrete state space model of inverse pendulum based on input
%arguments
%M Cart Mass
%m Pole Mass
%b Friction coefficient
%I Moment of Inertia
%g Gravity Acceleration
%l Pole Length
%output F- matrix of system dynamic
%output G- matrix of inputs
%output C- matrix of outputs
%output K- feedback gain
%output delata- periode

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

%feedback gain computation
    p1 = 0.7;
    p2 = 0.8;
    p3 = 0.9;
    p4 = 0.95;
    desired_dynamics = [p1, p2, p3, p4];
    K = place(F, G, desired_dynamics);
    
end

