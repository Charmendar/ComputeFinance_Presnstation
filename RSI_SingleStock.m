clear;
close all;

%% Initialize Variable
%define RSI intervel
Interval=10;

%% Import intial data

%IBM
IBM_2016=xlsread('IBM_2016.csv',1,'G:G');
IBM_2016=fliplr(IBM_2016);%reverse order start from day one

%% RSI
Day_count=numel(IBM_2016);
Period=floor(Day_count/Interval);
RSI_IBM=zeros(Day_count,1);

temp_IBM=zeros(Day_count,1);
buy_dates = [];
buy_prices = [];
buy_rsi = [];
sell_dates = [];
sell_prices = [];
sell_rsi = [];

for count=Interval+2:Day_count
    temp_IBM=IBM_2016(count-Interval-1:count-1);
    RSI_IBM(count)=RSI(temp_IBM);
    if count > 1 && RSI_IBM(count-1) > 30 && RSI_IBM(count) <= 30
        buy_dates = [buy_dates count];
        buy_prices = [buy_prices IBM_2016(count)];
        buy_rsi = [buy_rsi RSI_IBM(count)];
    elseif count > 1 && RSI_IBM(count-1) < 70 && RSI_IBM(count) >= 70
        sell_dates = [sell_dates count];
        sell_prices = [sell_prices IBM_2016(count)];
        sell_rsi = [sell_rsi RSI_IBM(count)];
    end
end

%% plot

figure(1)
plot(1:Day_count, IBM_2016, 'b', ...
    buy_dates, buy_prices, 'g*', ...
    sell_dates, sell_prices, 'r*');
legend('IBM price', 'buy', 'sell');
xlim([0, Day_count]);
xlabel('Time')
ylabel('Price')

figure(2)
plot(1:Day_count, RSI_IBM, 'b', ...
    buy_dates, buy_rsi, 'g*', ...
    sell_dates, sell_rsi, 'r*')
legend('show','IBM RSI', 'buy', 'sell')
xlim([Interval, Day_count]);
xlabel('Time')
ylabel('RSI Value')
