clear all;
close all;

%% Initialize Variable
%define moving interval
Interval=10;
%initial money 
Initial_Value=3000000; 
%% Import intial data

Data_2016=xlsread('SP500_2016.csv',1,'G:G');
Data_2016=fliplr(Data_2016);
%AliBABA
BABA_2016=xlsread('BABA_2016.csv',1,'G:G');
BABA_2016=fliplr(BABA_2016);%reverse order start from day one
%IBM
IBM_2016=xlsread('IBM_2016.csv',1,'G:G');
IBM_2016=fliplr(IBM_2016);%reverse order start from day one
%Tesla
TSLA_2016=xlsread('TSLA_2016.csv',1,'G:G');
TSLA_2016=fliplr(TSLA_2016);%reverse order start from day one

%first 10 days are IDLE period, using equal weight and first estimate starts at Day 11
Day_count=numel(BABA_2016);
RSI_BABA=zeros(Day_count,1);
RSI_IBM=zeros(Day_count,1);
RSI_TSLA=zeros(Day_count,1);

for day_index=Interval+1:Day_count
    if rem(day_index, Interval) == 1
        % RSI calculation        
        temp_BABA=BABA_2016(day_index-Interval:day_index-1);
        temp_IBM=IBM_2016(day_index-Interval:day_index-1);
        temp_TSLA=TSLA_2016(day_index-Interval:day_index-1);
        RSI_BABA(day_index)=RSI(temp_BABA);
        RSI_IBM(day_index)=RSI(temp_IBM);
        RSI_TSLA(day_index)=RSI(temp_TSLA);
    end
end

%porfolio array
weight_BABA=zeros(Day_count,1);
weight_IBM=zeros(Day_count,1);
weight_TSLA=zeros(Day_count,1);

weight_BABA(1:Interval)=1/3;
weight_IBM(1:Interval)=1/3;
weight_TSLA(1:Interval)=1/3;


Total_Value=zeros(Day_count,1);
Total_Value_eq=zeros(Day_count,1);
Total_Value_SP500=zeros(Day_count,1);

Share_BABA=(Initial_Value/3)/BABA_2016(1);
Share_IBM=(Initial_Value/3)/IBM_2016(1);
Share_TSLA=(Initial_Value/3)/TSLA_2016(1);

Share_BABA_eq=(Initial_Value/3)/BABA_2016(1);
Share_IBM_eq=(Initial_Value/3)/IBM_2016(1);
Share_TSLA_eq=(Initial_Value/3)/TSLA_2016(1);

Share_SP500=Initial_Value/Data_2016(1);
for day_index=1:Day_count
    Total_Value(day_index)=BABA_2016(day_index)*Share_BABA+IBM_2016(day_index)*Share_IBM+TSLA_2016(day_index)*Share_TSLA;
    Total_Value_eq(day_index)=BABA_2016(day_index)*Share_BABA_eq+IBM_2016(day_index)*Share_IBM_eq+TSLA_2016(day_index)*Share_TSLA_eq;
    Total_Value_SP500(day_index)=Share_SP500*Data_2016(day_index);
    if day_index>Interval
        if rem(day_index, Interval) == 1
            %Start Rebalance Porfolio
            options=optimset('Display', 'off');
            X=linprog([RSI_BABA(day_index),RSI_IBM(day_index),RSI_TSLA(day_index)],[],[],[1, 1, 1],1,[0,0,0],[1,1,1], [], options);
            weight_BABA(day_index)=X(1);
            weight_IBM(day_index)=X(2);
            weight_TSLA(day_index)=X(3); 
         else
            weight_BABA(day_index)= weight_BABA(day_index-1);
            weight_IBM(day_index)= weight_IBM(day_index-1);
            weight_TSLA(day_index)=weight_TSLA(day_index-1);
        end
    end
    Share_BABA=Total_Value(day_index)*weight_BABA(day_index)/BABA_2016(day_index);
    Share_IBM=Total_Value(day_index)*weight_IBM(day_index)/IBM_2016(day_index);
    Share_TSLA=Total_Value(day_index)*weight_TSLA(day_index)/TSLA_2016(day_index);
    
    Share_BABA_eq=Total_Value_eq(day_index)*(1/3)/BABA_2016(day_index);
    Share_IBM_eq=Total_Value_eq(day_index)*(1/3)/IBM_2016(day_index);
    Share_TSLA_eq=Total_Value_eq(day_index)*(1/3)/TSLA_2016(day_index);
    
end


%% plot

%plot total value
figure
plot(Total_Value)
hold on
plot(Total_Value_eq)
hold on
plot(Total_Value_SP500)
hold off
legend('show','RSI minimization','equal weight','SP500')
xlabel('Days')
ylabel('Total Value (dollars)')

% figure
% plot(BABA_2016)
% hold on
% plot(IBM_2016)
% hold on 
% plot(TSLA_2016)
% hold off
% legend('show','BABA','IBM','TSLA')
% xlabel('Days')
% ylabel('Price (dollars)')

% figure
% plot(weight_BABA)
% hold on 
% plot(weight_IBM)
% hold on
% plot(weight_TSLA)
% hold off
% legend('show','AliBABA','IBM','Tesla')
% xlabel('Days')
% ylabel('share')