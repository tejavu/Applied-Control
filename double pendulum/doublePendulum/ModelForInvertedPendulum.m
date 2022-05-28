%% model for inverted pendulum

% x_vect = [ x; x_dot; theta; theta_dot] 
% u = Force on the cart in x direction (control input)

% Fixed points we want 
% theta = 0 (down), 180 (up), theta_dot = 0, x_dot = 0, x -- free value 

% non linear ODE function -- gives time derivative given the state
% x -> state, m -> mass of pendulum, M -> mass of cart,
% L -> length of pendulum, g -> gravity, d -> damping (on the cart)
% u -> force

function dx = pendcart(x,m,M,L,g,d,u)
Sx = sin(x(3));
Cx = cos(x(3));
D = m*L*L*(M+m*(1-Cx^2));
dx(1,1) = x(2);
dx(2,1) = (1/D)*(-m^2*L^2*g*Cx*Sx + m*L^2*(m*L*x(4)^2*Sx - d*x(2))) + m*L*L*(1/D)*u;
dx(3,1) = x(4);
dx(4,1) = (1/D)*((m+M)*m*g*L*Sx - m*L*Cx*(m*L*x(4)^2*Sx - d* x(2))) - m*L*Cx*(1/D)*u;
%% compute the state equations
m = 1; M = 5; L = 2; g = -10; d = 1;
b = 1; % Pendulum up (b=1)
A = [0 1 0 0;
0 -d/M b*m*g/M 0;
0 0 0 1;
0 -b*d/(M*L) -b*(m+M)*g/(M*L) 0];
B = [0; 1/M; 0; b*1/(M*L)]
lambda = eig(A);
rank(ctrb(A,B));
%% Desired setting of eigen values 
% can only be done when system is controllable 
eigs = [-1.2,-1.4,-1.6,-1.8]
K = place(A,B,eigs) % k is proportional feedback controller 
% k shapes the closed loop eigen values to the values specified

eig(A-B*K) % for verifying that it has the eigen values specified

%% Design LQR controller controller to stabilize inverted pendulum on a cart.
Q = eye(4); % 4x4 identify matrix
R = .0001;
K = lqr(A,B,Q,R)








