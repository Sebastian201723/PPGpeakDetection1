%% GAVIRIA'S APPROACH:
%As the third approach of a signal's noise, a linear predictor is used to be
%feed with the mean of the PPG signal. 
%As exemplified by Gavirias's notes in ECG linear predictor, the RR interval
%is used to get an average period in the ECG example and since the PPG signal 
%has 2 main peaks:  M & Q, we'll get a similar approach using the MM interval 
%for each one of the 6 activity. Then we will be able to describe every 
%activity and therefore, every movement (since the heart rate varies differently over time with each activity).

%Finally, we'll feed the linear predictor with the PPG average signal and substract 
%this from the original, obtaining a first approach of 'artifitial noise'.

clc
clear all
close all
% Get and save signals in 'Realizaciones'
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

% Sample Frequency
    Fs = 125;
% Convert to physical values: According to timesheet of the used wearable
    s2 = (Realizaciones-128)/(255);
% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
end

% % Just plotting it, this can be commented.
%     [a,b]=size(sNorm);
%     t=(0:b-1)/Fs;
%     hax=axes;
%     SP1=3750/Fs;
%     SP2=SP1+7500/Fs;
%     SP3=SP2+7500/Fs;
%     SP4=SP3+7500/Fs;
%     SP5=SP4+7500/Fs;
%     SP6=SP5+3750/Fs;
%     figure(1),plot(t,sNorm(1,:))
%     grid on, axis tight, xlabel('Tiempo'),ylabel('PPGsignal'),hold on,
%     line([SP1 SP1],get(hax,'YLim'),'Color',[1 0 0]);
%     line([SP2 SP2],get(hax,'YLim'),'Color',[1 0 0]);
%     line([SP3 SP3],get(hax,'YLim'),'Color',[1 0 0]);
%     line([SP4 SP4],get(hax,'YLim'),'Color',[1 0 0]);
%     line([SP5 SP5],get(hax,'YLim'),'Color',[1 0 0]);
%     line([SP6 SP6],get(hax,'YLim'),'Color',[1 0 0]);
%     
    
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
%% Detrend activities.
nRest = 5;
nRun = 10;
for k=1:12
    DetrendedActivity1(k,:)=Detrending(Activity1(k,:),nRest);
    DetrendedActivity2(k,:)=Detrending(Activity2(k,:),nRun);
    DetrendedActivity3(k,:)=Detrending(Activity3(k,:),nRun);
    DetrendedActivity4(k,:)=Detrending(Activity4(k,:),nRun);
    DetrendedActivity5(k,:)=Detrending(Activity5(k,:),nRun);
    DetrendedActivity6(k,:)=Detrending(Activity6(k,:),nRest);
end

