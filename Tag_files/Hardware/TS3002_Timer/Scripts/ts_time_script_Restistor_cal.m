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
R1=6.2*10^6;
Rset=6.2*10^6;

Rtot=(Rset*R1)/(Rset+R1);
Foutmax=1/(1.19*Rtot*Cset)

Vcond=0.1;
Vcondmax=1.1;
Vset=Vcond*Rtot;
FoutkHz=Foutmax/1000;

Fout_vcond=(-Foutmax/Vcondmax)*Vcond+Foutmax;
Fout_vcond=Fout_vcond/1000;


%%
Fsel_max=100000;
Cset=7.9*10^-12;
fact1=1.19;
a=1/(Fsel_max*fact1*Cset)

Vlim=0.300;
VDAQmax=1.2;
b=Vlim/VDAQmax;
s=b/(1-b)

syms  R1
eqn = s*R1^2 - (1+s)*a*R1== 0;
sola = solve(eqn, R1)

R1_val=sola(2)
R2_val=s*R1_val
%


