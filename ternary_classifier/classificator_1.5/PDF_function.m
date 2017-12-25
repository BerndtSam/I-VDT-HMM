% Modified by Sam Berndt, Tim Taviano, Doug Kirkpatrick 
% Project 3 - Ternary Classification
% Oleg K. 
% Last Modified 12/3/17

function [ probability ] = PDF_function(x,mean, std )
%PDF_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
    probability = 1/sqrt(2*pi*std^2)*exp(-(x-mean)^2/(2*std^2));
end

