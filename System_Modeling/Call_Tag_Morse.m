%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spiros Daskalakis 
% 26/12/2017
% Last Version: 23/1/2018
% Email: daskalakispiros@gmail.com
% Website: www.daskalakispiros.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 %The tag has two sensos connected wih a ADC 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
function [morsecode]  = Call_Tag_Morse(chanParams)
% Fixed Data
ADC1= randi([0 1023],1, 1);
ADC2= randi([0 1023],1, 1);
%ADC1=1023;
%ADC2=1023;
text= [int2str(ADC1) 'E' int2str(ADC2)];

f_code=chanParams.F_Symbol;
Fs=chanParams.Fs;
code_speed=chanParams.MorseCodespeed;


t=0:1/Fs:1.2/code_speed; %One dit of time at w wpm is 1.2/w.
t=t';
Dit=square(2*pi*f_code*t, 50);
ssp = zeros(size(Dit));
% one Dah of time is 3 times  dit time
Dah = [Dit;Dit;Dit];
lsp = zeros(size([Dit;Dit;Dit]));

% Defining Characters & Numbers
A = [Dit;ssp;Dah];
B = [Dah;ssp;Dit;ssp;Dit;ssp;Dit];
C = [Dah;ssp;Dit;ssp;Dah;ssp;Dit];
D = [Dah;ssp;Dit;ssp;Dit];
E = [Dit];
F = [Dit;ssp;Dit;ssp;Dah;ssp;Dit];
G = [Dah;ssp;Dah;ssp;Dit];
H = [Dit;ssp;Dit;ssp;Dit;ssp;Dit];
I = [Dit;ssp;Dit];
J = [Dit;ssp;Dah;ssp;Dah;ssp;Dah];
K = [Dah;ssp;Dit;ssp;Dah];
L = [Dit;ssp;Dah;ssp;Dit;ssp;Dit];
M = [Dah;ssp;Dah];
N = [Dah;ssp;Dit];
O = [Dah;ssp;Dah;ssp;Dah];
P = [Dit;ssp;Dah;ssp;Dah;ssp;Dit];
Q = [Dah;ssp;Dah;ssp;Dit;ssp;Dah];
R = [Dit;ssp;Dah;ssp;Dit];
S = [Dit;ssp;Dit;ssp;Dit];
T = [Dah];
U = [Dit;ssp;Dit;ssp;Dah];
V = [Dit;ssp;Dit;ssp;Dit;ssp;Dah];
W = [Dit;ssp;Dah;ssp;Dah];
X = [Dah;ssp;Dit;ssp;Dit;ssp;Dah];
Y = [Dah;ssp;Dit;ssp;Dah;ssp;Dah];
Z = [Dah;ssp;Dah;ssp;Dit;ssp;Dit];
period = [Dit;ssp;Dah;ssp;Dit;ssp;Dah;ssp;Dit;ssp;Dah];
comma = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
question = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
slash_ = [Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dit];
n1 = [Dit;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];
n2 = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dah];
n3 = [Dit;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
n4 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dah];
n5 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
n6 = [Dah;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
n7 = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dit];
n8 = [Dah;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
n9 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dit];
n0 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];
text = upper(text); % convert text to uppercase
vars ={'period','comma','question','slash_'};
morsecode=[];

for i=1:length(text)
    if isvarname(text(i))
        morsecode = [morsecode;eval(text(i))];
       
    elseif ismember(text(i),'.,?/')
        x = findstr(text(i),'.,?/');
        morsecode = [morsecode;eval(vars{x})];
    elseif ~isempty(str2num(text(i)))
        morsecode = [morsecode;eval(['n' text(i)])];
    elseif text(i)==' '
        morsecode = [morsecode;ssp;ssp;ssp;ssp];
    end
    morsecode = [morsecode;lsp];
end

end