% Just plotting it to check the detrended signal
t30s=(0:length(DetrendedActivity1)-1)/Fs;
t60s=(0:length(DetrendedActivity2)-1)/Fs;
tfin=(0:length(DetrendedActivity6)-1)/Fs;
realization=1; %change this value to update realization.
% figure(2)
% plot(t30s,DetrendedActivity1(realization,:)),title('Detrended signal for activity 1'), xlabel('Time (s)'),grid on, axis tight,
% figure(3)
% plot(t60s,DetrendedActivity2(realization,:)),title('Detrended signal for activity 2'), xlabel('Time (s)'),grid on, axis tight,
% figure(4)
% plot(t60s,DetrendedActivity3(realization,:)),title('Detrended signal for activity 3'), xlabel('Time (s)'),grid on, axis tight,
% figure(5)
% plot(t60s,DetrendedActivity4(realization,:)),title('Detrended signal for activity 4'), xlabel('Time (s)'),grid on, axis tight,
% figure(6)
% plot(t60s,DetrendedActivity5(realization,:)),title('Detrended signal for activity 5'), xlabel('Time (s)'),grid on, axis tight,
% figure(7)
% plot(tfin,DetrendedActivity6(realization,:)),title('Detrended signal for activity 6'), xlabel('Time (s)'),grid on, axis tight,
%% WE ESTABLISH THE MATRIX THAT WILL ALLOW TO PARAMETRIZE FINDPEAKS
%  ---------ACTIVIDAD 1------      -------ACTIVIDAD 2---------    -------ACTIVIDAD 3---------    -------ACTIVIDAD 4---------   -------ACTIVIDAD 5---------    -------ACTIVIDAD 6---------                 
%  MinW| MW|PROM|  MinD| MH | MD     MinW| MW|PROM|MinD| MH | MD    MinW| MW|PROM|MinD| MH | MD
% P=[0.11 0.5 0.005 0.4  0.5 0.1     0.11 0.5 0.01  0.4  0.5 0.3    0.1  0.5 0.03  0.35 0.5 0.3    0.07 0.8 0.05 0.3  0.5 0.3    0.07 0.8 0.07  0.3  0.5 0.3    0.11 1   0.01  0.3  0.55 0.3;
%    0.11 0.5 0.005 0.4  0.5 0.1     0.11 0.5 0.07  0.45 0.5 0.3    0.07 0.8 0.094 0.28 0.5 0.3    0.05 0.8 0.04 0.3  0.5 0.3    0.07 0.8 0.08  0.35 0.5 0.3    0.07 1   0.05  0.32 0.45 0.2;
%    0.1  0.5 0.005 0.4  0.5 0.1     0.07 0.5 0.05  0.45 0.5 0.3    0.1  0.8 0.05  0.35 0.5 0.3    0.05 0.8 0.04 0.3  0.5 0.3    0.07 0.8 0.05  0.35 0.5 0.3    0.07 0.5 0.005 0.35 0.45 0.2;
%    0.07 0.3 0.06  0.4  0.5 0.1     0.05 0.5 0.01  0.45 0.5 0.3    0.1  0.5 0.05  0.35 0.5 0.3    0.07 0.8 0.04 0.3  0.5 0.3    0.07 0.5 0.09  0.3  0.5 0.3    0.07 0.5 0.005 0.35 0.45 0.2;
%    0.07 0.3 0.06  0.4  0.5 0.1     0.07 0.5 0.05  0.45 0.5 0.3    0.07 0.3 0.05  0.35 0.5 0.3    0.07 0.3 0.05 0.3  0.5 0.3    0.07 0.3 0.05  0.3  0.5 0.3    0.11 0.5 0.05  0.3  0.45 0.2;
%    0.11 0.5 0.05  0.4  0.5 0.1     0.07 0.5 0.04  0.4  0.5 0.3    0.09 0.5 0.05  0.35 0.5 0.3    0.07 0.3 0.05 0.3  0.5 0.3    0.07 0.5 0.05  0.3  0.5 0.3    0.11 0.5 0.05  0.3  0.45 0.2;
%    0.13 0.5 0.005 0.45 0.5 0.1     0.07 0.5 0.04  0.4  0.5 0.3    0.05 0.5 0.04  0.3  0.5 0.3    0.07 0.3 0.04 0.35 0.5 0.3    0.1  1   0.04  0.3  0.5 0.3    0.11 0.5 0.04  0.3  0.45 0.2;
%    0.13 0.5 0.005 0.45 0.5 0.1     0.05 0.5 0.05  0.45 0.5 0.3    0.05 0.5 0.04  0.36 0.5 0.3    0.07 0.5 0.04 0.38 0.5 0.3    0.05 1   0.062 0.3  0.5 0.3    0.1  0.5 0.04  0.35 0.45 0.2;
%    0.1  0.5 0.005 0.45 0.5 0.1     0.01 0.5 0.04  0.47 0.5 0.3    0.05 0.5 0.04  0.3  0.5 0.3    0.07 0.3 0.05 0.3  0.5 0.3    0.05 1   0.04  0.3  0.5 0.3    0.11 0.5 0.05  0.3  0.45 0.2;
%    0.1  0.5 0.02  0.4  0.5 0.1     0.07 0.5 0.05  0.47 0.5 0.3    0.05 0.3 0.05  0.3  0.5 0.3    0.07 0.3 0.05 0.25 0.5 0.3    0.05 1   0.065 0.3  0.5 0.3    0.11 0.5 0.04  0.2  0.45 0.2;
%    0.1  0.5 0.005 0.4  0.5 0.1     0.01 0.5 0.025 0.35 0.5 0.3    0.05 0.3 0.04  0.3  0.5 0.3    0.07 0.3 0.04 0.3  0.5 0.3    0.05 1   0.051 0.3  0.5 0.3    0.11 0.5 0.04  0.3  0.45 0.2;
%    0.12 0.5 0.005 0.4  0.5 0.1     0.01 0.3 0.04  0.35 0.5 0.3    0.1  0.3 0.04  0.3  0.5 0.3    0.07 0.3 0.07 0.25 0.5 0.3    0.05 1   0.055 0.3  0.5 0.3    0.11 0.5 0.04  0.3  0.45 0.2
%    ];
%% OBTAINING NOISE FROM ALL ACTIVITIES
noise=zeros(12,35989); %matrix which allows us to save noise from this activity, then 
          %we'll average it.
