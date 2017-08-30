%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Advisor: PhD Igor Stefanini
% window partition dataset 
% -------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Paths
path = '/home/lex/Desktop/PPG_DATASET/1_IEEE_Signal_Processing_cup_2015/';


%% Parameters
windowSize = 5; % In seconds
Fs = 50;
stride = 0.5; % percentage of overlaping
step = floor(windowSize*Fs*stride);

winLen = windowSize*Fs;


WindowSigTrain = {};
WindowSigTest = {};


%% Train Set

files = dir([path,'Training_data','/*.mat']);
contSigns = 1;
segmentsNum = 0;
for i=1:length(files)
    
   file = files(i).name;
   if(file(1,end-4)~='e')
       load([path,'Training_data','/',file])
              
       numberOfParts = floor((size(sig,2))/(winLen-step));
       segmentsNum = segmentsNum + numberOfParts;
       newSig=zeros(size(sig,1),winLen,numberOfParts);      
      

        for w=1:numberOfParts-1

            if(w>1)
                newSig(:,:,w)=(sig(:,floor((w-1)*step):floor((w-1)*step)+winLen-1));
                [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(newSig(1,:,w),Fs,0);
                ecgHR = length(qrs_i_raw);
                 newSig(1,:,w)= ones(size(newSig(1,:,w)))*ecgHR;
                %B = reshape(sig(:,(w-1)*winLen+1:(w-1)*winLen+winLen),[size(newSig,2),size(newSig,3)])
            else
                newSig(:,:,w)=(sig(:,floor((w-1)*step)+1:floor((w-1)*step)+winLen));                
            end
        end
        
        WindowSigTrain{contSigns} = newSig;
        contSigns = contSigns+1;       

   end
    
end


%% test Set
% Make labels sequences
pathLabels = '/home/lex/Desktop/PPG_DATASET/1_IEEE_Signal_Processing_cup_2015/TestData/TrueBPM/'
files = dir([pathLabels,'/*.mat']);
segmentsNumTest = 0;
files = dir([path,'TestData','/*.mat']);
contSigns = 1;
for i=1:length(files)
    
   file = files(i).name;
   if(file(1,end-4)~='e')
       load([path,'TestData','/',file])
       
       % Load labels       
       load([pathLabels,'True',file(5:end)])
       % Extend labels
       labelsSig = zeros(size(sig,2),1);
       stepLabel = 51*2;
       for l=1:size(BPM0,1)
           try
               labelsSig((l-1)*stepLabel+1:(l-1)*stepLabel+stepLabel) = ...
                   ones(size(labelsSig((l-1)*stepLabel+1:(l-1)*stepLabel+stepLabel)))*BPM0(l); 
           catch
               labelsSig((l-1)*stepLabel+1:end) = ...
                   ones(size(labelsSig((l-1)*stepLabel+1:end)))*BPM0(l);                
           end
           
       end 
       
        
       
       numberOfParts = floor((size(sig,2))/(winLen-step));
       segmentsNumTest = segmentsNumTest + numberOfParts;
       newSig=zeros(size(sig,1)+1,winLen,numberOfParts);
      
        for w=1:numberOfParts-1

            if(w>1)
                newSig(2:end,:,w)=(sig(:,floor((w-1)*step):floor((w-1)*step)+winLen-1));
                newSig(1,:,w)=(labelsSig(floor((w-1)*step):floor((w-1)*step)+winLen-1));
                %B = reshape(sig(:,(w-1)*winLen+1:(w-1)*winLen+winLen),[size(newSig,2),size(newSig,3)])
            else
                newSig(2:end,:,w)=(sig(:,floor((w-1)*step)+1:floor((w-1)*step)+winLen)); 
                newSig(1,:,w)=(labelsSig(floor((w-1)*step)+1:floor((w-1)*step)+winLen));
            end
        end
        
        WindowSigTest{contSigns} = newSig;
        contSigns = contSigns+1;       

   end
    
end


%% Cells to matrix and padding
trainMat = zeros(6,winLen,segmentsNum);
testMat = zeros(6,winLen,segmentsNumTest);
antVal = 1;

for i=1:size(WindowSigTrain,2)
    
    tempMat = WindowSigTrain{i};
    trainMat(:,:,antVal:antVal+size(tempMat,3)-1) = tempMat;
    antVal = antVal+size(tempMat,3);
    
end

antVal = 1;
for i=1:size(WindowSigTest,2)
    
    tempMat = WindowSigTest{i};
    trainMat(:,:,antVal:antVal+size(tempMat,3)-1) = tempMat;
    antVal = antVal+size(tempMat,3);    

end
