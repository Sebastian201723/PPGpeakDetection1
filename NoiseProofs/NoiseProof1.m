clear all
close all
clc
%% ARTIFITIAL NOISE DESIGN 

% This code intends to proof the viability of the obtained noise from the
% substraction of the signal minus the Savitzky-golay's filter through the
% function findpeaks as demonstrated below
% Activities type 1 from type 2 differ only from the 2nd activities ahead,
% where the set speeds for the trendmill in activities type2 are under 6
% and 12 km/h:
% 1. Rest (30s)
% 2. Running 8km/h (1min) corresponds to 6 km/h in activity type 2
% 3. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 4. Running 8km/h (1min)  corresponds to 6 km/h in activity type 2
% 5. Running 15km/h (1min) corresponds to 12 km/h in activity type 2
% 6. Rest (30 min)

% Initial Conditions

k=0;
prom=0;
sm0=0;
sm1=0;
sm2=0;
sm3=0;
sm4=0;
sm5=0;

% Lecture of datasets
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        TamRealizaciones(k) = length(a.sig);
    end
end


for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    else       
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        s(k,:) =  GetSavitzkyNoise(char(word),2,1,3750);
        s1(k,:) =  GetSavitzkyNoise(char(word),2,3751,11250);
        s2(k,:) =  GetSavitzkyNoise(char(word),2,11251,18750);
        s3(k,:) =  GetSavitzkyNoise(char(word),2,18751,26250);
        s4(k,:) =  GetSavitzkyNoise(char(word),2,26251,33750);        
        s5(k,:) =  GetSavitzkyNoise(char(word),2,33751,min(TamRealizaciones));
    end
    % Sample mean
    sm0 = sm0 + s(k,:);
    sm1 = sm1 + s1(k,:);
    sm2 = sm2 + s2(k,:);
    sm3 = sm3 + s3(k,:);
    sm4 = sm4 + s4(k,:);
    sm5 = sm5 + s5(k,:);

end

%% SAMPLE MEAN
% Noise is organized in a single matrix M with size 6x7500, where the rows
% represent the type of activity and the columns represent the samples of
% each dataset. For the signals in the samples 0-3750 (30s activity), 3750
% zeros are added in order to fit the matrix with the right dimen.

M=[sm0 zeros(1,3750); sm1; sm2; sm3; sm4; sm5 zeros(1,7500-length(sm5))];
Realizaciones = 12;

% As a vertical mean has been done, so the sampled mean has also been done and
% therefore this procedure is equivalent to use the function mean

Media0 = M./Realizaciones;

% Re-set the sampled mean on a single line linking the 6 activity signals
% one with the next.

v=[Media0(1,:) Media0(2,:) Media0(3,:) Media0(4,:) Media0(5,:) Media0(6,:)];

% Delete extra zeros.

mediamuestral=nonzeros(v);
mediamuestral=mediamuestral';

%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% Random sample signal: 
ppg = load('DATA_10_TYPE02.mat');
ppgSig = ppg.sig;
ppgFullSignal = ppgSig(2,(1:length(mediamuestral)));% match sizes 
% Sample Frequency
Fs = 125;
% Normalize with min-max method
ppgFullSignal = (ppgFullSignal-128)./255;
ppgFullSignal = (ppgFullSignal-min(ppgFullSignal))./(max(ppgFullSignal)-min(ppgFullSignal));
t = (0:length(ppgFullSignal)-1);   
% Separate noise with its correspondent activity.
ruido1 = mediamuestral(1,(1:3750));
ruido2 = mediamuestral(1,(3751:11250));
ruido3 = mediamuestral(1,(11251:18750));
ruido4 = mediamuestral(1,(18751:26250));
ruido5 = mediamuestral(1,(26251:33750));
ruido6 = mediamuestral(1,(33751:min(TamRealizaciones)));

% Sectionally take off noise from each correspondent activity.
CleanedSignal1 = ppgFullSignal(1,(1:3750))-ruido1;
CleanedSignal2 = ppgFullSignal(1,(3751:11250))-ruido2;
CleanedSignal3 = ppgFullSignal(1,(11251:18750))-ruido3;
CleanedSignal4 = ppgFullSignal(1,(18751:26250))-ruido4;
CleanedSignal5 = ppgFullSignal(1,(26251:33750))-ruido5;
CleanedSignal6 = ppgFullSignal(1,(33751:min(TamRealizaciones)))-ruido6;

