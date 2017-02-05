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

%% SMA section
%first 10 days are IDLE period, using equal weight and first estimate starts at Day 11
Day_count=numel(BaBa_2015);
SMA_BaBa=zeros(Day_count,1);
SMA_IBM=zeros(Day_count,1);
SMA_TSLA=zeros(Day_count,1);

%predict price
for day_index=1:Day_count
    if day_index<=Interval
    SMA_BaBa(day_index)=BaBa_2015(day_index);
    SMA_IBM(day_index)=IBM_2015(day_index);
    SMA_TSLA(day_index)=TSLA_2015(day_index);
    else
    SMA_BaBa(day_index)=sum(BaBa_2015(day_index-Interval:day_index-1))/Interval;
    SMA_IBM(day_index)=sum(IBM_2015(day_index-Interval:day_index-1))/Interval;
    SMA_TSLA(day_index)=sum(TSLA_2015(day_index-Interval:day_index-1))/Interval;
    end
end

%porfolio array
Num_BaBa=zeros(Day_count,1);
Num_IBM=zeros(Day_count,1);
Num_TSLA=zeros(Day_count,1);
Total_Value=zeros(Day_count,1);
Total_Value_Actual=zeros(Day_count,1);
Total_Value_SP500=zeros(Day_count,1);
Total_Value_eq=zeros(Day_count,1);
%%Initual porfolio
Num_BaBa(1:Interval)=(Initual_Value/3)/BaBa_2015(1);
Num_IBM(1:Interval)=(Initual_Value/3)/IBM_2015(1);
Num_TSLA(1:Interval)=(Initual_Value/3)/TSLA_2015(1);
Share_SP500=Initual_Value/Data_2015(1);
for day_index_2=1:Day_count
    if day_index_2<=Interval
        %calulate total value of porfolio
        Total_Value(day_index_2)=BaBa_2015(day_index_2)*Num_BaBa(day_index_2)+IBM_2015(day_index_2)*Num_IBM(day_index_2)+TSLA_2015(day_index_2)*Num_TSLA(day_index_2);
        Total_Value_Actual(day_index_2)=BaBa_2015(day_index_2)*Num_BaBa(day_index_2)+IBM_2015(day_index_2)*Num_IBM(day_index_2)+TSLA_2015(day_index_2)*Num_TSLA(day_index_2);
        Total_Value_SP500(day_index_2)=Share_SP500*Data_2015(day_index_2);
        Total_Value_eq(day_index_2)=Num_BaBa(day_index_2)*BaBa_2015(day_index_2)+Num_IBM(day_index_2)*IBM_2015(day_index_2)+Num_TSLA(day_index_2)*TSLA_2015(day_index_2);      
    else
        %Start Rebalance Porfolio
        % We have total value of previous day in hand
        % just neet to split them base on the prediction of current day
        % requirement: 
        %      Max number_BABA*Price_BABA_prediction+number_IBM*Price_IBM_prediction+number_TLSA*Price_TLSA_prediction
        % constraint: 
        %      number_BABA*Price_BABA_now+number_IBM*Price_IBM_now+number_TLSA*Price_TLSA_now<=TotalValue
        % using intlinprog to solve this
        X=intlinprog([-SMA_BaBa(day_index_2),-SMA_IBM(day_index_2),-SMA_TSLA(day_index_2)],[1,2,3],[BaBa_2015(day_index_2-1),IBM_2015(day_index_2-1),TSLA_2015(day_index_2-1)],Total_Value_Actual(day_index_2-1),[],[],[0,0,0],[inf,inf,inf] );
        Num_BaBa(day_index_2)=X(1);
        Num_IBM(day_index_2)=X(2);
        Num_TSLA(day_index_2)=X(3);
        
        %equal weight part
        Total_Value_eq(day_index_2)=Total_Value_eq(day_index_2-1)/3/BaBa_2015(day_index_2-1)*BaBa_2015(day_index_2)+Total_Value_eq(day_index_2-1)/3/IBM_2015(day_index_2-1)*IBM_2015(day_index_2)+Total_Value_eq(day_index_2-1)/3/TSLA_2015(day_index_2-1)*TSLA_2015(day_index_2);      
        Total_Value(day_index_2)=SMA_BaBa(day_index_2)*Num_BaBa(day_index_2)+SMA_IBM(day_index_2)*Num_IBM(day_index_2)+SMA_TSLA(day_index_2)*Num_TSLA(day_index_2);
        Total_Value_Actual(day_index_2)=BaBa_2015(day_index_2)*Num_BaBa(day_index_2)+IBM_2015(day_index_2)*Num_IBM(day_index_2)+TSLA_2015(day_index_2)*Num_TSLA(day_index_2);
        Total_Value_SP500(day_index_2)=Share_SP500*Data_2015(day_index_2);
    end
end


%% plot

%plot total value
figure
plot(Total_Value_eq)
hold on
plot(Total_Value_Actual)
hold on
plot(Total_Value_SP500)
hold off
legend('show','Equal Weight','Portfolio','sp500')
xlabel('Days')
ylabel('Total Value(dollars)')

figure
plot(Num_BaBa)
hold on 
plot(Num_IBM)
hold on
plot(Num_TSLA)
hold off
legend('show','Alibaba','IBM','Tesla')
xlabel('Days')
ylabel('share')