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

% Main Program
% FM Emitter parameters
   chanParams.f_c = 868e6;                     % carrier (baseband = 0)
   chanParams.CFO = 0; %randi([0 2e3],1, 1);                     % frequency offset
   
% Reader Parameters
    chanParams.Fs = 1e6;
    chanParams.Ts=1/chanParams.Fs;
    chanParams.framelength=3;
    
% Morse Code Parameters
    chanParams.MorseCodespeed=104.3;   %20 WPM  One dit of time at w wpm is 1.2/w.
    chanParams.F_Symbol =60e3; 
 %% Noise Param
   chanParams.noiseSNR=30;
   chanParams.P_TX = 3; 
   
%% Modulation Selection Param
   chanParams.Modtype=0; % 0 for 2PAM ----1 for 4 PAM
   
%% Initiallization
 %Plots
   plot1=0;
   plot2=1;
 % packets status indicator  
   drop_packets=0;
   correct_packets=0;
   error_packets=0;
   negative_starts=0;
   cut_packets=0;
 % other   
   Bit_errors_sum=0;
   packets=0;
   fixedpacketdata_len=0;
 %% PacketsSimulation
    N=100;   
    
%% Call Taf


for (steps=1:1:N)
    morsecode = Call_Tag_Morse(chanParams)';
    
    %total_max_packet_duration=chanParams.Ts*length(morsecode)-chanParams.Ts 
    total_max_packet_duration=1.8726; % for 100 WPM 
    
    
    time_axis= 0:chanParams.Ts:total_max_packet_duration;
    
     t_sampling = chanParams.framelength*total_max_packet_duration;     % Sampling time frame (seconds).
     t = 0:chanParams.Ts:t_sampling-chanParams.Ts;
    
    steps
     if plot1==1
      figure(1);
      plot(t_sampling, morsecode)
      title('Wavefor for RF transistor')
      xlabel('Time (sec)');
      ylabel('Amplitude (a.u)');
      drawnow;
       end
    
    
    [x_F] = F_carrier_channel(total_max_packet_duration, chanParams);
    
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Channel and Modulation Part
      [r]=modulation_signal(morsecode, x_F, chanParams, t);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
      time_axis= 0:chanParams.Ts:chanParams.Ts*length(r)-chanParams.Ts;
     if plot2==1
     figure(2);
      plot(time_axis,abs(r))
     title('FM Modulated signal')
     xlabel('Time (sec)');
     ylabel('Amplitude (a.u)');
     drawnow;
     end
      
     
     %[total_envelope, packets, index, Bit_errors, fixedpacketdata_len] = Receiver_Demorse(r,packets, total_packet_length, chanParams);
      
    
end   
    