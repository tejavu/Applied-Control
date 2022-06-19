clc
g = 9.81;
l= 0.2;
m = 0.2;
M = 0.5;

J = m*l^2;

Tsim = 2;
% a12 = g*(m/M+1)/l;
% a14 = -m*g/M;
% b12 = -1/(l*M);
% b14 = 1/M;


% A = [0              1           0           0
%      -g*(m/M+1)/l    0           0           0
%      0              0           0           1
%      -m*g/M         0           0           0];
% 
% 
% B = [0
%      +1/(l*M)
%      0
%      1/M];
% 
% C = [1 0 0 0
%      0 0 1 0
%      0 0 0 1];
% 
% D = [0
%      0
%      0];

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

a = ((M+m)*g)/(M*l);
b = -1/(l*M);
Ma = M*a;

sys_as_tf = tf(sys);

InitState = [0 0 0 0];


% Process noise covariance
Q = 1e1;
Q_matrix = diag([Q,Q,Q,Q]);

% Measurement noise covariance
R = 1e-7;
R_Matrix = diag([R]);

% Sampling time
Ts = 0.001; % [s]

% %Euler Forward
I = eye(size(A));
Ad = A*Ts+I;
Bd = B*Ts;
Cd = C;
Dd = D;

% Dicretizaiton
% sysc = ss(A,B,C,D);
% sysd = c2d(sysc,Ts,'zoh');
% [Ad,Bd,Cd,Dd,Tsd] = ssdata(sysd)

%%
% % LQR Controller
% states = {'phi' 'phi_dot' 'x' 'x_dot' };
% inputs = {'u'};
% outputs = {'phi'; 'x'; 'x_dot'};
% 
% sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);
% sys_d = c2d(sys_ss,Ts,'zoh');
% [Ad,Bd,Cd,Dd,Tsd] = ssdata(sys_d);
% 
% Q_lqr = C'*C;
% Q_lqr(1,1) = 100;
% Q_lqr(3,3) = 5000;
% R_lqr = 1;
% [L] = dlqr(Ad,Bd,Q_lqr,R_lqr);
% 
% Ac = [(Ad-Bd*L)];
% Bc = [Bd];
% Cc = [Cd];
% Dc = [Dd];
% 
% states = {'x' 'x_dot' 'phi' 'phi_dot'};
% inputs = {'r'};
% outputs = {'phi'; 'x'; 'x_dot'};
% 
% Kr = -70;
% sys_cl = ss(Ac,Bc*Kr,Cc,Dc,Ts,'statename',states,'inputname',inputs,'outputname',outputs);

%% %Plot
% t = 0:Ts:5;
% r =0.2*ones(size(t));
% [y,t,x]=lsim(sys_cl,r,t);
% [AX,H1,H2] = plotyy(t,y(:,2),t,y(:,1),'plot');
% set(get(AX(1),'Ylabel'),'String','cart position (m)')
% set(get(AX(2),'Ylabel'),'String','pendulum angle (radians)')
% title('Step Response with Digital LQR Control')
%% 
disp('initPemdelumControl3x4 done!')