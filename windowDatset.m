%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Advisor: PhD Igor Stefanini
% window partition dataset 
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Paths
path = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/2_Datasets/1_IEEE_Signal_Processing_cup_2015/';


%% Parameters
windowSize = 5; % In seconds
stride = 0.5; % percentage of overlaping
Fs = 50;


WindowSig = {};


files = dir([path,'Training_data','/*.mat']);

downsampleRate = 50;
[P,Q] = rat(downsampleRate/Fs);


for i=1:length(files)
    
   file = files(i).name;
   if(file(1,end-4)~='e')
       load([path,'Training_data','/',file])
       
       
       part
       newSig = resample(oldSig(1,:),P,Q);
       sig = zeros(6,size(newSig,2));
       newSig2 = resample(oldSig(2,:),P,Q);
       newSig3 = resample(oldSig(3,:),P,Q);
       newSig4 = resample(oldSig(4,:),P,Q);
       newSig5 = resample(oldSig(5,:),P,Q);
       newSig6 = resample(oldSig(6,:),P,Q);
       sig(1,:) = newSig;
       sig(2,:) = newSig2;
       sig(3,:) = newSig3;
       sig(4,:) = newSig4;
       sig(5,:) = newSig5;
       sig(6,:) = newSig6;
       
       % Save
       save([path,'Training_data','/',file],'sig')
   end
    
end


files = dir([path,'TestData','/*.mat']);

for i=1:length(files)
    
   file = files(i).name;
   if(file(1,end-4)~='e')
       load([path,'TestData','/',file])
       oldSig = sig;
       clear sig
       newSig = resample(oldSig(1,:),P,Q);
       sig = zeros(5,size(newSig,2));
       newSig2 = resample(oldSig(2,:),P,Q);
       newSig3 = resample(oldSig(3,:),P,Q);
       newSig4 = resample(oldSig(4,:),P,Q);
       newSig5 = resample(oldSig(5,:),P,Q);
       sig(1,:) = newSig;
       sig(2,:) = newSig2;
       sig(3,:) = newSig3;
       sig(4,:) = newSig4;
       sig(5,:) = newSig5;
       
       % Save
       save([path,'TestData','/',file],'sig')
   end
    
end
