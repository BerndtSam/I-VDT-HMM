function [ x, y ] = removeOneSampleSpike( x, y )

dx = [ 0 diff(x) ];
dy = [ 0 diff(y) ];

ds = sqrt(dx.^2 + dy.^2);
tmp = ds;
tmp(ds==0) = [];
minVal = min(tmp);

for i = 2:length(ds)-1
    if ds(i) > minVal
        nx = [ x(i-1) x(i+1) ];
        ny = [ y(i-1) y(i+1) ];
        if dispersion(nx, ny) <= minVal
            x(i) = round(median(nx));
            y(i) = round(median(ny));
        end
    end
end

end

