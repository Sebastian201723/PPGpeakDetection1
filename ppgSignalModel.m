%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% MODELO DE PULSO PPG %%%%%%%%%%%%%%%%%%
<<<<<<< HEAD
% Sumatoria de una Funci�n LogNormal y una Gaussiana
% Valores por defecto de una funci�n PPG com�n
=======
% Sumatoria de una Función LogNormal y una Gaussiana
% Valores por defecto de una función PPG común
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
% Sigma = 0.4;
% mu = 2.5;
% AmplitudGaussiana = 0.12;
% Sigma2 = 1;
% mu2 = 0.7;
% AmplLogNormal = 1.23;
<<<<<<< HEAD
%Ampl total = 1
function PPGSignal1 = ppgSignalModel(amplitud,mu2,mu,Sigma,Sigma2,AmplLogNormal,AmplitudGaussiana,xi,xf,w)
%% Funci�n Gaussiana
figure(1)
a = AmplitudGaussiana/sqrt(2*pi*Sigma.^2);
 x = xi:0.1:xf;
% x = linspace(xi,xf,200);
g = ((x-w-mu)/Sigma).^2;
f = a*exp(-0.5*g);

%% Funci�n LogNormal
=======
function PPGSignal1 = ppgSignalModel(mu,mu2,Sigma,Sigma2,AmplLogNormal,AmplitudGaussiana,xi,xf)
%% Función Gaussiana
figure(1)
a = AmplitudGaussiana/sqrt(2*pi*Sigma.^2);
% x = 0:0.1:10;
x = linspace(xi,xf,100);
g = ((x-mu)/Sigma).^2;
f = a*exp(-0.5*g);

%% Función LogNormal
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
% Y = lognpdf(X,mu,sigma) returns values at X of the 
% lognormal pdf with distribution parameters mu and 
% sigma. mu and sigma are the mean and standard deviation,
% respectively, of the associated normal distribution
% a1 = x1.*sqrt(2*pi*c1.^2);
<<<<<<< HEAD
% g1 = ((log(x1)-b1)/2*c1).^2;
% f1 = a1*exp(-0.5*g1);
% plot(f1)
% % Amplitud LogNormal
 y2 = AmplLogNormal.*lognpdf(x-w,mu2,Sigma2);
 PPGSignal1 = amplitud.*(y2+f);
 plot(PPGSignal1+0.4), grid on, hold on
end
 
=======
% g1 = log(((x1-b1)/2*c1).^2);2% f1 = a1*exp(-0.5*g1);
% plot(f1)
% % Amplitud LogNormal
 y2 = AmplLogNormal.*lognpdf(x,mu2,Sigma2);

 PPGSignal1 = y2+f;
 plot(PPGSignal1), grid on
end
>>>>>>> 4751b791c4c11d23a5c5d2ea3a127d92c97dd5cf
