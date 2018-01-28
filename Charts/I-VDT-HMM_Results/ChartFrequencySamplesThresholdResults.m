function [ ] = ChartFrequencySamplesThresholdResults( cleanData, noisyData, velocity_index, dispersion_index, duration_index, score_index, score, optimal, frequency, cleanSample, noisySample, location)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
figure;
velocity_clean_data = sort([cleanData(:, velocity_index), cleanData(:, score_index)], 1);
%windowLength_clean_data = sort([cleanData(:, duration_index), cleanData(:, score_index)], 1);
dispersion_clean_data = sort([cleanData(:, dispersion_index), cleanData(:, score_index)], 1);

velocity_noisy_data = sort([noisyData(:, velocity_index), noisyData(:, score_index)], 1);
%windowLength_noisy_data = sort([noisyData(:, duration_index), noisyData(:, score_index)], 1);
dispersion_noisy_data = sort([noisyData(:, dispersion_index), noisyData(:, score_index)], 1);

plot(dispersion_clean_data(:,1)*100, dispersion_clean_data(:,2), velocity_clean_data(:,1), velocity_clean_data(:,2), dispersion_noisy_data(:,1)*100, dispersion_noisy_data(:,2), velocity_noisy_data(:,1), velocity_noisy_data(:,2));
ref = refline(0, optimal);
ref.Color = 'black';

min_x = 0;
try
    max_x = max([velocity_clean_data(length(velocity_clean_data),1), dispersion_clean_data(length(dispersion_clean_data), 1)*100]);
catch
    disp('ohp');
end
if optimal == 0
    min_y = -0.1;
else
    min_y = min([optimal, velocity_clean_data(1,2) , dispersion_clean_data(1, 2)]);
end
    
max_y = max([optimal+1, velocity_clean_data(length(velocity_clean_data),2), dispersion_clean_data(length(dispersion_clean_data), 2)]);
% try
%     continue;
%     %axis([min_x max_x min_y max_y])
% catch
%     disp('ohp');
% end


score_title = cleanSample + " vs " + noisySample + " " + frequency + " " + score + " Thresholds";
y_label = score + " Score";
x_label = "Threshold Value";

title(score_title);
ylabel(y_label);
xlabel(x_label);

%legend(cleanSample + " Window Length", cleanSample + " Dispersion Threshold * 100", cleanSample + " Saccade Velocity Threshold", noisySample+ " Window Length", noisySample + " Dispersion Threshold * 100", noisySample + " Saccade Velocity Threshold", "Optimal Threshold", 'Location', location);
legend("Clean Dispersion Threshold * 100", "Clean Saccade Velocity Threshold", "Noisy Dispersion Threshold * 100", "Noisy Saccade Velocity Threshold", "Ideal Score", 'Location', location);

end

