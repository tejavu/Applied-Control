clear all
%% Position
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
increments2rad_AM8111_1F21=2*pi/2^20; %rad/1 transformation of a 20 bit signal per revolution to a radiant value

%% Velocity
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
increments2radPerS_AM8111_1F21=2*pi/268435; %[rad/s]

vmax_AM8111_1F21 = 2*pi; %[rad/sec] Maximal speed 
vmin_AM8111_1F21 = -2*pi; %[rad/sec] Minimal speed

%% Torque
%documentation see:  https://infosys.beckhoff.com/index.php?content=../content/1031/el72x1/1976980619.html&id=
torqueConstant_AM8111_1F21 = 0.07; %[Nm/A]
ratedCurrent_AM8111_1F21 = 2.71; %[A] Nennstrom = rated current
output2Torque_AM8111_1F21 = ((1/1000)*(ratedCurrent_AM8111_1F21/sqrt(2)))*torqueConstant_AM8111_1F21; %[Nm/inc]

taumax_AM8111_1F21=0.065;
taumin_AM8111_1F21=-0.065;

%%Gear
gearRatio_Motor1=1/1;

%Plate tilt direction 
plateTiltDirection = -1; % if the plate rotates in the same direction as the motor


%% Initialize the state machine parameters
initStateMachine;

%%
initParameter_pendulum;