% 1. ORIGINAL en reposo vs sin ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),Fs,0.11,0.5,0.05);
[PKS1ruido,LOCS1ruido] = GetPeakPoints(CleanedSignal1,Fs,0.11,0.5,0.05);
% 2. CORRIENDO 1min se�al original vs sin ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),Fs,0.11,0.5,0.15);
[PKS2ruido,LOCS2ruido] = GetPeakPoints(CleanedSignal2,Fs,0.11,0.5,0.15);
% 3. CORRIENDO 1min se�al original vs sin ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),Fs,0.11,0.5,0.15);
[PKS3ruido,LOCS3ruido] = GetPeakPoints(CleanedSignal3,Fs,0.11,0.5,0.15);
% 4. CORRIENDO 1min se�al original vs sin ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),Fs,0.11,0.5,0.15);
[PKS4ruido,LOCS4ruido] = GetPeakPoints(CleanedSignal4,Fs,0.11,0.5,0.15);
% 5. CORRIENDO 1min se�al original vs sin ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),Fs,0.11,1,0.15);
[PKS5ruido,LOCS5ruido] = GetPeakPoints(CleanedSignal5,Fs,0.11,1,0.15);
% 6. REST 30s se�al original vs sin ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(ppgFullSignal(1,(33751:end)),Fs,0.11,0.5,0.05);
[PKS6ruido,LOCS6ruido] = GetPeakPoints(CleanedSignal6,Fs,0.11,0.5,0.05);
%% Error using HeartBeats from findpeaks
ErrorFindP1 = 100*abs(size(LOCS1ruido(1,:))-size(LOCS1Original(1,:)))./size(LOCS1Original(1,:));
ErrorFindP2 = 100*abs(size(LOCS2ruido(1,:))-size(LOCS2Original(1,:)))./size(LOCS2Original(1,:));
ErrorFindP3 = 100*abs(size(LOCS3ruido(1,:))-size(LOCS3Original(1,:)))./size(LOCS3Original(1,:));
ErrorFindP4 = 100*abs(size(LOCS4ruido(1,:))-size(LOCS4Original(1,:)))./size(LOCS4Original(1,:));
ErrorFindP5 = 100*abs(size(LOCS5ruido(1,:))-size(LOCS5Original(1,:)))./size(LOCS5Original(1,:));
ErrorFindP6 = 100*abs(size(LOCS6ruido(1,:))-size(LOCS6Original(1,:)))./size(LOCS6Original(1,:));
ErrorFromFindPeaks = [ErrorFindP1(2) ErrorFindP2(2) ErrorFindP3(2) ErrorFindP4(2) ErrorFindP5(2) ErrorFindP6(2)];
%% Error from BPM 
% bpm stores the bpm in the matrix 6x12, where 1-6 represents the type of
% activity and 1-12 represents the number of realizations. Since the bpm is
% taken from 8 windows size and is overlapping every 6s, there are 2
% effective seconds and therefore, the activity 1 (Rest per 30s)
% corresponds to 15 effective seconds
bpm = CompareBPM();
realizacion = 10;
% Separate peaks from findpeaks detection 
FindPeaks1 = size(LOCS1ruido(1,:));
FindPeaks2 = size(LOCS2ruido(1,:));
FindPeaks3 = size(LOCS3ruido(1,:));
FindPeaks4 = size(LOCS4ruido(1,:));
FindPeaks5 = size(LOCS5ruido(1,:));
FindPeaks6 = size(LOCS6ruido(1,:));
%% For computational reasons, we separate the 30s-activities
bpm1 = bpm(1,realizacion)./2;
bpm6 = bpm(6,realizacion)./2;

%%
EBPM1 = 100*abs(FindPeaks1(2)-bpm1)./bpm1;
EBPM2 = 100*abs(FindPeaks2(2)-bpm(2,realizacion))./bpm(2,realizacion);
EBPM3 = 100*abs(FindPeaks3(2)-bpm(3,realizacion))./bpm(3,realizacion);
EBPM4 = 100*abs(FindPeaks4(2)-bpm(4,realizacion))./bpm(4,realizacion);
EBPM5 = 100*abs(FindPeaks5(2)-bpm(5,realizacion))./bpm(5,realizacion);
EBPM6 = 100*abs(FindPeaks6(2)-bpm6)./bpm6;
ErrorFromBPM = [EBPM1 EBPM2 EBPM3 EBPM4 EBPM5 EBPM6];


%% PROOF 2: ECG peaks detection
% Random sample signal: 
ecg = load('DATA_10_TYPE02.mat');
ecgSig = ecg.sig;
ecgFullSignal = ecgSig(1,(1:length(mediamuestral)));% match sizes 
% Sample Frequency
Fs = 125;
% Normalize with min-max method
ecgFullSignal = (ecgFullSignal-128)./255;
ecgFullSignal = (ecgFullSignal-min(ecgFullSignal))./(max(ecgFullSignal)-min(ecgFullSignal));
% Squared signal to 
ecgF = abs(ecgFullSignal).^2;
t = (0:length(ecgFullSignal)-1);   

[ECG1Peaks,ECG1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),0.35,0.150);
[ECG2Peaks,ECG2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),0.35,0.150);
[ECG3Peaks,ECG3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),0.35,0.150);
[ECG4Peaks,ECG4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),0.35,0.150);
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),0.35,0.150);
[ECG6Peaks,ECG6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),0.35,0.150);

