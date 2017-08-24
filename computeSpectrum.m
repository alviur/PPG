%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Alexander Gomez Villa - SUPSI
% Compute spectrum
% -------------------------------------------------------------------------
% dataMatrix: Two row matrix containing PPG and ECG respectevely
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [f,P3]=computeSpectrum(signal,Fs)

    %Spectrum plot
    Fs =50;
    T = 1/Fs;             % Sampling period       
    L = length(signal);    % Length of signal
    t = (0:L-1)*T;        % Time vector

    Y =fft(signal)./numel(signal);;

    P4 = abs(Y(2:end)/L);
    P3 = P4(1:L/2+1);
    P3(2:end-1) = 2*P3(2:end-1);

    f = Fs*(0:(L/2))/L;
    P3 = (P3 - min(P3)) / ( max(P3) - min(P3) );
    
end