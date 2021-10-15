%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Last Version: 23/1/2018
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [r] = modulation_signal(x_tag, x_F,chanParams, t)

        % random reflection coefficients
        %% antipodal reflection coefficients
        
        G0 = 0.5*exp(j*unifrnd(0, 2*pi));
        G1 = 0.5*exp(j*angle(G0) + j*pi);

        %% preset reflection coefficients
         %G0 = 0.95*exp(j*pi/3);
         %G1 = 0.7*exp(j*pi/3 + j*pi + j*pi/10);

        x_tag_complex = x_tag;
        indx = find(x_tag_complex==1);
        x_tag_complex(1:end) = G0 ;
        x_tag_complex(indx) = G1 ;

  A = sqrt(chanParams.P_TX)*exp(j*unifrnd(0, 2*pi));   % carrier received at SDR
  B = 0.1*exp(j*unifrnd(0, 2*pi));          % modulated signal scaling
 
  %L_padding = 20000;
  %% Random L_padding
  L_padding= randi([0 (length(x_F)-length(x_tag_complex))], 1,1);
  x_mul=[G0*ones(1, L_padding) x_tag_complex  G0*ones(1, length(x_F)-length(x_tag_complex)-L_padding)];
  r = A*x_F + A*B*x_F.*x_mul;    % full signal
  
  r = awgn(r,chanParams.noiseSNR);
  
  %% Add a small flactuation in our final modulated signal
  F_sin_flactuation = 0.005*rand(1);              % rate of sine
  flactuation = cos(2*pi*F_sin_flactuation*t);     % baseband sine
  r=r.*flactuation;

end

