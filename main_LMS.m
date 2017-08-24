




%% Load data
path = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/Training_data/';
load([path,'DATA_01_TYPE01.mat']);

ecg  = sig(1,:);
ppg1_raw = sig(2,:); 
ppg2_raw = sig(3,:); 
accX = sig(4,:); 
accY = sig(5,:); 
accZ = sig(6,:);  

%% Preprocess

% A low pass filter is Used at 50Hz in PPG signals
N   = 120;
Fs  = 125;
Fp  = 40;
Ap  = 0.01;
Ast = 80;

% Design a FIR low pass filter
LP_FIR = dsp.LowpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);


ppg1 = step(LP_FIR,ppg1_raw);
ppg2 = step(LP_FIR,ppg2_raw);

%% LMS

order = 10;
mu = 0.008;            % LMS step size.
lms = adaptfilt.lms(order,mu);
[y,e] = filter(lms,accX,ppg1);

%% RLS

rls = adaptfilt.rls(order,1);
[y2,e] = filter(rls,accX,ppg1);


% 
% subplot(4,1,1)
% plot(ppg1)
% title('Input signal')
% subplot(4,1,2)
% plot(accX)
% title('Observed Noise')
% subplot(4,1,3)
% plot(y)
% title('LMS Filter output')
% subplot(4,1,4)
% plot(y2)
% title('RLS Filter output')


subplot(3,1,1)
plot(ppg1_raw(1:2000))
title('PPG 1');
subplot(3,1,2)
plot(ppg2_raw(1:2000))
title('PPG 2');
subplot(3,1,3)
plot(ecg(1:2000))
title('ECG');


%fvtool(LP_FIR,'Fs',Fs);
%measure(LP_FIR)

% %Spectrum plot
% T = 1/Fs;             % Sampling period       
% L = length(ppg1);    % Length of signal
% t = (0:L-1)*T;        % Time vector
% 
% Y =fft(ppg1)./numel(ppg1);;
% 
% P2 = abs(Y(2:end)/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L/2))/L;
% plot((f),P1) 
% grid on
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

