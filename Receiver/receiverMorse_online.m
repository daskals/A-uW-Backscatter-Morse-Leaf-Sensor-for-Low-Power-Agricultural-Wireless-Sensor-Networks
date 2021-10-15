%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spiros Daskalakis
%20-11-2016
%Daskalakispiros@gmail.com
%wwww.daskalakispiros.com
%Morse signal translation
%Single: only for one sensor (not WSN)
%Data is captured from RTL
%compatible with windows-linux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GAIN=-10;
Fs = 250e3;            %Same as gnuradio
Ts = 1/Fs;

Resolution = 1;        % in Hz
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;

%Subcarrier center Freq
SUB_CENTER = [33000]

SUB_BW = 0.5e3;
fi = fopen('spiros2', 'rb');
t_sampling = 1.1;                           % seconds
N_samples = round(Fs*t_sampling);
t = 0:Ts:t_sampling-Ts;
packets = 0;
HIST_SIZE = 50;

cfo_counter=1;
DF_est=0;

while(1)
    
    x = fread(fi, 2*N_samples, 'float32');% get samples (*2 for I-Q)
    x = x(1:2:end) + j*x(2:2:end);      % deinterleaving
        packets = packets + 1
        
           if(~mod(cfo_counter, 3))
            % fft
            x_fft = fftshift(fft(x, N_F));
            % cfo estimate
             [mval mpos] = max(abs(x_fft).^2);
             DF_est = F_axis(mpos);
           end
        
        % cfo correction
        x_corr = x.*exp(-j*2*pi*DF_est*t).';
        % corrected cfo
        x_corr_fft = fftshift(fft(x_corr, N_F));
        % sensor's fft
         
       F_power_x1=(10*log10((abs(x_corr_fft).^2)*Ts))+GAIN;
       cfo_counter = cfo_counter + 1;
       abstream=abs(x_corr);

        z  = signal_proc(Fs, SUB_CENTER,SUB_BW, abstream);
        MorseDemodulator_v2(z);
                         
        if(mod(packets,HIST_SIZE) ==0)
            return; 
        end        
    end    
   





