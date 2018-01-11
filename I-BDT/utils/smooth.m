function [ v ] = smooth( d, ws, we, minVel, maxVel, isInPursuit )

% Borders, nevermind
if ws < 2 || we > length(d.v)-1
    v = d.v(ws:we);
    return
end

assert(length(ws:we) >= 4, 'Time window is too small');

% Get the velocities within the range and binarize them
v = d.v(ws-1:we);
v = v > minVel & v < maxVel;

% Apply logical smoothing
if isInPursuit
    winStart = 4;
    for i = winStart : length(v);
        v(i-1) = v(i-1) ...
            || ( v(i-2) && v(i) ) ...
            || ( v(i-3) && v(i) );
        v(i-2) = v(i-2) ...
            || ( v(i-3) && v(i) ) ...
            || ( v(i-3) && v(i-1) );
    end
else
    winStart = 3;
    for i = winStart : length(v);
        v(i-1) = v(i-1) || ( v(i-2) && v(i) );
    end
end

% remove borders
v(end) = [];
v(1) = [];

end

