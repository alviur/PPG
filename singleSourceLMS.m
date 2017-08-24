%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Compute Least mean square
% -------------------------------------------------------------------------
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all

figuresPath = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/6_Results/Single_source/';
file = 'LMS_ind_4_w_Stair_up_down';
load(['ind_4_Stair_up_down','.mat'])
activitiy = 'Stair_up_down';
%% Preprocess

% A low pass filter is Used at 50Hz in PPG signals
N   = 120;
Fs  = 50;
Fp  = 5;
Ap  = 0.01;
Ast = 80;

% Design a FIR low pass filter
LP_FIR = dsp.LowpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);


ppg1 = step(LP_FIR,sig(1,:));
ppg2 = step(LP_FIR,sig(2,:));
accX1 = step(LP_FIR,sig(3,:));
accX2 = step(LP_FIR,sig(6,:));
accY1 = step(LP_FIR,sig(4,:));
accY2 = step(LP_FIR,sig(7,:));
accZ1 = step(LP_FIR,sig(5,:));
accZ2 = step(LP_FIR,sig(8,:));

%% LMS

order = 25;
mu = 0.008;            % LMS step size.
lms = adaptfilt.lms(order,mu);

%pARA SUJETO 3 INVERTIDOS
[yPPG1,e] = filter(lms,accZ1,ppg1);
[yPPG2,e] = filter(lms,accZ2,ppg2);



%% Performance Metrics
% PPG metrics
dataMatrix1 = [yPPG1;sig(11,:)];
[ecgHR,PPGHR1,f,mag1]=computeHRmetrics(dataMatrix1,0);

dataMatrix2 = [yPPG2;sig(11,:)];
[ecgHR,PPGHR2,f,mag2]=computeHRmetrics(dataMatrix2,0);

[f,SaccX1]=computeSpectrum(accX1,50);
[f,SaccY1]=computeSpectrum(accY1,50);
[f,SaccZ1]=computeSpectrum(accZ1,50);
[f,SaccX2]=computeSpectrum(accX2,50);
[f,SaccY2]=computeSpectrum(accY2,50);
[f,SaccZ2]=computeSpectrum(accZ2,50);

%% Plot
subplot(2,2,1)
plot(f,mag1,'r')
hold on
plot(f,mag2,'b')
legend('PPG1','PPG2')
xlabel('Hz')
grid on
title(['PPG'])
display(['ECG heart rate: ',num2str(ecgHR),'- PPG1 heart rate: ',num2str(PPGHR1),'- PPG2 heart rate: ',num2str(PPGHR2)])


subplot(2,2,2)
plot(f,mag1,'r')
hold on
plot(f,mag2,'b')
hold on
plot(f,SaccX1,'g')
hold on
plot(f,SaccX2,'c')
grid on
xlabel('Hz')
title(['PPG + AccX'])
legend('PPG1','PPG2','AccX1','AccX2')

subplot(2,2,3)
plot(f,mag1,'r')
hold on
plot(f,mag2,'b')
hold on
plot(f,SaccY1,'g')
hold on
xlabel('Hz')
plot(f,SaccY2,'c')
grid on
title(['PPG + AccY'])
legend('PPG1','PPG2','AccY1','AccY2')


subplot(2,2,4)
plot(f,mag1,'r')
hold on
plot(f,mag2,'b')
hold on
plot(f,SaccZ1,'g')
hold on
plot(f,SaccZ2,'c')
grid on
xlabel('Hz')
title(['PPG + AccZ'])
legend('PPG1','PPG2','AccZ1','AccZ2')

% Save plots
saveas(gcf,[figuresPath,file],'epsc')
saveas(gcf,[figuresPath,file,'.fig'])

figure
subplot(3,1,1)
plot(ppg1,'r')
hold on
plot(ppg2,'b')
% hold on
% plot(accY1,'g')
title('Raw')
grid on
xlabel('Time')
subplot(3,1,2)
plot(accX1,'r')
hold on
plot(accX2,'r--')
hold on
plot(accY1,'g')
hold on
plot(accY2,'g--')
hold on
plot(accZ1,'y')
hold on
plot(accZ2,'y--')
hold on
title('Accelerometers')
grid on
legend('X1','X2','Y1','Y2','Z1','Z2')
xlabel('Time')

subplot(3,1,3)
plot(yPPG1,'r')
hold on
plot(yPPG2,'b')
xlabel('Time')
grid on
title('Filtered')

% Save plots
saveas(gcf,[figuresPath,file,'_RAW'],'epsc')
saveas(gcf,[figuresPath,file,'_RAW.fig'])


% 
% 
% plot(f,mag1,'r')
% hold on
% plot(f,mag2,'b')
% hold on
% plot(f,SaccX1,'g')
% hold on
% plot(f,SaccY1,'c')
% hold on
% plot(f,SaccZ1,'y')
% hold on
% plot(f,SaccX2,'g-.')
% hold on
% plot(f,SaccY2,'c-.')
% hold on
% plot(f,SaccZ2,'y-.')
% 
% legend('PPG1','PPG2','AccX1','AccX2','AccY1','AccY2','AccZ1','AccZ2')
% grid on
% title(['Spectrum ',activitiy])
% xlabel('Hz')
% 
% 
% saveas(gcf,[figuresPath,file,'Acc'],'epsc')
% saveas(gcf,[figuresPath,file,'Acc.fig'],'epsc')