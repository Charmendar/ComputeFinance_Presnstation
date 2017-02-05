clear all;
close all;

%single moving average
%Reference: http://www.investopedia.com/terms/s/sma.asp

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

%% SMA section
%first 10 days are IDLE period, using equal weight and first estimate starts at Day 11
Day_count=numel(BaBa_2015);
RSI_BaBa=zeros(Day_count,1);
RSI_IBM=zeros(Day_count,1);
RSI_TSLA=zeros(Day_count,1);

%predict price
for day_index=1:Day_count
    if day_index<=Interval
    % need further look into
    RSI_BaBa(day_index)=0;
    RSI_IBM(day_index)=0;
    RSI_TSLA(day_index)=0;
    else
    % RSI calculation        
    Norm_BaBa=0;
    Norm_IBM=0;
    Norm_TSLA=0;
    Denorm_BaBa=0;
    Denorm_IBM=0;
    Denorm_TSLA=0;
    for i=0:Interval-1
        if BaBa_2015(day_index-i)>BaBa_2015(day_index-i-1)
            Norm_BaBa=Norm_BaBa+BaBa_2015(day_index-i)-BaBa_2015(day_index-i-1);
        end
        Denorm_BaBa=Denorm_BaBa+abs(BaBa_2015(day_index-i)-BaBa_2015(day_index-i-1));
        
        if IBM_2015(day_index-i)>IBM_2015(day_index-i-1)
            Norm_IBM=Norm_IBM+IBM_2015(day_index-i)-IBM_2015(day_index-i-1);
        end
        Denorm_IBM=Denorm_IBM+abs(IBM_2015(day_index-i)-IBM_2015(day_index-i-1));
        
        
        if TSLA_2015(day_index-i)>TSLA_2015(day_index-i-1)
            Norm_TSLA=Norm_TSLA+TSLA_2015(day_index-i)-TSLA_2015(day_index-i-1);
        end
        Denorm_TSLA=Denorm_TSLA+abs(TSLA_2015(day_index-i)-TSLA_2015(day_index-i-1));  
    end
        
    RSI_BaBa(day_index)=Norm_BaBa*100/Denorm_BaBa;
    RSI_IBM(day_index)=Norm_IBM*100/Denorm_IBM;
    RSI_TSLA(day_index)=Norm_TSLA*100/Denorm_TSLA;
    end
end

%porfolio array
weight_BaBa=zeros(Day_count,1);
weight_IBM=zeros(Day_count,1);
weight_TSLA=zeros(Day_count,1);
Total_Value=zeros(Day_count,1);
Total_Value_eq=zeros(Day_count,1);
Total_Value_SP500=zeros(Day_count,1);

Share_BaBa=(Initual_Value/3)/BaBa_2015(1);
Share_IBM=(Initual_Value/3)/IBM_2015(1);
Share_TSLA=(Initual_Value/3)/TSLA_2015(1);

Share_BaBa_eq=(Initual_Value/3)/BaBa_2015(1);
Share_IBM_eq=(Initual_Value/3)/IBM_2015(1);
Share_TSLA_eq=(Initual_Value/3)/TSLA_2015(1);

Share_SP500=Initual_Value/Data_2015(1);
for day_index=1:Day_count
    Total_Value(day_index)=BaBa_2015(day_index)*Share_BaBa+IBM_2015(day_index)*Share_IBM+TSLA_2015(day_index)*Share_TSLA;
    Total_Value_eq(day_index)=BaBa_2015(day_index)*Share_BaBa_eq+IBM_2015(day_index)*Share_IBM_eq+TSLA_2015(day_index)*Share_TSLA_eq;
    Total_Value_SP500(day_index)=Share_SP500*Data_2015(day_index);
    if day_index<=Interval
        weight_BaBa(day_index)=1/3;
        weight_IBM(day_index)=1/3;
        weight_TSLA(day_index)=1/3;
    else
        %Start Rebalance Porfolio
        X=linprog([RSI_BaBa(day_index),RSI_IBM(day_index),RSI_TSLA(day_index)],[],[],[1, 1, 1],1,[0,0,0],[1,1,1] );
        weight_BaBa(day_index)=X(1);
        weight_IBM(day_index)=X(2);
        weight_TSLA(day_index)=X(3);      
    end
    Share_BaBa=Total_Value(day_index)*weight_BaBa(day_index)/BaBa_2015(day_index);
    Share_IBM=Total_Value(day_index)*weight_IBM(day_index)/IBM_2015(day_index);
    Share_TSLA=Total_Value(day_index)*weight_TSLA(day_index)/TSLA_2015(day_index);
    
    Share_BaBa_eq=Total_Value_eq(day_index)*(1/3)/BaBa_2015(day_index);
    Share_IBM_eq=Total_Value_eq(day_index)*(1/3)/IBM_2015(day_index);
    Share_TSLA_eq=Total_Value_eq(day_index)*(1/3)/TSLA_2015(day_index);
   
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
legend('show','Portfolio','equal weight','SP500')
xlabel('Days')
ylabel('Total Value(dollars)')

figure
plot(BaBa_2015)
hold on
plot(IBM_2015)
hold on 
plot(TSLA_2015)
hold off
legend('show','BaBa','IBM','TSLA')
xlabel('Days')
ylabel('Price(dollars)')

figure
plot(weight_BaBa)
hold on 
plot(weight_IBM)
hold on
plot(weight_TSLA)
hold off
legend('show','Alibaba','IBM','Tesla')
xlabel('Days')
ylabel('share')