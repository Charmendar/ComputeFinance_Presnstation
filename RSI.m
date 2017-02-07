function [ RSIValue ] = RSI( price_array )
%RSI Summary of this function goes here
%   Detailed explanation goes here
    Norm=0;
    Denorm=0;
    interval=numel(price_array);
    for i=0:interval-2
         if price_array(interval-i)>price_array(interval-i-1)
            Norm=Norm+price_array(interval-i)-price_array(interval-i-1);
        end
        Denorm=Denorm+abs(price_array(interval-i)-price_array(interval-i-1));
    end
    RSIValue=Norm*100/Denorm;
end

