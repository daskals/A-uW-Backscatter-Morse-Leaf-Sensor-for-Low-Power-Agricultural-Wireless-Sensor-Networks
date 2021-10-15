%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Last Version: 31/1/2018
% Matlab Vesrion: R2017b (Academic Use) 
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
close all; 
clear all;

%LMT84 1.5-V, SC70/TO-92/TO-92S,
% Analog Temperature Sensor

Sensor1mV= 895;
Sensor2mV= 821;

%power con LMT84=5.1 uA at 1.8 V
%min voltage 1.4 V
%903 mV



%power con LMT85=5.3 uA at 1.8 V
%min voltage 1.4 V
%1368 mV


riza1= sqrt((-5.506)^2+4*0.00176*(870.6-Sensor1mV));
temp_out1= (5.506-riza1 )/(2*(-0.00176))+30

riza2= sqrt((-5.506)^2+4*0.00176*(870.6-Sensor2mV));
temp_out2= (5.506-riza2 )/(2*(-0.00176))+30

Diff1=temp_out1-temp_out2

%LMT85 1.8-V, SC70/TO-92/TO-92S,
%Analog Temperature Sensor

Sensorb1mV= 1373;
Sensorb2mV= 992;

rizab1= sqrt((-8.194)^2+4*0.00262*(1324-Sensorb1mV));
temp_outb1= (8.194 -rizab1 )/(2*(-0.00262))+30

rizab2= sqrt((-8.194)^2+4*0.00262*(1324-Sensorb2mV));
temp_outb2= (8.194 -rizab2 )/(2*(-0.00262))+30

Diff2=temp_outb1-temp_outb2;

