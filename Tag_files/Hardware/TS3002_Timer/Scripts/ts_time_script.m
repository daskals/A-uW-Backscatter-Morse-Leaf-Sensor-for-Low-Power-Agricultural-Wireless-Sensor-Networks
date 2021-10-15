%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
close all; 
clear all;


Cset=7.9*10^-12;
R1=4*10^6;
Rset=4*10^6;

Rtot=(Rset*R1)/(Rset+R1)

Foutmax=1/(1.19*Rtot*Cset)
Vcond=0.200;
Vcondmax=1.2;
%Vset=Vcond*Rtot;
FoutkHz=Foutmax/1000


%Fswmax=294.9e3
Fout_vcond=(-Foutmax/Vcondmax)*Vcond+Foutmax
Fout_vcond=Fout_vcond/1000

% 
Vref=1.198;
DAC=Vref/2^5;
Spepsvoltages=[0:DAC:Vref]


power_con=2.1 %uA 