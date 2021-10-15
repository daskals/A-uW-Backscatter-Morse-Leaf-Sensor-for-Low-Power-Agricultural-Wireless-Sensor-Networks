function [x_FM] = F_carrier_channel(total_max_packet_duration, chanParams)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Last Version: 23/1/2018
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation code, Rev. 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_sampling = chanParams.framelength*total_max_packet_duration;    % Sampling time frame (seconds).
t = 0:chanParams.Ts:t_sampling-chanParams.Ts;

% carrier
  for tt=1:length(t)
     x_FM(tt) = cos(2*pi*(chanParams.f_c+chanParams.CFO)*t(tt));
  end

end




