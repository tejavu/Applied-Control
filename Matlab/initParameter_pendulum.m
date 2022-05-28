% clear all

addpath('Lib')

%% Position
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
increments2rad_AM8113_0F21=2*pi/2^20; %rad/1 transformation of a 20 bit signal per revolution to a radiant value

%% Velocity
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
increments2radPerS_AM8113_0F21=2*pi/268435; %[rad/s]

vmax_AM8113_0F21 = 90*pi; %[rad/sec] Maximal speed 
vmin_AM8113_0F21 = -90*pi; %[rad/sec] Minimal speed

%% Torque
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
torqueConstant_AM8113_0F21 = 0.12; %[Nm/A]
ratedCurrent_AM8113_0F21 = 4.16; %[A] Nennstrom = rated current
output2Torque_AM8113_0F21 = ((1/1000)*(ratedCurrent_AM8113_0F21/sqrt(2)))*torqueConstant_AM8113_0F21; %[Nm/inc]

taumax_AM8113_0F21=1;
taumin_AM8113_0F21=-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% These values were used to run a simulation %%%%%%%%%%%%%%%%
m = 0.2;         %pendulum's mass kg                                 
M = 0.5;           %wagen's mass kg                                  
g = 9.8065;         %gravitational acceleration m/s^2                
l = 0.5;           %pendulum's length m                              
b = 1;              % spring damping factor                          
threshold = 0;                                                              
k = 0.8;            %spring stiffness
d = 0.3; %m
U_Bottom = 0.14; % bottom cart velocity during swing up m/s
U_Top = 0.14; % Top velocity during swing up m/s
k1 = 4;

E_Inverted = 2*m*g*l; % Energy required to swing up the pendulum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      Bottom setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PointZero_Bottom = 2476; % Point zero for the bottom cart (far left) taken from the position increments value (in rad)  found in counts2SI block
x_11 = PointZero_Bottom - 1.5*pi; % safety limit for the bottom cart left extrimety
x_12 = PointZero_Bottom - (20*2*pi) + (4*2*pi); % safety limit right extrimety
Reset_Position_Bottom = PointZero_Bottom - 10*pi; % Location of the cart when reset position is pressed
Ref_Bottom = 0.25; % reference position of the bottom cart (m) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      Top setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PointZero_Top = (19584 - 6*pi);% Point zero for the bottom cart taken from the position increments value (in rad)  found in counts2SI block
x_21 =PointZero_Top + (3*2*pi);% safety limit left extrimety as shown in figure 35
x_22 =PointZero_Top + (20*2*pi);% safety limit right extrimety as shown in figure 35
Reset_Position_Top = PointZero_Top + 14*2*pi; % Location of the cart when reset position is pressed (70cm = 0.8*M*pi)
Ref_Top = 0.75; %  reference poition of the top cart (m) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = 15*pi; 
gearRatio_Motor1=1/1;
SupplyVoltage_Bottom = 5; % supply voltage for the bottom setup potentiometer  
SupplyVoltage_Top = 5; %supply voltage for the top setup potentiometer 
Counts2Voltage = (SupplyVoltage_Bottom/(32767*0.5)); % conversion from counts to voltage 
Counts2Voltage_top = (SupplyVoltage_Top/(32767*0.5)); % conversion from counts to voltage 
Voltage2Counts = (32766/10); %unit conversion from voltage to counts
Voltage2Angle = SupplyVoltage_Bottom/(2*pi);  %unit conversion from voltage to angle 
Voltage2Angle_top = 4.3/(2*pi);  %unit conversion from voltage to angle 
Angular2Linear = (0.054/(2*pi));  %unit conversion rad to meter

SwitchAngle = 2.9; %switch between swing up and the controller
delta_x_1 = ((10*2^20)*increments2rad_AM8113_0F21)*(180/pi);
Velocity_Limit = 80*pi;
Safe_Distance = 0.2; % minimum distance allowed between the two carts in meters
