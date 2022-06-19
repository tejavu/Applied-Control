% Copyright 2018 The MathWorks, Inc. 

function x = myInvertedPendelumFcn(x,u)

% Sample time [s]
Ts = 0.001; 

g = 9.81;
l= 0.2;
m = 0.2;
M = 0.5;

theta = x(1);
omega = x(2);
postion = x(3);
velocity = x(4);
%Fd = u;

theta_dt = omega; 
omega_dt = ((M+m)*g*sin(theta))/((M+m*sin(theta)^2)*l) - ((m*sin(theta)*cos(theta)*theta_dt)/(M+m*sin(theta)^2))*theta_dt;
%omega_dt =  (-m*omega^2*sin(theta)*cos(theta)/(M+m) - cos(theta)*Fd/l/(M+m) + g*sin(theta)/l) / (1- m*cos(theta)^2/(M+m));

postion_dt = velocity; 
velocity_dt = -(m*g*cos(theta)*sin(theta))/((M+m*sin(theta)^2)*l) + ((m*l*sin(theta)*theta_dt)/(M+m*sin(theta)^2))*theta_dt;
%velocity_dt  = -m*l*cos(theta)/(M+m) * omega_dt + m*l*omega^2*sin(theta)/(M+m) + Fd/(M+m);

x(1) = theta + theta_dt*Ts;
x(2) = omega + omega_dt*Ts;
x(3) = postion + postion_dt*Ts;
x(4) = velocity + velocity_dt*Ts;


% Using Euler discretization, next states
% can be calculated given the current
% states and input 
% x = x + [x(2); -9.81/0.5*sin(x(1)) + u]*dt;


end

