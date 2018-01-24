function [ ] = ChartFrequencyThresholdResults( data, velocity_index, dispersion_index, duration_index, score_index, score, optimal, frequency, sample, location)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure;
velocity_sorted = sort([data(:, velocity_index), data(:, score_index)], 1);
windowLength_sorted = sort([data(:, duration_index), data(:, score_index)], 1);
dispersion_sorted = sort([data(:, dispersion_index), data(:, score_index)], 1);

plot(windowLength_sorted(:,1), windowLength_sorted(:,2), dispersion_sorted(:,1)*100, dispersion_sorted(:,2), velocity_sorted(:,1), velocity_sorted(:,2));
ref = refline(0, optimal);
ref.Color = 'black';
min_x = 0;
try
    max_x = max([velocity_sorted(length(velocity_sorted),1), windowLength_sorted(length(windowLength_sorted),1), dispersion_sorted(length(dispersion_sorted), 1)*100]);
catch
    disp('ohp');
end
if optimal == 0
    min_y = -0.1;
else
    min_y = min([optimal, velocity_sorted(1,2), windowLength_sorted(1,2), dispersion_sorted(1, 2)]);
end
    
max_y = max([optimal+1, velocity_sorted(length(velocity_sorted),2), windowLength_sorted(length(windowLength_sorted),2), dispersion_sorted(length(dispersion_sorted), 2)]);
try
    axis([min_x max_x min_y max_y])
catch
    disp('ohp');
end

score_title = sample + " " + frequency + " " + score + " Thresholds";
y_label = score + " Score";
x_label = "Threshold Value";

title(score_title);
ylabel(y_label);
xlabel(x_label);

legend('Window Length', 'Dispersion Threshold * 100', 'Saccade Velocity Threshold', 'Optimal Threshold', 'Location', location);


end

