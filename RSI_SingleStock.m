clear all;
close all;

%% Initualize Variable
%define moving intervel
Interval=10;
%initual money 
Initual_Value=3000000; 
%% Import intual data

Data_2015=xlsread('SP500_2015.csv',1,'G:G');
Data_2015=fliplr(Data_2015);
%Alibaba
BaBa_2015=xlsread('BaBa_2015.csv',1,'G:G');
BaBa_2015=fliplr(BaBa_2015);%reverse order start from day one
%IBM
IBM_2015=xlsread('IBM_2015.csv',1,'G:G');
IBM_2015=fliplr(IBM_2015);%reverse order start from day one
%Tesla
TSLA_2015=xlsread('TSLA_2015.csv',1,'G:G');
TSLA_2015=fliplr(TSLA_2015);%reverse order start from day one

%% RSI
Day_count=numel(BaBa_2015);
Period=floor(Day_count/Interval);
RSI_BaBa=zeros(Period,1);
RSI_IBM=zeros(Period,1);
RSI_TSLA=zeros(Period,1);

temp_BaBa=zeros(Interval,1);
temp_IBM=zeros(Interval,1);
temp_TLSA=zeros(Interval,1);

for count=1:Interval:Period*Interval
    temp_BaBa=BaBa_2015(count:count+Interval-1);
    temp_IBM=IBM_2015(count:count+Interval-1);
    temp_TSLA=TSLA_2015(count:count+Interval-1);
    RSI_BaBa((count-1)/Interval+1)=RSI(temp_BaBa);
    RSI_IBM((count-1)/Interval+1)=RSI(temp_IBM);
    RSI_TSLA((count-1)/Interval+1)=RSI(temp_TSLA);
end


%% plot

figure 
plot(RSI_BaBa)
hold on
plot(RSI_IBM)
hold on
plot(RSI_TSLA)
hold off
legend('show','Alibaba','IBM','TSLA')
xlabel('Period')
ylabel('RSI Value')
