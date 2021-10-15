%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [total_envelope, packets, index, Bit_errors, fixedpacketdata_len] = Receiver_ASK_FM0(r, packets, total_packet_length,chanParams)


Fs = chanParams.Fs;
Ts=chanParams.Ts;
newover = 10;
over = round(chanParams.Tsymbol/Ts);

Bit_errors=0;
%% Sigmal Prosesing  Variables
Resolution = 1;   % in Hz
N_F = Fs/Resolution;
F_axis = -Fs/2:Fs/N_F:Fs/2-Fs/N_F;

DEBUG_en1=0;
DEBUG_en2=0;

% Preamble in FM0 format with symbols (not bits).
preamble_symbols=[1 1 0 1 0 0 1 0 1 1 0 1 0 0 1 1 0 0 1 1];
preamble = 2*preamble_symbols-1;   %try (2*preamble_bits-1)=> same result 
preamble_neg=-1*preamble;

%% Orthogonal pulces for detection
%D1
D1_ups=zeros(1,newover*2);
D1_ups(1:newover)=1; 
D1_ups(newover+1:newover*2)=-1;
%D2
D2_ups=zeros(1,newover*2);
D2_ups(1:newover)=-1; 
D2_ups(newover+1:newover*2)=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Decoder  FM0 vectors
bits_FM0_2sd_wayB=[]; 
decision_bits_B=[];
final_packet=[];
index=1;

fixedpacketdata=[0 1 0  0 1 1 1 1 0 0 0 1 1];  % id + sensor_id + fixedata  
fixedpacketdata_len=length(fixedpacketdata);
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
           x = r.';  % receive signal
           packets = packets + 1;
           %fprintf('Packet Window=%d|\n',packets)
           
           %% Absolute operation removes the unknown CFO
            abstream=abs(x).^2;
           %% Matched filtering
            matcheds=ones(round(chanParams.Tsymbol/Ts),1); % the pulse of matched filter has duration Tsymbol
            dataconv=conv(abstream,matcheds);   %  aply the filter with convolution
      
           %% Signal Smoothing with  1-D median filtering
           %dataconv= medfilt1(dataconv); 

            %% Downsample same prosedure
            total_env_ds = dataconv(1:over/newover:end); %% by factor of 10 to reduce the computational complexity
            
            %% Time sync of downsample
            total_envelope = total_env_ds(newover+1:end-(newover+1)); % total_env_ds(newover+1:end-newover+1); 
            
            %% remove the DC offset
            total_envelope=total_envelope-mean(total_env_ds);
            
            %scale/normalize values in a vector to be between -1 and 1
            total_envelope = -1 + 2.*(total_envelope - min(total_envelope))./(max(total_envelope) - min(total_envelope));
            
           %% Print Plots
           if DEBUG_en1==1;
                time_axis= 0:Ts:Ts*length(abstream)-Ts;        %same as xaxis_m= (1: length(abstream))*Ts Captured signal time axis.
                     % fft
                     x_fft = fftshift(fft(x, N_F));
                     F_sensor_est_power=10*log10((abs(x_fft).^2)*Ts/50*1e3)-15; 
                 figure(3);
                  subplot(2, 1, 1);
                    plot(time_axis,abstream);
                    title('Absolute-squared', 'FontSize',14 )  
                    xlabel('Time (Sec)', 'FontSize',12, 'FontWeight','bold');
                    ylabel('Amplitude', 'FontSize',12, 'FontWeight','bold');
                    grid on;
                   subplot(2, 1, 2);
                    plot(F_axis/1000000, F_sensor_est_power);
                    title('Frequency Domain')  
                    xlabel('Frequency (MHz)');
                   drawnow;               
           end
           
            if DEBUG_en2==1;
                 figure(4);
                    subplot(2, 1, 1);
                    plot(dataconv);
                    title('Matched-filtered' ,'FontSize',14 )
                    xlabel('Time (Sec)', 'FontSize',12, 'FontWeight','bold');
                    ylabel('Amplitude', 'FontSize',12, 'FontWeight','bold');
                    grid on;
                    subplot(2, 1, 2);
                    plot(total_envelope);
                    title('DOWNSAMPLED DC Removal')
                    drawnow;                 
            end 
           
            %%  Position estimation of packet with  packet's energy synchronization
            
