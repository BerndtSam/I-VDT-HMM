function [ res ] = dispersion( x, y )

if length(x) == 0
    res = 0;
    return
end

res = sqrt( (max(x) - min(x))^2 + (max(y) - min(y))^2 );


end

