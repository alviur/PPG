%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Advisor: PhD Igor Stefanini
% Heart rate estimation
% -------------------------------------------------------------------------
% Based on: De Giovanni E, Murali S, Rincon F, Atienza D. Ultra-Low Power 
% Estimation of Heart Rate Under Physical Activity Using a Wearable 
% Photoplethysmographic System. In Digital System Design (DSD), 2016 
% Euromicro Conference on 2016 Aug 31 (pp. 553-560). IEEE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

%% Load path

figuresPath = '/home/lex/MEGAsync/1_MSE/2_Projects/Project_2/6_Results/Single_source/';
file = 'LMS_ind_4_w_Walking';
load(['ind_1_Nod','.mat'])
activitiy = 'Walking'

ppg =   sig(1,:);
accX1 = sig(3,:);
accY1 = sig(4,:);
accZ1 = sig(5,:);

windowLength = 8; % in seconds
windowStep = 1;

%% Bandpass filtering between 0.5 Hz and 10 Hz

% A low pass filter is Used at 50Hz in PPG signals
N   = 120;
Fs  = 50;
Fp  = 10;
Ap  = 0.01;
Ast = 80;

% Design a FIR low pass filter
LP_FIR = dsp.LowpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);

Fp  = 0.5;
% Design a FIR High pass filter
HP_FIR = dsp.HighpassFilter('SampleRate',Fs,...
    'DesignForMinimumOrder',false,'FilterOrder',N,...
    'PassbandFrequency',Fp,'PassbandRipple',Ap,'StopbandAttenuation',Ast);

% Apply filters in PPG
ppg = step(HP_FIR,step(LP_FIR,ppg));
% Apply filter in Acc
accX = step(HP_FIR,step(LP_FIR,accX1));
accY = step(HP_FIR,step(LP_FIR,accY1));
accZ = step(HP_FIR,step(LP_FIR,accZ1));

%% Divide signal by windows and perform FFT

totalSeconds = length(ppg)/Fs;
%numWindows = totalSeconds/windowLength;
numWindows = totalSeconds-windowLength;

HR = zeros(floor(totalSeconds),1);

segmentsTimePPG = zeros(floor(numWindows),Fs*windowLength);
segmentsSpectPPG = zeros(floor(numWindows),Fs*windowLength/2+1,2);

segmentsTimeAcc = zeros(floor(numWindows),Fs*windowLength,3);
segmentsSpectAcc = zeros(floor(numWindows),Fs*windowLength/2+1,3,2);

for i =0:size(segmentsTimePPG,1)-2
   
   % Assign a window
   segmentsTimePPG(i+1,:) = ppg((i*Fs)+1:(i*Fs)+...
       (Fs*windowLength));
   
   segmentsTimeAcc(i+1,:,1) = accX((i*Fs)+1:(i*Fs)+...
       (Fs*windowLength)); 
   
   segmentsTimeAcc(i+1,:,2) = accY((i*Fs)+1:(i*Fs)+...
       (Fs*windowLength)); 
   
   segmentsTimeAcc(i+1,:,3) = accZ((i*Fs)+1:(i*Fs)+...
       (Fs*windowLength));  
   
   % Compute FFT of the window
   [f,P3]=computeSpectrum( segmentsTimePPG(i+1,:),Fs);
   segmentsSpectPPG(i+1,:,1) = P3;
   segmentsSpectPPG(i+1,:,2) = f;
    
   [f,P3]=computeSpectrum( segmentsTimeAcc(i+1,:,1),Fs);
   segmentsSpectAcc(i+1,:,1,1) = P3;   
   segmentsSpectAcc(i+1,:,1,2) = f;

   [f,P3]=computeSpectrum( segmentsTimeAcc(i+1,:,2),Fs);
   segmentsSpectAcc(i+1,:,2,1) = P3;
   segmentsSpectAcc(i+1,:,2,2) = f;
   
   [f,P3]=computeSpectrum( segmentsTimeAcc(i+1,:,3),Fs);
   segmentsSpectAcc(i+1,:,3,1) = P3;
   segmentsSpectAcc(i+1,:,3,2) = f;
   
end

