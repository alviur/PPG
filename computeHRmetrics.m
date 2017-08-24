%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Compute metrics
% -------------------------------------------------------------------------
% dataMatrix: Two row matrix containing PPG and ECG respectevely
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ecgHR,PPGHR,f,P3]=computeHRmetrics(dataMatrix,plotFlag)

    %% Compute ECG HR
    [qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(dataMatrix(2,:),50,0);
    ecgHR = length(qrs_i_raw);

%     %% ECG Spectrum
%     ecg = dataMatrix(2,:);
%     Fs = 50;
%     %Spectrum plot
%     T = 1/Fs;             % Sampling period       
%     L = length(ecg);    % Length of signal
%     t = (0:L-1)*T;        % Time vector
% 
%     Y =fft(ecg)./numel(ecg);;
% 
%     P2 = abs(Y(2:end)/L);
%     P1 = P2(1:L/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
% 
%     f = Fs*(0:(L/2))/L;
%     P1 = (P1 - min(P1)) / ( max(P1) - min(P1) );
%     plot((f),P1) 
%     grid on
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
%     hold on


    %% PPG Spectrum
    
    ppg1 = dataMatrix(1,:);
    %Spectrum plot
    Fs =50;
    T = 1/Fs;             % Sampling period       
    L = length(ppg1);    % Length of signal
    t = (0:L-1)*T;        % Time vector

    Y =fft(ppg1)./numel(ppg1);;

    P4 = abs(Y(2:end)/L);
    P3 = P4(1:L/2+1);
    P3(2:end-1) = 2*P3(2:end-1);

    f = Fs*(0:(L/2))/L;
    P3 = (P3 - min(P3)) / ( max(P3) - min(P3) );
    
    if(plotFlag>0)
        plot((f),P3) 
        grid on
        title('Single-Sided Amplitude Spectrum of X(t)')
        xlabel('f (Hz)')
        ylabel('|P1(f)|')
    end

    [M,I] =max(P3);
    PPGHR = f(I)*21;
end

