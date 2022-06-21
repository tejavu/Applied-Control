clc
g = 9.81;
l= 0.2;
m = 0.2;
M = 0.5;

A = [0              1           0           0;
     ((M+m)*g)/(M*l)    0           0           0;
     0              0           0           1;
     -(m*g)/M         0           0           0];


B = [0;
     -1/(l*M);
     0;
     1/M];

C = [1 0 0 0;
     0 0 1 0;
     0 0 0 1];

D = [0;
     0;
     0];

Ob = obsv(A,C);

% Number of unobservable states
unob = length(A)-rank(Ob);

Co = ctrb(A,B);

% Number of controllable states
unco = length(A) - rank(Co);

sys = ss(A,B,C,D);

InitState = [0 0 0 0];

% Sampling time
Ts = 0.001; % [s]

%% 
disp('initPemdelumControl3x4 done!')