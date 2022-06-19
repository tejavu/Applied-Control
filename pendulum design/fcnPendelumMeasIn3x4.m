

function y = myPendelumMeasurementFcn_3out(x)
% x1: Angular position (theta) 
% x3: Cart position (position) 
% x4: Cart velocity (velocity) 
y = [x(1); x(3); x(4)]; 
end