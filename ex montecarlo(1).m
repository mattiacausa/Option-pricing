%% 
% Dati opzione

Rf=0
sigma = 0.12
startPrice = 100
K = 100
T = 200
Delta = T/5 %lunghezza del passo
year = 252
t= Delta/year
u=exp(sigma*sqrt(t))
d=exp(-sigma*sqrt(t))
q=0.02
%% 
% provo prima bls price

[call,put]=blsprice(100,K,0,200/252,sigma)
%% 
% prezzo azioni con simulazione

ExpReturn = [Rf];
Sigmas = [sigma^2];
correlation=[sigma^2]
ExpCovariance = sigma^2
NumObs=200;
NumSim= 10000;
RetIntervals=1/252;
rng('default');  
RetExpected = portsim(ExpReturn, ExpCovariance, NumObs,RetIntervals, NumSim, 'Expected');
ExpSimulation=squeeze(RetExpected);
%% 
% trovo i prezzi azionari

clear StockPrices
clear TickTimes
clear TickSeries
StockPrices= ret2tick(ExpSimulation,repmat(startPrice,1,NumSim))
%% 
% istogramma

[count, BinCenter] = hist(StockPrices(end,:), 30);
figure(1)
bar(BinCenter, count/sum(count), 1, 'r')
xlabel('Terminal Stock Price')
ylabel('Probability')
title('Lognormal Terminal Stock Prices')
%% 
% grafico

plot(StockPrices, '-b')
ylabel('Portfolio Prices')
title('Expected Method')
%% 
% pricing call

term=StockPrices(201,:)';
payoff=(term-100);
payoff(payoff < 0) = 0
callmontecarlo=mean(payoff)/(1+Rf)
%% 
% pricing put

payoff1=(100-term);
payoff1(payoff1 < 0) = 0
putmontecarlo=mean(payoff1)/(1+Rf)
%% 
%