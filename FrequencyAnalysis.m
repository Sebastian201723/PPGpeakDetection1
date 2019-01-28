clc;
close all;
%% ANALISIS DE ESPECTRO DE SE�AL PPG SIN RUIDO
% Lectura de la se�al
Fs = 125; % Sample rate
% M�xima frecuencia del espectro: Fs/2
ppg = load('DATA_01_TYPE01.mat');
ppgSignal = ppg.sig;
pfinal = ppgSignal(3,(1:3050));
%% An�lisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal);
[PS,NN] = PowSpecs(pfinal);
figure(1)
plot(f,dP);
title('Espectro de la se�al total en reposo, primeros 30 segundos');
 figure(2)
 plot(Fs/2*linspace(0,1,NN-1),PS)
 title('Espectro de Potencia')
 axis([0 50 -1 3000 ])
 
 pfinal2 = ppgSignal(3,(5000:18000));
%% An�lisis de los espectros
[~,~,f,dP] = centerfreq(Fs,pfinal2);
[PS,NN] = PowSpecs(pfinal2);
figure(3)
plot(f,dP);
title('Espectro de la se�al total CON RUIDO, primeros 30 segundos');
figure(4)
plot(Fs/2*linspace(0,1,NN-1),PS)
title('Espectro de Potencia')
axis([0 50 -1 3000 ])
%  %% Extracci�n de caracter�sticas
%  caract1 = caract(pfinal,Fs);
%  %% Despliegue de informaci�n de las caracter�sticas
%  DispCaract(caract1);