peaksECG1 = size(ECG1Peaks(1,:));
peaksECG2 = size(ECG2Peaks(1,:));
peaksECG3 = size(ECG3Peaks(1,:));
peaksECG4 = size(ECG4Peaks(1,:));
peaksECG5 = size(ECG5Peaks(1,:));
peaksECG6 = size(ECG6Peaks(1,:));

ECGERROR1 = 100*abs(FindPeaks1(2)-peaksECG1(2))./peaksECG1(2);
ECGERROR2 = 100*abs(FindPeaks2(2)-peaksECG2(2))./peaksECG2(2);
ECGERROR3 = 100*abs(FindPeaks3(2)-peaksECG3(2))./peaksECG3(2);
ECGERROR4 = 100*abs(FindPeaks4(2)-peaksECG4(2))./peaksECG4(2);
ECGERROR5 = 100*abs(FindPeaks5(2)-peaksECG5(2))./peaksECG5(2);
ECGERROR6 = 100*abs(FindPeaks6(2)-peaksECG6(2))./peaksECG6(2);

ErrorFromECG = [ECGERROR1 ECGERROR2 ECGERROR3 ECGERROR4 ECGERROR5 ECGERROR6];

%% Proof 3: Savitzky noise is added to ECG signal. Why? Yes because


% Sectionally take off noise from each correspondent activity.
ECGCleanedSignal1 = ecgFullSignal(1,(1:3750))-ruido1;
ECGCleanedSignal2 = ecgFullSignal(1,(3751:11250))-ruido2;
ECGCleanedSignal3 = ecgFullSignal(1,(11251:18750))-ruido3;
ECGCleanedSignal4 = ecgFullSignal(1,(18751:26250))-ruido4;
ECGCleanedSignal5 = ecgFullSignal(1,(26251:33750))-ruido5;
ECGCleanedSignal6 = ecgFullSignal(1,(33751:min(TamRealizaciones)))-ruido6;

% Square ECG signal for easiest peaks detection
ECGCleanedSignal1 = abs(ECGCleanedSignal1).^2;
ECGCleanedSignal2 = abs(ECGCleanedSignal2).^2;
ECGCleanedSignal3 = abs(ECGCleanedSignal3).^2;
ECGCleanedSignal4 = abs(ECGCleanedSignal4).^2;
ECGCleanedSignal5 = abs(ECGCleanedSignal5).^2;
ECGCleanedSignal6 = abs(ECGCleanedSignal6).^2;

%% Signal to be tested

[ecgS1Peaks,e1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),0.35,0.150);
[ecgS2Peaks,e2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),0.35,0.150);
[ecgS3Peaks,e3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),0.35,0.150);
[ecgS4Peaks,e4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),0.35,0.150);
[ecgS5Peaks,e5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),0.35,0.150);
[ecgS6Peaks,e6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),0.35,0.150);

% Cleaned Signal with Savitzky noise
[e1Peaks,ecg1Locs] = GetECGPeakPoints(ECGCleanedSignal1,0.09,0.150);
[e2Peaks,ecg2Locs] = GetECGPeakPoints(ECGCleanedSignal2,0.09,0.150);
[e3Peaks,ecg3Locs] = GetECGPeakPoints(ECGCleanedSignal3,0.09,0.150);
[e4Peaks,ecg4Locs] = GetECGPeakPoints(ECGCleanedSignal4,0.09,0.150);
[e5Peaks,ecg5Locs] = GetECGPeakPoints(ECGCleanedSignal5,0.09,0.150);
[e6Peaks,ecg6Locs] = GetECGPeakPoints(ECGCleanedSignal6,0.09,0.150);

%% Error using HeartBeats from findpeaks
ErrorECGFindP1 = 100*abs(size(e1Peaks(1,:))-size(ecgS1Peaks(1,:)))./size(ecgS1Peaks(1,:));
ErrorECGFindP2 = 100*abs(size(e2Peaks(1,:))-size(ecgS2Peaks(1,:)))./size(ecgS2Peaks(1,:));
ErrorECGFindP3 = 100*abs(size(e3Peaks(1,:))-size(ecgS3Peaks(1,:)))./size(ecgS3Peaks(1,:));
ErrorECGFindP4 = 100*abs(size(e4Peaks(1,:))-size(ecgS4Peaks(1,:)))./size(ecgS4Peaks(1,:));
ErrorECGFindP5 = 100*abs(size(e5Peaks(1,:))-size(ecgS5Peaks(1,:)))./size(ecgS5Peaks(1,:));
ErrorECGFindP6 = 100*abs(size(e6Peaks(1,:))-size(ecgS6Peaks(1,:)))./size(ecgS6Peaks(1,:));
ErrorECGFromFindPeaksInECG = [ErrorECGFindP1(2) ErrorECGFindP2(2) ErrorECGFindP3(2) ErrorECGFindP4(2) ErrorECGFindP5(2) ErrorECGFindP6(2)];
