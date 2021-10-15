function [digit_Morse ] = signal_proc(Fs, SUB_CENTER,SUB_BW, abstream)
Ts = 1/Fs;
% Design and apply the bandpass filter

speed=104.3;
dit = 1.2 / speed;
dit_samples = Fs*dit;

over = round(dit/Ts);
newover = 10;


order    = 2;
LEFT = SUB_CENTER - SUB_BW;
RIGHT = SUB_CENTER + SUB_BW;
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

   figure(3);
   subplot(3,1,1);
   plot(axis_x,x, 'LineWidth',1,'Color',[0 0 0]);
   grid on;
   title('BandPass Filter');
   xlabel('Time (Sec)', 'FontSize',18);
   ylabel('Amplitude', 'FontSize',18);
   subplot(3,1,2);
   plot(y, 'LineWidth',1,'Color',[0 0 0]);
   grid on;
   title('Matched Filter');
   xlabel('Time (Sec)', 'FontSize',18);
   ylabel('Amplitude', 'FontSize',18);
   subplot(3,1,3);
   plot(digit_Morse, 'LineWidth',1,'Color',[0 0 0]);
   drawnow
   title('Digitized Morse Signal');
   grid on;
   xlabel('Time (Sec)', 'FontSize',18);
   ylabel('Amplitude', 'FontSize',18);


end

