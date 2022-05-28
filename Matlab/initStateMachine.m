%% Initialize all parameters and Bus signals needed for the new StateMachine
%2019-09-02 Nicolas Gerig

Ts = 0.001;
nMotors = 2;

%% possible StateMachine States
SM_STATES.INIT = 0; %initialization and reset eventual faults and errors in drives, motors, and the error bus

SM_STATES.SENDING_TWINSAFE_ERROR_ACKNOWLEDGE = 1; %Looking at the current safety project, I believe this stage is not even needed and the TwinSAFE error Acknowledge is unused.
SM_STATES.RESETTING_MOTOR_DRIVES = 2; %reset errors on TwinSAFE devices step 2 of 2
SM_STATES.ENABLING_TWINSAFE_POWER_BEFORE_RESET = 3; %Enable TwinSAFE switch on power supplies through application enabling
SM_STATES.RESETTING_TWINSAFE_POWER_SWITCH = 4; %Reset TwinSAFE to switch on power supply for motors
SM_STATES.ENABLING_TWINSAFE_POWER_AFTER_RESET = 5;%Switch on disabled
SM_STATES.PREPARING_SWITCH_ON = 6; %preparing switch on when drives are in "Switch on disabled" 
SM_STATES.SWITCHING_ON = 7; %switching on after drives in "Ready to switch on"
SM_STATES.ENABLING_OPERATION = 8; %enabling operation after drives in "Switched on"

SM_STATES.OPERATION = 9; %operation enabled
SM_STATES.ERROR = 10; %Fehler_i

%% used motor control words EL72X1
% https://download.beckhoff.com/download/document/io/ethercat-terminals/el72x1-001xde.pdf
% 2021-06-03ng: These were previously directly as embedded functions within the state
% machine, but for the stateflow implementation are now considered "Parameter Inputs"

cmdEl72x1_STOP = bin2dec('0000 0000 0000 0000'); %EL72X1: all disabled + quick stop (inverse bit2)
cmdEl72x1_FAULT_RESET = bin2dec('0000 0000 1000 0000'); %EL72X1: fault_reset (bit7) + quick stop (inverse bit2)
cmdEl72x1_VOLTAGE_AND_RELEASE = bin2dec('0000 0000 0000 0110'); %EL72x1: enable voltage (bit1) + not quick stop (inverse bit2)
cmdEl72x1_SWITCH_ON = bin2dec('0000 0000 0000 0111'); %EL72x1: switch on (bit0) + enable voltage (bit1) + not quick stop (inverse bit2)
cmdEl72x1_ENABLE_OPERATION = bin2dec('0000 0000 0000 1111');%EL72x1: switch on (bit0) + enable voltage (bit1) + not quick stop (inverse bit2) + enable operation (bit3)

%% init state machine bus signals
% Bus object: StateConditionMotors 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bSwitchOnDisabled';
elems(1).Dimensions = nMotors;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'boolean';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bReadyToSwitchOn';
elems(2).Dimensions = nMotors;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'boolean';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bSwitchedOn';
elems(3).Dimensions = nMotors;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'boolean';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'bOperationEnabled';
elems(4).Dimensions = nMotors;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'boolean';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

StateConditionMotors = Simulink.Bus;
StateConditionMotors.HeaderFile = '';
StateConditionMotors.Description = '';
StateConditionMotors.DataScope = 'Auto';
StateConditionMotors.Alignment = -1;
StateConditionMotors.Elements = elems;
clear elems;
assignin('base','StateConditionMotors', StateConditionMotors);

% Bus object: StateConditionMotorsSummary 
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'bSwitchOnDisabled';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'boolean';
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Min = [];
elems(1).Max = [];
elems(1).DocUnits = '';
elems(1).Description = '';

elems(2) = Simulink.BusElement;
elems(2).Name = 'bReadyToSwitchOn';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'boolean';
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Min = [];
elems(2).Max = [];
elems(2).DocUnits = '';
elems(2).Description = '';

elems(3) = Simulink.BusElement;
elems(3).Name = 'bSwitchedOn';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'boolean';
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Min = [];
elems(3).Max = [];
elems(3).DocUnits = '';
elems(3).Description = '';

elems(4) = Simulink.BusElement;
elems(4).Name = 'bOperationEnabled';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'boolean';
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';
elems(4).Min = [];
elems(4).Max = [];
elems(4).DocUnits = '';
elems(4).Description = '';

StateConditionMotorsSummary = Simulink.Bus;
StateConditionMotorsSummary.HeaderFile = '';
StateConditionMotorsSummary.Description = '';
StateConditionMotorsSummary.DataScope = 'Auto';
StateConditionMotorsSummary.Alignment = -1;
StateConditionMotorsSummary.Elements = elems;
clear elems;
assignin('base','StateConditionMotorsSummary', StateConditionMotorsSummary);