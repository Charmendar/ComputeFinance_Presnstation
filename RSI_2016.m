clear all;
close all;

%single moving average
%Reference: http://www.investopedia.com/terms/s/sma.asp


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

%% Initualize Variable
%define moving intervel
Interval=numel(BaBa_2015);
%initual money 
Initual_Value=3000000; 
%% SMA section
%first 10 days are IDLE period, using equal weight and first estimate starts at Day 11
Day_count=numel(BaBa_2015);
RSI_BaBa=0;
RSI_IBM=0;
RSI_TSLA=0;

% RSI calculation        
    Norm_BaBa=0;
    Norm_IBM=0;
    Norm_TSLA=0;
    Denorm_BaBa=0;
    Denorm_IBM=0;
    Denorm_TSLA=0;
    
    for i=0:Interval-2
        if BaBa_2015(Day_count-i)>BaBa_2015(Day_count-i-1)
            Norm_BaBa=Norm_BaBa+BaBa_2015(Day_count-i)-BaBa_2015(Day_count-i-1);
        end
        Denorm_BaBa=Denorm_BaBa+abs(BaBa_2015(Day_count-i)-BaBa_2015(Day_count-i-1));
        
        if IBM_2015(Day_count-i)>IBM_2015(Day_count-i-1)
            Norm_IBM=Norm_IBM+IBM_2015(Day_count-i)-IBM_2015(Day_count-i-1);
        end
        Denorm_IBM=Denorm_IBM+abs(IBM_2015(Day_count-i)-IBM_2015(Day_count-i-1));
        
        
        if TSLA_2015(Day_count-i)>TSLA_2015(Day_count-i-1)
            Norm_TSLA=Norm_TSLA+TSLA_2015(Day_count-i)-TSLA_2015(Day_count-i-1);
        end
        Denorm_TSLA=Denorm_TSLA+abs(TSLA_2015(Day_count-i)-TSLA_2015(Day_count-i-1));  
    end
        
    RSI_BaBa(Day_count)=Norm_BaBa*100/Denorm_BaBa;
    RSI_IBM(Day_count)=Norm_IBM*100/Denorm_IBM;
    RSI_TSLA(Day_count)=Norm_TSLA*100/Denorm_TSLA;
  



 X=linprog([RSI_BaBa(Day_count),RSI_IBM(Day_count),RSI_TSLA(Day_count)],[],[],[1, 1, 1],1,[0,0,0],[1,1,1] );
 weight_BaBa=X(1);
 weight_IBM=X(2);
 weight_TSLA=X(3);      

%% Done with weight, lets verify with 2016 data

SP500_2016=xlsread('SP500_2016.csv',1,'G:G');
SP500_2016=fliplr(SP500_2016);
%Alibaba
BaBa_2016=xlsread('BaBa_2016.csv',1,'G:G');
BaBa_2016=fliplr(BaBa_2016);%reverse order start from day one
%IBM
IBM_2016=xlsread('IBM_2016.csv',1,'G:G');
IBM_2016=fliplr(IBM_2016);%reverse order start from day one
%Tesla
TSLA_2016=xlsread('TSLA_2016.csv',1,'G:G');
TSLA_2016=fliplr(TSLA_2016);%reverse order start from day one

Day_count=numel(BaBa_2016);
Amount_BaBa=Initual_Value*weight_BaBa;
Amount_IBM=Initual_Value*weight_IBM;
Amount_TSLA=Initual_Value*weight_TSLA;

Share_BaBa=Amount_BaBa/BaBa_2016(1);
Share_IBM=Amount_IBM/IBM_2016(1);
Share_TSLA=Amount_TSLA/TSLA_2016(1);

Share_BaBa_eq=(Initual_Value/3)/BaBa_2016(1);
Share_IBM_eq=(Initual_Value/3)/IBM_2016(1);
Share_TSLA_eq=(Initual_Value/3)/TSLA_2016(1);

Share_SP500=Initual_Value/SP500_2016(1);

Total_Value=zeros(Day_count,1);
Total_Value_eq=zeros(Day_count,1);
Total_Value_SP500=zeros(Day_count,1);

for i=1:Day_count
    Total_Value(i)=Share_BaBa*BaBa_2016(i)+Share_IBM*IBM_2016(i)+Share_TSLA*TSLA_2016(i);
    Total_Value_eq(i)=Share_BaBa_eq*BaBa_2016(i)+Share_IBM_eq*IBM_2016(i)+Share_TSLA_eq*TSLA_2016(i);
    Total_Value_SP500(i)=Share_SP500*SP500_2016(i);
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
plot(BaBa_2016)
hold on
plot(IBM_2016)
hold on 
plot(TSLA_2016)
hold off
legend('show','BaBa','IBM','TSLA')
xlabel('Days')
ylabel('Price(dollars)')

% figure
% plot(weight_BaBa)
% hold on 
% plot(weight_IBM)
% hold on
% plot(weight_TSLA)
% hold off
% legend('show','Alibaba','IBM','Tesla')
% xlabel('Days')
% ylabel('share')