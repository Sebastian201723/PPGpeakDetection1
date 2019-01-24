function salida = caract(x,Fs)
% Entradas: x -> se�al de voz, 
%           Fs -> Frecuencia de muestreo
% Se asume que la se�al de voz ya ha sido preprocesada

%% Caracter�sticas del espectro completo de la se�al
% Frecuencia promedio y Mediana del espectro completo de la se�al
[mediaF,medianF,~,~] = centerfreq(Fs,x); % Calcula la frecuencia media donde el espectro de la se�al completa tiene su mayor potencia
%% Caracter�sticas de las frecuencias mel�dicas de la voz
% Estas caracter�sticas se obtienen luego de aplicar la FFT a un conjunto
% de ventanas m�viles sobre la se�al de voz, para detectar los "tonos" en
% la se�al de voz
[Frequency_amp,Frequency,FunFrequency] = PreProcessing(x,Fs); % Realiza el ventaneo de Haming, devuelve las frecuencias centrales,
%                                                               potencia de promedio y frecuencias fundamentales de cada espectro de una ventana
%% Desviaci�n est�ndar
sd = std(Frequency);
%% Primer cuantil
Q25 = quantile(Frequency,0.25);
%% Cuarto cuantil
Q75 = quantile(Frequency,0.75);
%% Rango intercuantil
IQR = iqr(Frequency);
%% Asimetr�a
skew = skewness(Frequency);
%% Kurtosis
kurt = kurtosis(Frequency);
%% Entrop�a espectral
spent = -sum(Frequency_amp.*log(Frequency_amp))./log(length(Frequency));
%% Achatamiento del espectro
sfm = geomean(Frequency)/mean(Frequency);
%% Moda de la frecuancia
modfrec = mode(Frequency);
%% Las siguientes caracter�sticas se extraen con base en las frecuencias fundamentales (tonos) de la voz
%% Frecuancia fundamental promedio
meanfun = mean(FunFrequency);
%% Frecuencia fundamental m�nima
minfun = min(FunFrequency);
%% Frecuancia fundamental m�xima
maxfun = max(FunFrequency);

salida = [mediaF,medianF,sd,Q25,Q75,IQR,skew,kurt,spent,sfm,modfrec,meanfun,minfun,maxfun];