% Assign last sample and pad with zeros
segmentsTimePPG(end,1:length(ppg((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end))) = ppg((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end);

segmentsTimeAcc(end,1:length(ppg((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end)),1) = accX((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end);

segmentsTimeAcc(end,1:length(ppg((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end)),2) = accY((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end);

segmentsTimeAcc(end,1:length(ppg((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end)),3) = accZ((size(segmentsTimePPG,1)-1)*...
    (Fs*windowLength)+1:end);

[f,P3]=computeSpectrum( segmentsTimePPG(end,:),Fs);
segmentsSpectPPG(end,:,1) = P3;
segmentsSpectPPG(end,:,2) = f;

[f,P3]=computeSpectrum( segmentsTimeAcc(end,:,1),Fs);
segmentsSpectAcc(end,:,1,1) = P3;
segmentsSpectAcc(end,:,1,2) = f;

[f,P3]=computeSpectrum( segmentsTimeAcc(end,:,2),Fs);
segmentsSpectAcc(end,:,2,1) = P3;
segmentsSpectAcc(end,:,2,2) = f;


[f,P3]=computeSpectrum( segmentsTimeAcc(end,:,3),Fs);
segmentsSpectAcc(end,:,3,1) = P3;
segmentsSpectAcc(end,:,3,2) = f;


%% Window Loop
% This part is executed one time per window

for window=1:floor(numWindows)
    
    % Assign temp variable for window
    ppgTempS = segmentsSpectPPG(window,:,1);
    accTemp = segmentsSpectAcc(window,:,:,1);


%% Algorithm 0: Find peaks in spectrum

    % Select highest peak 
    [Sppg,SIppg] = sort(ppgTempS,'descend');
    [SaccX,SIaccX] = sort(accTemp(:,1,1),'descend');
    [SaccY,SIaccY] = sort(accTemp(:,2,1),'descend');
    [SaccZ,SIaccZ] = sort(accTemp(:,3,1),'descend');

    % Select PPG peak > %maximum Peak
    maxPeakT = 0.01; % same as paper
     maxPeakAT = 0.4; % same as paper
    contPeaks = 1;
    
    selecPeaks=zeros(15,2);
    for p=1: length(Sppg)

        if(Sppg(p)>=maxPeakT*Sppg(1) && contPeaks<7)
            
            selecPeaks(contPeaks,1) = Sppg(p);
            selecPeaks(contPeaks,2) = SIppg(p);
            contPeaks = contPeaks+1;           
        end        
    end
        
    % Store previous and next peaks of the maximum peak 
    [M,I] = max(ppgTempS);
    ppgTempS(ppgTempS<maxPeakT*M) = 0;
    [pks,locs] = findpeaks(ppgTempS);
    [M,I] = max(ppgTempS);    
    dist = length(locs);
    dist2 = length(locs);
    
    for p=1: length(pks)
        
        if(locs(p)- I<dist  && locs(p)- I>0)
            vec1 = pks(p);
            vec2 = locs(p);
            dist = locs(p)- I;
        end
        
        if(I - locs(p)<dist2  && locs(p)- I>0)
            vec3 = pks(p);
            vec4 = locs(p);
            dist = I - locs(p);
        end            
        
    end
    
     selecPeaks(contPeaks,1) = vec1;% magnitude
     selecPeaks(contPeaks,2) = vec2;% position
     
     selecPeaks(contPeaks+1,1) = vec3;
     selecPeaks(contPeaks+1,2) = vec4;
     
     selecPeaks=selecPeaks(1:contPeaks+1,:);

    % Filter Accelerometers
    contPeaksX = 1;
    contPeaksY = 1;
    contPeaksZ = 1;
    
    selecPeaksAX = zeros(50,2);
    selecPeaksAY = zeros(50,2);
    selecPeaksAZ = zeros(50,2);
    
    for p=1: length(SaccX)

        if(SaccX(p)>=maxPeakAT*SaccX(1) )            
            selecPeaksAX(contPeaksX,1) = SaccX(p);
            selecPeaksAX(contPeaksX,2) = SIaccX(p); 
            contPeaksX = contPeaksX + 1;
        end
        
        if(SaccY(p)>=maxPeakAT*SaccY(1) )            
            selecPeaksAY(contPeaksY,1) = SaccY(p);
            selecPeaksAY(contPeaksY,2) = SIaccY(p);      
            contPeaksY = contPeaksY + 1;
        end 
        
        if(SaccZ(p)>=maxPeakAT*SaccZ(1) )            
            selecPeaksAZ(contPeaksZ,1) = SaccZ(p);
            selecPeaksAZ(contPeaksZ,2) = SIaccZ(p);      
            contPeaksZ = contPeaksZ + 1;
        end        
        
    end

    selecPeaksAX = selecPeaksAX(1:contPeaksX-1,:);
    selecPeaksAY = selecPeaksAY(1:contPeaksY-1,:);
    selecPeaksAZ = selecPeaksAZ(1:contPeaksZ-1,:);    
    
    
    selecPeaksAcc=cell(3,1);
    selecPeaksAcc{1} = selecPeaksAX;
    selecPeaksAcc{2} = selecPeaksAY;
    selecPeaksAcc{3} = selecPeaksAZ;   
    
%% Algorithm 2: Check neighbourhood for close peaks    

    flagPeak=0;
    if(length(selecPeaks)>1 && segmentsSpectPPG(window,I,2)>(windowLength*1.5))
        for(i=1:length(selecPeaks))
            if(segmentsSpectPPG(window,selecPeaks(i,1),2)>(windowLength*1.5))
                dist = abs(segmentsSpectPPG(window,I,2)-segmentsSpectPPG(window,...
                    selecPeaks(i,1),2));
            
                if(dist<10/windowLength && segmentsSpectPPG(window,... %----------- Check this
                        selecPeaks(i,1),1)>0.2*segmentsSpectPPG(window,I,1))                    
                    
                    flagPeak=1;
                    
                end
                
            end
        end
        
    end

 
%% Algorithm 3: Check neightbourhood for hidden peaks

peak=I;

if(flagPeak == 0)
    % Compute second order derivative
    diffPPG = diff(segmentsSpectPPG(window,:,1),1);
    
    % Find peaks 
    [pks,locs] = findpeaks(diffPPG);
    
    if(abs(segmentsSpectPPG(window,selecPeaks(end,2),2)-...
            segmentsSpectPPG(window,I,2))>15/windowLength)%----------- Check this
       peak=selecPeaks(end,2);
        
    end
    
    if(abs(segmentsSpectPPG(window,selecPeaks(end-1,2),2)-...
            segmentsSpectPPG(window,I,2))>15/windowLength)%----------- Check this
       peak=selecPeaks(end-1,2);
        
    end    
    
    dist = abs(segmentsSpectPPG(window,peak,2)-segmentsSpectPPG(window,I,2));
    
    if(dist<12/windowLength && diffPPG(peak)>0.2*segmentsSpectPPG(window,peak,1))
        flagPeak = 1;
    end
    
end

%% Algorithm 1: Moving average removal


for i=1:length(selecPeaks)
    for axis=0:2
        % For each axis 
        acc = selecPeaksAcc{axis+1};
        for j=1:size(acc,1)
            if(segmentsSpectAcc(window,acc(j,2),axis+1,2)*0.98<segmentsSpectPPG(window,selecPeaks(i,2),2)...
                    && segmentsSpectPPG(window,selecPeaks(i,2),2)<1.02*segmentsSpectAcc(window,acc(j,2),axis+1,2))
               if(selecPeaks(i,2)~=I)
                   segmentsSpectPPG(window,selecPeaks(i,2),2)=0;
                   selecPeaks(i,2)=0;
                   selecPeaks(i,1)=0;
                   valuePPG = 0;
               elseif(accTemp(acc(j,2),axis+1,2)<95/60 && flagPeak == 1)
                   segmentsSpectPPG(window,selecPeaks(i,2),2)=0;
                   selecPeaks(i,2)=0;
                   selecPeaks(i,1)=0;
                   valuePPG = 0;                   
               end
                
            end

        end
    end
end


% check for peak values
cont = 1;
for i=1:size(selecPeaks,1)

    if(selecPeaks(i,2)>0)
        
        selecPeaks2(cont,1) =  selecPeaks(i,1);
        selecPeaks2(cont,2) =  selecPeaks(i,2);
        cont = cont+1;
    end    
    
end


%% Algorithm 4: Check previous 5 heart rate values
flagHROK = 1;
if(window>1)

    % Check m previous windows
    %for(m=1:5)
        if(abs(segmentsSpectPPG(window,selecPeaks2(1,2),2)-prevHR) && window>1)
           flagHROK = 0;

        end

    %end

    %% Algorithm 5: Adjusting considering previous window and updating

    if(flagHROK == 0)
        HRnew = prevHR + sign(segmentsSpectPPG(window,selecPeaks2(1,2),2)-prevHR);
    else
        if(size(selecPeaks2,1)>0)
            distToLastPeak = 1000;
            for(i=1:size(selecPeaks2,1))
                dist = abs(segmentsSpectPPG(window,selecPeaks2(i,2),2)-prevHR);

                if(segmentsSpectPPG(window,selecPeaks2(i,2),2)~=0 && dist<distToLastPeak)
                    HRnew = prevHR + sign(segmentsSpectPPG(window,selecPeaks2(i,2),2)-prevHR)*min(dist,5/60);
                    distToLastPeak = dist;
                end

            end
        end
    end

    if(size(selecPeaks2,1)>0)
      prevHR = HRnew;
    else
      HRnew = prevHR;  
    end
    
    HR(window) = HRnew;
else
    
   prevHR =  segmentsSpectPPG(window,selecPeaks2(1,2),2);
   HR(window) = prevHR;
   
end

end
(HR')*20