%             for k=1:1: length(total_envelope)-(total_packet_length*2*newover)+1
%                     energy_synq(k)=sum(abs(total_envelope(k : k+total_packet_length*2*newover-1)).^2);          
%             end
%             % find the starting point of packet
%             [returnthress  energy_sinq_ind]=max(energy_synq);
%             
%            if returnthress < chanParams.Thressreceiver  
%                index=-1;
%                disp '-----Drop packet (NOISE)------';
%              return ;
%            end 

 
             %% Assume symbol synchronization, which can be implemented using correlation with a sequence of known bits in the preamble       
             % comparison of the detected preamble bits with the a priori known bit sequence
             %convert the header to a time series for the specific sampling frequency and bit duration. 
            
            %% create the preamble neover format
            preample_neover=upsample(preamble, newover);
            preample_neg_neover=upsample(preamble_neg, newover);
            
            %% Sync via preamble correlation
            corrsync_out = xcorr(preample_neover, total_envelope);
            corrsync_out_neg = xcorr(preample_neg_neover, total_envelope);
            
            [m ind] = max(corrsync_out);
            [m_neg ind_neg] = max(corrsync_out_neg);
             %notice that correlation produces a 1x(2L-1) vector, so index must be shifted.
             %the following operation points to the "start" of the packet.

            
            if (m < m_neg)
               start = length(total_envelope)-ind_neg;
            else
               start = length(total_envelope)-ind;
            end
            
             if(start <= 0)
                index=1;
                %disp 'Negative start';
                 return ;
            elseif start+((total_packet_length)*2)*newover > length(total_envelope)  %% Check if the detected packet is cut in the middle.
                index=2;
                %disp 'Packet cut in the middle!';
                 return ;
             end 
             
              shifted_sync_signal_B=total_envelope(start+length(preample_neover)-newover-1: start+total_packet_length*2*newover);
                  for xi=1:newover*2: length(shifted_sync_signal_B)-newover*2
                   
                        sample2=shifted_sync_signal_B(xi: xi+newover*2-1);
                        
                        sumD1_ups=sum(D1_ups.*sample2');
                        sumD2_ups=sum(D2_ups.*sample2');
                         if (sumD1_ups > sumD2_ups)
                            bits_FM0_2sd_wayB=[bits_FM0_2sd_wayB, 1];    
                         else
                            bits_FM0_2sd_wayB=[bits_FM0_2sd_wayB, 0];  
                        end  
                    end
                   
              jim=1;
            for indx=2:1:length(bits_FM0_2sd_wayB)
               if bits_FM0_2sd_wayB(indx) == bits_FM0_2sd_wayB(indx-1)
                     decision_bits_B(jim)=0;
               else
                     decision_bits_B(jim)=1;
                end
                   jim=jim+1;
                
            end
            
%             id_est_B = decision_bits_B(1: id_length);
%             sensor_id_est_B = decision_bits_B(id_length + 1: id_length + util_length);
%             data_bits_es_B = decision_bits_B(id_length+util_length + 1:end);
            
            if chanParams.HammingCode==1  
              [final_packet] = HAmmingDecoded18bits(decision_bits_B);
            else
                final_packet=decision_bits_B;
            end

                if  isequal(final_packet, fixedpacketdata)
                       %disp 'Packet Correct !!!!!!!!!!!!!!!!!!!!!!!!!';
                       index=3;        
                else
                    %decision_bits_B
                    %final_packet
                    %fixedpacketdata
                      %disp 'Packet WRONGGGG------------------------';
                      index=4;   
                      Bit_errors = sum(xor(final_packet,fixedpacketdata));
                end  
end

