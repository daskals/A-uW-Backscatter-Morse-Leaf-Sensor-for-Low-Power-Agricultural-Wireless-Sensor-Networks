close all;
clear all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spiros Daskalakis
%20-11-2016
%Morse signal translation
%Single: only for one sensor (not WSN)
%Data is captured from RTL
%offline: use a fixed dataset
%compatible with windows-linux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GAIN=10;
F_ADC = 250e3;          %Samping Rate 
DEC = 1;                
Fs = F_ADC/DEC;
Ts = 1/Fs;

Resolution = 1.1;        % in Hz 
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;

%Tag Subcarrier Center Freq
SUB_CENTER = [33000]
%Tag Subcarrier Bandwith
%Usefull for bandpass filter
SUB_BW = 0.5e3;

% Design and apply the bandpass filter

%Morse Code Parameters
speed=104.3;
dit = 1.2 / speed;
dit_samples = Fs*dit;
over = round(dit/Ts);
newover = 10;

%Filter Parameters 
order    = 2;
LEFT = SUB_CENTER - SUB_BW;
RIGHT = SUB_CENTER + SUB_BW;


%%%%%%%%%%%%%%%%%%%%%%%____SAMPLING PARAMETERS____%%%%%%%%%%%%%%%%%%
%%
t_sampling = 1.1;                    % seconds   //window time 
%t_sampling = 4*total_packet_length*10^(-3);     % Sampling time frame (seconds).
N_samples = round(Fs*t_sampling);

t = 0:Ts:t_sampling-Ts;

packets = 0;
counter = 0;
cfo_counter=0;
HIST_SIZE = 50;
F_sense_hist = zeros(HIST_SIZE,1);
%%%%%%%%%%%____LOAD DATA____%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
dataset1=load('data3_50pack_0_5BW_104_3WPM_1_1_ts.mat');
matrix=dataset1.data;
matrixinv=matrix';
%ta vazo olla se mia grammh
stream=matrixinv(:)';
stream = stream - mean(stream);  % remove DC component
%%%%%%%%%%%%%%%%____Control the algorithm____%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
pos=1;

FFTfig=0;
TimeFig=0;
FiltFig=1;

while packets<14
        x=stream(pos:pos+N_samples-1)';
        % an  4 ta epexergazomai meta alla 4 
       
           packets = packets + 1
           if(~mod(cfo_counter, 5))   % every 4 samples it makes  CFO correction and estimation 
            % fft
            x_fft = fftshift(fft(x, N_F));
            % cfo estimate
            [mval mpos] = max(abs(x_fft).^2);
            DF_est = F_axis(mpos);
           end
            
            % cfo correction
            x_corr = x.*exp(-j*2*pi*DF_est*t).';
            %x_corr = x_corr - mean(x_corr);
            
            if FFTfig==1
                    x_corr_fft = fftshift(fft(x_corr, N_F));
                    F_power_x1=(10*log10((abs(x_corr_fft).^2)*Ts))-GAIN;
                    figure(1);
                    plot(F_axis, F_power_x1);
                    grid on;
                    axis tight;
                    xlabel('Frequency (Hz)');
                    ylabel('Power');
                    drawnow; 
                    
            end
            cfo_counter = cfo_counter + 1;
       
              
                    abstream=abs(x_corr);
                    if TimeFig==1
                        
                    xaxis_m= (1: length(abstream))*Ts;   
                    figure(2)
                    plot(xaxis_m,abstream);
                    title('Initial Signal (Morse Freq+868 MHz Carrier)');
                    grid on;
                    xlabel('Time (Sec)');
                    ylabel('Amplitude');
                    drawnow;
                    end
                    
                  
                    %% Signal Prossesing 
                  
                    
                    %Higher orders will give  better off-frequency rejection at the 
                    %expense of a longer impulse response and a little more computation expense            
                    [b,a]    = butter(order,[LEFT,RIGHT]/(Fs/2), 'bandpass');
                    %gia na prosomeioso thorivo vazo 121.. kai kano active to parakato
                    %[b, a] = butterTwoBp(1/Fs, LEFT, RIGHT ) ;
                    %x        = filter(b,a,abstream);
                    x = filtfilt(b,a,abstream);
                    % EnaergyPacket=sum(x.^2)*Ts

                    %x_f = mfilter(x,17,Fs,13180);



   
   
                % half-wave rectify x
                x2 = abs(x);

                % slow-wave filter 

            flt = dit_samples;
            %y = filter(ones(1,flt)/flt,1, x2);
            

  matcheds=ones(round(dit_samples),1);
  y=conv(matcheds,x2);
  convaxis= (1:length(y))*Ts; 

  %agc1 = comm.AGC;
%rxSig = agc1(y)

agc = max(y);
threshold = agc/3;

%downsample
y = y(1:over/newover:end);


% threshold (digitize) y
digit_Morse = (y > threshold);

% z is now effectively our morse signal
axis_x= (1: length(x))*Ts; 


%figure3= figure;
%axes1 = axes('Parent',figure3,'YGrid','on','XGrid','on','FontSize',18);   
  if FiltFig==1;
   figure(3);
   subplot(3,1,1);
   plot(axis_x,x);
   grid on;
   title('BandPass Filter');
   xlabel('Time (Sec)');
   ylabel('Amplitude');
   subplot(3,1,2);
   plot(y);
   grid on;
   title('Matched Filter');
   xlabel('Time (Sec)');
   ylabel('Amplitude');
   subplot(3,1,3);
   plot(digit_Morse);
   drawnow
   title('Digitized Morse Signal');
   grid on;
   xlabel('Time (Sec)');
   ylabel('Amplitude');
  end           
            
            MorseDemodulator_v2(digit_Morse);
                                
        pos=pos+N_samples; 
        
    
end    
                    
       

