%% Exploit PPG signal to get heart rate and SpO2 level
% Friendly to embedded 
% Thinh Nguyen 
% mecheng.hn@gmail.com
% THIS ONE IS NOT OPTIMIZED. DO NOT USE FOR COMMERCIAL

%% Start
clear all

%% Load sample data

clear all
[X1,X2]=textread('PPG.dat','%s %s');

data_st = 150; % Data start 
data_length = 128; % Data length

for i=1:data_length
    X(i,1)=hex2dec(X1(data_st+i))/hex2dec('7FFFFF'); % RED led
    if X(i,1)> 1
        X(i,1)=1 - X(i,1);
    end
    X(i,2)=hex2dec(X2(data_st+i))/hex2dec('7FFFFF'); % IR
    if X(i,2)> 1
        X(i,2)=1- X(i,2);
    end
end

%% Data input for Heart rate and SpO2 calculation
y1 = X(:,1); %RED
y2 = X(:,2); %IR 

fs=25; %sampling rate 25Hz
NFFT=128; % FFT size
 
%% Beat count for heart rate

% Moving average filter
for i=1:(length(y2)-fs/5)
    local_sum=0;
    for j=1:fs/5
        local_sum=local_sum+y2(i+j);
    end
        y(i)=local_sum/(fs/5);
end

% Find peaks
leap=0;
pk_i=1;

while leap<=(length(y)-fs)
    
for i=1:fs
    yy(i) = y(i+leap);
end

local_i_max = 1;
local_max = yy(local_i_max);

for i=2:fs
    if local_max<yy(i)
        local_i_max = i;
        local_max=yy(i);
    end
end

pk(pk_i)=leap+local_i_max;
pk_i=pk_i+1;
leap =leap + fs;
end

beat = 0;
beat_i = 1;
for i=1:length(pk)-1
    if pk(i)<(pk(i+1)-10)    
        beat=beat+(fs/(pk(i+1)-pk(i)))*60;
        beat_i=beat_i+1;
    end
end

if beat_i>1
    HEART_RATE=beat/(beat_i-1)
end



%% END
