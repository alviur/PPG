%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Advisor: Igor Stefanini
% 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mainPath = '/home/lex/Desktop/PPG_dataset/ind_2/Walking/'
rawFile =fopen([mainPath,'cutecom.log']);
ecgPath = '20170728170924Default1010202030304444555556666.dat'
saveName = 'ind_2_Walking.mat';

%% Load data glasses


inputFrame = fread(rawFile);

% Find separation pattern
SplitFlag= findpattern(inputFrame, [252 253]) ;

% Split input frame
splittedFrame = splitData(inputFrame, SplitFlag);

% Build final signal
frame = zeros(length(splittedFrame),8);
for i=1:length(splittedFrame)
    frame(i,:) = buildFrame(splittedFrame{i});
end

% Get signals
accX1 = frame(:,1);
accY1 = frame(:,2);
accZ1 = frame(:,3); 
accX2 = frame(:,4);
accY2 = frame(:,5);
accZ2 = frame(:,6);
ppg1 = frame(:,7);
ppg2 = frame(:,8);

%% Load ECG data from shimmer record
% The columns in the file are:
% C2 Vx-RL // C12 LA-RA // C19 LL-RA // C20 LL-LA
ecgRaw = csvread([mainPath,ecgPath],4);

% Extract leads
L1 = ecgRaw(:,12);
L2 = ecgRaw(:,19);
L3 = ecgRaw(:,20); 

%% Resample ECG to 50Hz
Fs = 55;
targetFs = 50;
[P,Q] = rat(targetFs/Fs);

L1 = resample(L1,P,Q);
L2 = resample(L2,P,Q);
L3 = resample(L3,P,Q);

%% Build data Matrix

if(length(L1)>length(ppg1))
    
    maxL = length(ppg1);
else
    maxL = length(L1);
end

sig = zeros(11,maxL);

sig(1,:) = ppg1(1:maxL);
sig(2,:) = ppg2(1:maxL);
sig(3,:) = accX1(1:maxL);
sig(4,:) = accY2(1:maxL);
sig(5,:) = accZ1(1:maxL);
sig(6,:) = accX2(1:maxL);
sig(7,:) = accY2(1:maxL);
sig(8,:) = accZ2(1:maxL);
sig(9,:) = L1(1:maxL);
sig(10,:) = L2(1:maxL);
sig(11,:) = L3(1:maxL);

%% Plot data

subplot(3,1,1)
plot(sig(1,:))
title('PPG 1');
subplot(3,1,2)
plot(sig(2,:))
title('PPG 2');
subplot(3,1,3)
plot(sig(10,:))
title('ECG');

%% Save data

save([mainPath,saveName],'sig');