for i=1:12
    noise(i,(1:3750))=GetLPCNoise(DetrendedActivity1(i,:),Activity1(i,:),P(i,(1:4)),Fs);
    noise(i,(3751:11250))=GetLPCNoise(DetrendedActivity2(i,:),Activity2(i,:),P(i,(5:8)),Fs);
    noise(i,(11251:18750))=GetLPCNoise(DetrendedActivity3(i,:),Activity3(i,:),P(i,(9:12)),Fs);
    noise(i,(18751:26250))=GetLPCNoise(DetrendedActivity4(i,:),Activity4(i,:),P(i,(13:16)),Fs);
    noise(i,(26251:33750))=GetLPCNoise(DetrendedActivity5(i,:),Activity5(i,:),P(i,(17:20)),Fs);
    noise(i,(33751:35989))=GetLPCNoise(DetrendedActivity6(i,:),Activity6(i,:),P(i,(21:24)),Fs);
end

TotalNoise=mean(noise);
NoiseActivity1=TotalNoise(1:3750);
NoiseActivity2=TotalNoise(3751:11250);
NoiseActivity3=TotalNoise(11251:18750);
NoiseActivity4=TotalNoise(18751:26250);
NoiseActivity5=TotalNoise(26251:33750);
NoiseActivity6=TotalNoise(33751:end);

% Sectionally take off noise from each correspondent activity.
CleanedSignal1 = Activity1-NoiseActivity1;
CleanedSignal2 = Activity2-NoiseActivity2;
CleanedSignal3 = Activity3-NoiseActivity3;
CleanedSignal4 = Activity4-NoiseActivity4;
CleanedSignal5 = Activity5-NoiseActivity5;
CleanedSignal6 = Activity6-NoiseActivity6;

