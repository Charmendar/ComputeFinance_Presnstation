clear all;
close all;

%single moving average
%Reference: http://www.investopedia.com/terms/s/sma.asp

%% Initualize Variable
%define moving intervel
Interval_Short=10;
Interval_Long=30;
%% Import intual data

%sp500
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

Day_count=numel(BaBa_2015);
%% SMA
for day_index=1:Day_count
    if day_index<=Interval_Short
    SMA_BaBa_S(day_index)=BaBa_2015(day_index);
    SMA_IBM_S(day_index)=IBM_2015(day_index);
    SMA_TSLA_S(day_index)=TSLA_2015(day_index);
    else
    SMA_BaBa_S(day_index)=sum(BaBa_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    SMA_IBM_S(day_index)=sum(IBM_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    SMA_TSLA_S(day_index)=sum(TSLA_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    end
end


%% SMA
%Short term SMA
SMA_BaBa_S=zeros(Day_count,1);
SMA_IBM_S=zeros(Day_count,1);
SMA_TSLA_S=zeros(Day_count,1);
%Long term
SMA_BaBa_L=zeros(Day_count,1);
SMA_IBM_L=zeros(Day_count,1);
SMA_TSLA_L=zeros(Day_count,1);

for day_index=1:Day_count
    if day_index<=Interval_Short
    SMA_BaBa_S(day_index)=BaBa_2015(day_index);
    SMA_IBM_S(day_index)=IBM_2015(day_index);
    SMA_TSLA_S(day_index)=TSLA_2015(day_index);
    else
    SMA_BaBa_S(day_index)=sum(BaBa_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    SMA_IBM_S(day_index)=sum(IBM_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    SMA_TSLA_S(day_index)=sum(TSLA_2015(day_index-Interval_Short:day_index-1))/Interval_Short;
    end
end

%long term SMA
for day_index=1:Day_count
    if day_index<=Interval_Long
    SMA_BaBa_L(day_index)=BaBa_2015(day_index);
    SMA_IBM_L(day_index)=IBM_2015(day_index);
    SMA_TSLA_L(day_index)=TSLA_2015(day_index);
    else
    SMA_BaBa_L(day_index)=sum(BaBa_2015(day_index-Interval_Long:day_index-1))/Interval_Long;
    SMA_IBM_L(day_index)=sum(IBM_2015(day_index-Interval_Long:day_index-1))/Interval_Long;
    SMA_TSLA_L(day_index)=sum(TSLA_2015(day_index-Interval_Long:day_index-1))/Interval_Long;
    end
end

%% Plot

%IBM
figure
plot(SMA_IBM_S)
hold on
plot(SMA_IBM_L)
hold on
plot(IBM_2015)
hold off
legend('show','Short-term SMA','Long-term SMA','Real Price')
% legend('show','Long-term SMA','Real Price')
xlabel('Days')
ylabel('Price(dollars)')
title('IBM Year 2015')

% % commment the following for a single stock illustration
% figure
% plot(SMA_BaBa_S)
% hold on
% plot(SMA_BaBa_L)
% hold on
% plot(BaBa_2015)
% hold off
% legend('show','Shor-term SMA','Long-term SMA','Real Price')
% xlabel('Days')
% ylabel('Price(dollars)')
% title('Alibaba Year 2015')
% 
% %TSLA
% figure
% plot(SMA_TSLA_S)
% hold on
% plot(SMA_TSLA_L)
% hold on
% plot(TSLA_2015)
% hold off
% legend('show','Shor-term SMA','Long-term SMA','Real Price')
% xlabel('Days')
% ylabel('Price(dollars)')
% title('TSLA Year 2015')