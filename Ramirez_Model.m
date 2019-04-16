%% JOINT GAUSSIAN RANDOM VECTOR NOISE MODEL
function [ShortedBP]=Ramirez_Model()
% clear all
% close all
% clc
%% Add GetAverageNoise function
%%IMPORTANTE!!!! SACAR MEDIAMUESTRAL DEL SCRIPT DE GETAVERAGEDNOISE
%%QUITANDO LA PARTE EN LA QUE SE LE SUMA VALORESMEDIA
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/GeneralNoise')
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/SpectrumAnalysis')
% Add databases
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/db')
%SampleFrequency
Fs=125;
%% OBTAIN SAMPLES AND GENERALIZED SAVITZKY NOISE MODEL
[mediamuestral,TamRealizaciones,s,s1,s2,s3,s4,s5]=GetAveragedNoise();
%% UNBIASED VARIANZA
% The activities are separated according to each activity and its variance
% Add is extracted vertically, operating varianamuestral function per column

media=ValoresMedia(mediamuestral);
mediamuestral = mediamuestral-media;
V=[s-media(1:3750) s1-media(3751:11250) s2-media(11251:18750) s3-media(18751:26250) s4-media(26251:33750) s5-media(33751:end)];
varianzamuestral= var(V);
%% AUTOCORRELATION AND Autocovariance MATRIX

[L,A]=size(V);
i=1;
j=1;
for t1=1:100:length(V)
    for t2=1:100:length(V)
        RxxTotal(i,j)=(V(:,t1)'*V(:,t2))/L;
        KxxTotal(i,j)=RxxTotal(i,j)-(mediamuestral(t1).*mediamuestral(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end

%% MODELO GAUSIANO LIMITADO EN BANDA
X = randn(4,1);
X(5)=0;
GaussianModels=zeros(5,length(mediamuestral));
for k=1:length(mediamuestral)
    GaussianModels(:,k)=mediamuestral(k)+sqrt(varianzamuestral(k))*X;
end


%% PROOF1: IF THE NOISE IS RIGHT, IT SHOULD MAINTAIN IT'S CORRELATED BEHAVIOR
% We choose one of these realizations for the proof
W=GaussianModels(5,:);

i=1;
for t1=1:100:length(V)
    for t2=1:100:length(V)
        RxxGaussiana(i,j)=(W(:,t1)'*W(:,t2))/L;
        KxxGaussiana(i,j)=RxxGaussiana(i,j)-(mediamuestral(t1).*mediamuestral(t2));
        j=j+1;
    end
    i=i+1;
    j=1;
end
%% Comparacion de modelos: 
for i =1:5
   plot(GaussianModels(i,:)),hold on
end
plot(mediamuestral,'LineWidth',1.5),title('Normal Gaussian Noise vs Savitzky HF noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('w1','w2','w3','w4','w5','mediamuestral')
%% SPECTRAL ANALYSIS
% Spectrum1 = GetSpectrum(GaussianModels(1,:),Fs);
% Spectrum2 = GetSpectrum(GaussianModels(2,:),Fs);
% Spectrum3 = GetSpectrum(GaussianModels(3,:),Fs);
% Spectrum4 = GetSpectrum(GaussianModels(4,:),Fs);
% Spectrum5 = GetSpectrum(GaussianModels(5,:),Fs);
% Spectrum6 = GetSpectrum(mediamuestral,Fs);
%% Caracter�sticas de frecuencia aplicadas: 0-10 hz, se dejan valores mayores 
% a 10 para capturar detalles de alta frecuencia del ruido de alta
% frecuencia
%Creación del filtro
PBF = designfilt('bandpassiir','PassbandFrequency1',3.5,...
'StopbandFrequency1',3,'StopbandFrequency2',26.5,...
'PassbandFrequency2',26,...
'StopbandAttenuation1',30,'StopbandAttenuation2',30,...
'SampleRate',Fs,'DesignMethod','ellip');
%% VEAMOS COMO SE COMPARA CON EL SAVITZKY
ShortedBP = filtfilt(PBF,W);
plot(mediamuestral(1:3750)), hold on
plot(ShortedBP(1:3750)),title('Activity RESTING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('Mediamuestral','Senal Gaussiana Limitada en banda')
figure
plot(mediamuestral(3750:11250)),hold on
plot(ShortedBP(3750:11250)),title('Activity RUNNING: Savitzky Noise vs Band-Limited Gaussian Noise'),ylabel('Magnitude'), xlabel('samples'),grid on, axis tight,
legend('Mediamuestral','Senal Gaussiana Limitada en banda')
%% Espectro de se�al modelo 1 limitada en banda
    [~,~,f,dP1] = centerfreq(Fs,mediamuestral); 
    [~,~,f2,dP2] = centerfreq(Fs,ShortedBP); 
    [PS,NN] = PowSpecs(mediamuestral);
    [PS,NN] = PowSpecs(ShortedBP);
    figure
    plot(f,dP1,f2,dP2),grid on, axis([0 50 -10 100 ])
    legend('Savitzky','Band-limited Gaussian Noise')
    title('SPECTRUM, BOTH CASES')
end