%% Initial Conditions
% Parameters for findpeaks Function
% MinPeakWidth
MinPeakWidthRest1 = 0.12;
MinPeakWidthRun_2 = 0.01;
MinPeakWidthRun_3 = 0.01;
MinPeakWidthRun_4 = 0.01;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.5;
MaxWidthRun3 = 0.3;
MaxWidthRun4 = 0.3;
MaxWidthRun5 = 1;
MaxWidthRest6 = 0.5;
% Prominence in PPG
ProminenceInRest = 0.005;
ProminenceRunning = 0.04;
%% INITIAL CONDITIONS FOR ECG
% Min Width in ECG
MinHeightECGRest1 = 0.35;
MinHeightECGRun2 = 0.35;
MinHeightECGRun3 = 0.25;
MinHeightECGRun4 = 0.35;
MinHeightECGRun5 = 0.35;
MinHeightECGRest6 = 0.3;
%Min Dist in ECG
minDistRest1 = 50;
minDistRun2 = 15;
minDistRun3 = 33;
minDistRun4 = 25;
minDistRun5 = 30;
minDistRest6 = 30;
% For ECG analysis, please update ECG name
ecgName = 'DATA_12_TYPE02.mat';
% K represents the number of realizations to extract error individually
k = 12;
%% W values according the realization: P(k,W)
% Realization 1: W = 4
W = 4;
findErrors(sNorm(k,:),Activity1(k,:),Activity2(k,:),Activity3(k,:),Activity4(k,:),Activity5(k,:),Activity6(k,:),...
    CleanedSignal1(k,:),CleanedSignal2(k,:),CleanedSignal3(k,:),CleanedSignal4(k,:),CleanedSignal5(k,:),CleanedSignal6(k,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest,ProminenceRunning, ecgName,MinHeightECGRest1,MinHeightECGRest6,...
    MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,minDistRest1,minDistRest6,...
    minDistRun2,minDistRun3,minDistRun4,minDistRun5,0.4)

% %% IN CASE YOU WANT TO VISUALIZE MEAN NOISE (USE t30s, t60s AND tfin AS X AXIS)
% figure(8)
% subplot(3,1,1),plot(t30s,NoiseActivity1),title('Ruido promedio en la actividad 1'),xlabel('Tiempo (seg)'),grid on,axis tight
% subplot(3,1,2),plot(t60s,NoiseActivity2),title('Ruido promedio en la actividad 2'),xlabel('Tiempo (seg)'), grid on,axis tight
% subplot(3,1,3),plot(tfin,NoiseActivity6),title('Ruido promedio en la actividad 6'),xlabel('Tiempo (seg)'), grid on,axis tight

% %% VISUALIZE ORIGINAL SIGNAL WITH THE NOISE SUBSTRACTED
% CleanedSignal2=Activity2(1,:)-NoiseActivity2;
% figure(9)
% subplot(2,1,1),plot(t60s,Activity2(1,:),t60s,NoiseActivity2),title('Senal original en la actividad 1')
% legend('Señal original','Ruido promedio'),xlabel('Tiempo (seg)'), grid on,axis tight
% subplot(2,1,2),plot(t60s,CleanedSignal2),title('Señal restando el ruido promedio')
% xlabel('Tiempo (seg)'),grid on, axis tight


%% APPROXIMATION 1: minimum PP interval
% 
% intPP=diff(LOCS1); % PP interval duration
% medintPP=mean(diff(LOCS1)); %Average PP interval duration
% fprintf('El intervalo PP promedio es %d ',medintPP);
% fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico \n',round(medintPP/2,1));
% samPP=round(intPP*Fs,0); % We obtain the durations of the peaks in samples number
% newlocs=LOCS1*Fs; %Positions of the peaks in samples number
% delay=round(round(medintPP/2,1)*Fs); %And delay time before the peak in samples number
% M=length(diff(newlocs));   % Found PP intervals
% offset=max(PKS1);     % To deploy PP peaks above the signal
% meanduration=round(medintPP*Fs,0);
% stack=zeros(M,min(samPP)); % Sets apart memory for storing the matrix M (cardiac cycles)
% qrs=zeros(M,2); % Sets apart memory for the PP peaks curve in 3D
% 
% for m=1:M
%     switch(m)
%         case 1
%             first=activity1(1,(1:newlocs(m)-delay+min(samPP)));
%             L=length(first);
%             stack(m,:)=[first zeros(1,min(samPP)-L)];
%             qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%         case M
%             if(length(activity1)-newlocs(m))>0
%                 stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+min(samPP)-delay-1));
%                 qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%             else
%                 stack(m,:)=activity1(1,(newlocs(m)-delay:end));
%                 qrs(m,:)=[delay+1 activity1(1,newlocs(m))];
%             end
%         otherwise
%             stack(m,:)=activity1(1,(newlocs(m)-delay:newlocs(m)+min(samPP)-delay-1));
%             % Stores a cardiac cycle, since 0.4*Fs seconds before PP peak
%             % until the duration, given by the minimum duration of all PP
%             % found intervals 
%             qrs(m,:)=[delay+1 activity1(1,newlocs(m))]; 
%             % Saves P peaks to deploy above 3D P peak
%     end     
% end
% 
% figure(8)
% [X,Y] = meshgrid(1:min(samPP),1:M); % Generates a mesh in x-y for drawing the 3D surface
% surf(Y,X,stack);hold on;grid on; % Draws all cycles in 3D
% shading interp
% % Draws the curve of PP peaks above 3D PPG
% plot3(1:M,qrs(:,1),qrs(:,2)+offset,'go-','MarkerFaceColor','g')
% view(120, 30);%vision of the signal in 120 degrees
% 
% % Obtencion de la onda PPG promedio
% 
% ppg_prom = mean(stack);
% figure(9)
% plot((0:length(stack)-1)/Fs,ppg_prom);
