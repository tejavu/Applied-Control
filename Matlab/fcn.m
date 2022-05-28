function [velocity,Busy,delta,Done] = fcn(NumberOfRevolutions,ResetPosition)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

velocity = 0; 
Busy = 0;
Done = 1;
PointZero = 157447;
delta = round(NumberOfRevolutions - PointZero);

if  delta < 0 && ResetPosition == 1
    
    %delta = (NumberOfRevolutions - PointZero);
    
    %while delta <0
        velocity = pi;
        Busy = 1;
        Done = 1;
        
    %end
elseif  delta > 0 && ResetPosition == 1
    
    %delta = (NumberOfRevolutions - PointZero);
    
    %while delta <0
        velocity = -pi;
        Busy = 1;
        Dne = 1;
        
    %end


    
end    
end



