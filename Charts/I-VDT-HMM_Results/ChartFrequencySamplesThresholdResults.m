function [ ] = ChartFrequencySamplesThresholdResults( data1, data2, velocity_index, dispersion_index, duration_index, score_index, score, optimal, frequency, sample1, sample2, location)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure;
velocity_sorted_1 = sort([data1(:, velocity_index), data1(:, score_index)], 1);
windowLength_sorted_1 = sort([data1(:, duration_index), data1(:, score_index)], 1);
dispersion_sorted_1 = sort([data1(:, dispersion_index), data1(:, score_index)], 1);

velocity_sorted_2 = sort([data2(:, velocity_index), data2(:, score_index)], 1);
windowLength_sorted_2 = sort([data2(:, duration_index), data2(:, score_index)], 1);
dispersion_sorted_2 = sort([data2(:, dispersion_index), data2(:, score_index)], 1);

plot(windowLength_sorted_1(:,1), windowLength_sorted_1(:,2), dispersion_sorted_1(:,1)*100, dispersion_sorted_1(:,2), velocity_sorted_1(:,1), velocity_sorted_1(:,2), windowLength_sorted_2(:,1), windowLength_sorted_2(:,2), dispersion_sorted_2(:,1)*100, dispersion_sorted_2(:,2), velocity_sorted_2(:,1), velocity_sorted_2(:,2));
ref = refline(0, optimal);
ref.Color = 'black';

min_x = 0;
try
    max_x = max([velocity_sorted_1(length(velocity_sorted_1),1), windowLength_sorted_1(length(windowLength_sorted_1),1), dispersion_sorted_1(length(dispersion_sorted_1), 1)*100]);
catch
    disp('ohp');
end
if optimal == 0
    min_y = -0.1;
else
    min_y = min([optimal, velocity_sorted_1(1,2), windowLength_sorted_1(1,2), dispersion_sorted_1(1, 2)]);
end
    
max_y = max([optimal+1, velocity_sorted_1(length(velocity_sorted_1),2), windowLength_sorted_1(length(windowLength_sorted_1),2), dispersion_sorted_1(length(dispersion_sorted_1), 2)]);
try
    axis([min_x max_x min_y max_y])
catch
    disp('ohp');
end


score_title = sample1 + " vs " + sample2 + " " + frequency + " " + score + " Thresholds";
y_label = score + " Score";
x_label = "Threshold Value";

title(score_title);
ylabel(y_label);
xlabel(x_label);

%legend(sample1 + " Window Length", sample1 + " Dispersion Threshold * 100", sample1 + " Saccade Velocity Threshold", sample2+ " Window Length", sample2 + " Dispersion Threshold * 100", sample2 + " Saccade Velocity Threshold", "Optimal Threshold", 'Location', location);
legend("Noisy Window Length", "Noisy Dispersion Threshold * 100", "Noisy Saccade Velocity Threshold", "Clean Window Length", "Clean Dispersion Threshold * 100", "Clean Saccade Velocity Threshold", "Optimal Threshold", 'Location', location);

end

