%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 15/3/2018
% Last Version: 31/1/2018
% Matlab Vesrion: R2017b (Academic Use) 
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; 
close all; 
clear all;

volts=[0 100 150 210 300 350 400 450 500 550 600 650 700]
current= [2.2  2 2  1.9 1.8 1.7 1.7 1.6 1.5 1.5  1.4  1.3  1.3]
freq=[33.3 28.9 26.4 23.6 20 17.6 15.3 12.4 10.1 7.8 5.1 2.9 0.4]

power=current*1.2;
yyaxis left
yyaxis right

figure1= figure;
axes1  = axes('Parent',figure1,'YGrid','on','XGrid','on','FontSize',18);
plot(freq,power,'LineWidth',1.5,'Color',[0 0 0]);
ylabel('Power Consumtion (uW)','FontSize',18);
yyaxis right
plot(freq,volts,'LineWidth',1.5);

set(axes1,'FontSize',18)
xlim(axes1,[0 33.3]);
ylabel('Control Voltate (mV)','FontSize',18);
xlabel('Frequency (kHz)','FontSize',18);


grid(axes1,'on');
%legend('500 bps','1000 bps','2000 bps','Location','NorthEast');
set(0, 'DefaultAxesFontName', 'Arial'); 
print(figure1,'-depsc', '-tiff', '-r300', 'freq_vs_power.eps');