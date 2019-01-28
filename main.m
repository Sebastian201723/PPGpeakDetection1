%% ACTIVIDADES TIPO 1
    figure(1) 
    ppg=load('DATA_01_TYPE01.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(3,(3000:18050));
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSI�N A VARIABLES F�SICAS
    s2 = (pfinal-128)/(255);
   % s2 = (ppgSignal(2,:)+81)/161;
    s3 = (ppgSignal(3,:)+41)/81;
% NORMALIZACI�N POR M�XIMOS Y M�NIMOS
    s2Norm = (s2-min(s2))/(max(s2)-min(s2));
    plot(s2Norm,'r')

    t = (0:length(pfinal)-1);
    
wname  = 'sym4';               % Wavelet for analysis.
level  = 5;                    % Level for wavelet decomposition.
sorh   = 's';                  % Type of thresholding.
nb_Int = 3;                    % Number of intervals for thresholding.

[sigden,coefs,thrParams,int_DepThr_Cell,BestNbOfInt] = ...
            cmddenoise(s2Norm,wname,level,sorh,nb_Int);
 hold on,   
 plot(sigden,'k','linewidth',2)
 axis tight
 title('Se�ales con y sin ruido')
 legend('Original Signal','Denoised Signal','Location','NorthWest');
 figure(2)
 Ruido = s2Norm - sigden;
 plot(Ruido)
 title('RUIDO A PARTIR DE WAVELETS')
 axis tight
 
 figure(3)
 EspectroSenal = fft(s2Norm);
 X_mag = abs(EspectroSenal)
 X_fase = angle(EspectroSenal)
 N = length(s2Norm);
 Freq = (0:1/N:1-1/N)*Fs;
 plot(Freq,EspectroSenal)
 axis([0 10 -200 200 ])

%% An�lisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal);
[PS,NN] = PowSpecs(pfinal);
[~,~,f2,dP2] = centerfreq(Fs,sigden);
[PS2,NN2] = PowSpecs(sigden);
figure(4)
plot(f,dP);
hold on 
plot(f2,dP2)
legend('Senal con ruido','Senal sin ruido')
title('Espectro de la se�al CON Y SIN RUIDO total en reposo, primeros 30 segundos');
 %plot(Fs/2*linspace(0,1,NN-1),PS)
 title('Espectro de Potencia')
 axis([0 50 -1 100 ])
 
%helperFFT(Freq,X_mag,'Magnitude Response')
 