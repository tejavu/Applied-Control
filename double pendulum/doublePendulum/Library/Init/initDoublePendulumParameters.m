completeAssembly_DataFile;
pendulumMass = 1;
cartMass = 0.5;

initFeedback.cartPos = [0.75;0.25];
initFeedback.cartVel = [0;0];
initFeedback.pendPos = [0;0];

cartPosLimits = [0.2, 0.8];

%% Beckhoff parameters

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

taumax_AM8111_1F21=0.03;
taumin_AM8111_1F21=-0.03;

%%Gear
gearRatio_Motor1=1/1;

%% Initialize the state machine parameters
initStateMachine;
