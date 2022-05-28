%% This is the main Init file. It should run all files necesary for obtaining parameters and defining buses.

clear all;
close all;
clc;

addpath('Library');
addpath('Library/Init');
%addpath('Library/Kinematics');
%addpath('Library/postProcessing');
addpath('Library/Cad');
addpath('Library/Safety');
addpath('Library/StateMachine');
addpath('Library/Controller');


%Load initial data
initDoublePendulumParameters;
