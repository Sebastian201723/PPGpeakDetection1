%% GAVIRIA'S APPROACH:
%In the third approach to a signal's noise we have as a tool a linear
%predictor, which is fed with the mean signal, in the case of the example
%with the ECG. What we have to do is, for each activity, establish which y
%the approximate period of a single cycle of the signal and, in this way,
%obtain a mean signal for every movement (given that the heart rate varies
%over time with each activity). Finally, in this first step we'll fed the
%linear predictor with the PPG average signal and substract this from the
%original, obtaining a first approach of the 'noise'.

%We get the signals.

for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        Realizaciones(k,:) = a.sig(2,(1:35989));
    end
end

%We determine sample frequency
    Fs = 125;
% And convert to physical variables according to the literature.
    s2 = (Realizaciones-128)/(255);
% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end

% Just plotting it, this can be commented.
    [a,b]=size(sNorm);
    t=(0:b-1)/Fs;
    hax=axes;
    SP1=3750/Fs;
    SP2=SP1+7500/Fs;
    SP3=SP2+7500/Fs;
    SP4=SP3+7500/Fs;
    SP5=SP4+7500/Fs;
    SP6=SP5+3750/Fs;
    figure(1),plot(t,sNorm(1,:))
    grid on, axis tight, xlabel('Tiempo'),ylabel('PPGsignal'),hold on,
    line([SP1 SP1],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP2 SP2],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP3 SP3],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP4 SP4],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP5 SP5],get(hax,'YLim'),'Color',[1 0 0]);
    line([SP6 SP6],get(hax,'YLim'),'Color',[1 0 0]);
    
    
%% FOR EVERY ACTIVITY, WE SHOULD DETREND THE SIGNAL SO IT'S EASIER TO GET 
%THE PEAKS

activity1=sNorm(:,(1:3750));
activity2=sNorm(:,(3751:11250));
activity3=sNorm(:,(11251:18750));
activity4=sNorm(:,(18751:26250));
activity5=sNorm(:,(26251:33750));
activity6=sNorm(:,(33751:end));

for k=1:12
    activity1(k,:)=Detrending(activity1(k,:),5);
    activity2(k,:)=Detrending(activity2(k,:),5);
    activity3(k,:)=Detrending(activity3(k,:),5);
    activity4(k,:)=Detrending(activity4(k,:),5);
    activity5(k,:)=Detrending(activity5(k,:),5);
    activity6(k,:)=Detrending(activity6(k,:),5);
end

% Just plotting it to check the detrended signal
t30s=(0:length(activity1)-1)/Fs;
t60s=(0:length(activity2)-1)/Fs;
tfin=(0:length(activity6)-1)/Fs;
realization=1; %change this value to update realization.
figure(2)
plot(t30s,activity1(realization,:)),title('Detrended signal for activity 1'), xlabel('Time (s)'),grid on, axis tight,
figure(3)
plot(t60s,activity2(realization,:)),title('Detrended signal for activity 2'), xlabel('Time (s)'),grid on, axis tight,
figure(4)
plot(t60s,activity3(realization,:)),title('Detrended signal for activity 3'), xlabel('Time (s)'),grid on, axis tight,
figure(5)
plot(t60s,activity4(realization,:)),title('Detrended signal for activity 4'), xlabel('Time (s)'),grid on, axis tight,
figure(6)
plot(t60s,activity5(realization,:)),title('Detrended signal for activity 5'), xlabel('Time (s)'),grid on, axis tight,
figure(7)
plot(tfin,activity6(realization,:)),title('Detrended signal for activity 6'), xlabel('Time (s)'),grid on, axis tight,

 %% FOR ACTIVITY 1 (INITIAL 30 SECONDS):
 addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
 
 %for k=1:12 
     [PKS1,LOCS1]=GetPeakPoints(activity1(1,:),Fs,0.11,0.5,0.005);
     peaks=length(PKS30);
 %end

%%
intPP=mean(diff(LOCS30)); %Here we obtain the average P-P interval
fprintf('El intervalo PP promedio es %d ',intPP);
fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico',round(intPP/2,2));

delay=round(0.4*Fs);
M=length(diff(LOCS30));   % N�mero de intervalos RR encontrados
offset=0.3;     % Para desplegar los intervalos RR en 3D por 
                % encima de la se�al
stack=zeros(M,min(LOCS30)); % Reserva memoria para almacenar 
                        % matriz de M ciclos cardiacos
qrs=zeros(M,2); % Reserva memoria para curva de intervalos RR en 3D

