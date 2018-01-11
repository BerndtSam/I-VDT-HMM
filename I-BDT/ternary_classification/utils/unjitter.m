function ret = unjitter( vals )
%UNJITTER Summary of this function goes here
%   Detailed explanation goes here

% This is the unjitter latency in frames.
% It delays the signal but greatly increases signal quality
% length(vals) equals check the whole signal
% empyrically speaking, around 150 ms should give a good quality already
frameLatency = length(vals);
% frameLatency = 5;

diffs = abs(diff(vals));
diffs(diffs == 0) = [];
minVal = min(abs(diffs));

for i = 2 : length(vals)
    valDiff = abs(diff(vals(i-1:i)));
    if valDiff == 0 || valDiff > minVal
        continue
    end
    
    for j = i+1 : min(length(vals),i+frameLatency)
        if vals(j) == vals(i)
            continue
        end
        if vals(j) == vals(i-1)
            vals(i) = vals(i-1);
        end
        break
    end
end

ret = vals;

end

