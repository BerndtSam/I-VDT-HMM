function [  ] = ChartScoresOptimalThresholds( )
%CHARTSCORESOPTIMALTHRESHOLDS Summary of this function goes here
%   Detailed explanation goes here
import_directory = "OptimalResults/";
mat_file_extension = "-final0.mat";

noisey_dataset = "s_010";
clean_dataset = "s_007";

noisey_filename = import_directory + noisey_dataset + mat_file_extension;
clean_filename = import_directory + clean_dataset + mat_file_extension;

noisey = load(noisey_filename);
clean = load(clean_filename);

%noisey = noisey.final_threshold_scores;
%clean = clean.final_threshold_scores;
noisey = noisey.noisy_results;
clean = clean.clean_results;
noisey_scores = noisey(:,4:length(noisey));
clean_scores = clean(:,4:length(clean));

data = [clean_scores; noisey_scores; ];

O_SQnS = 'Ideal SQnS';
O_FQnS = 'Ideal FQnS';
O_PQnS = 'Ideal PQnS';
O_MisFix = 'Ideal MisFix';
O_FQlS_PQlS = 'Ideal FQlS/PQlS_P/PQlS_V';

SQnS = 'SQnS';
FQnS = 'FQnS';
PQnS = 'PQnS';
MisFix = 'MisFix';
FQlS = 'FQlS';
PQlS_P = 'PQlS_P';
PQlS_V = 'PQlS_V';

Clean = 'Clean ';
Noisy = 'Noisy ';

optimal_SQnS = 100;
%optimal_FQnS = 83.9;
%optimal_PQnS = 52;
optimal_FQnS = 81.5991;
optimal_PQnS = 52.04;
optimal_MisFix = 7.1;
optimal_FQlS = 0;
optimal_PQlS_P = 0;
optimal_PQlS_V = 0;

%x_titles = noisey(:,1);
x_titles = [30 100 500 1000];
x_titles = ["Clean " + string(x_titles); "Noisy " + string(x_titles)];

figure;
bar([1 2 3 4 5 6 7 8],[data(1,:); data(2,:); data(3,:); data(4,:); data(5,:); data(6,:); data(7,:); data(8,:);])
set(gca,'xticklabel',x_titles)
refsqns = refline(0, optimal_SQnS);
reffqns = refline(0, optimal_FQnS);
refpqns = refline(0, optimal_PQnS);
refmisfix = refline(0, optimal_MisFix);
reffqls = refline(0, optimal_FQlS);
refsqns.Color = 'm';
reffqns.Color = 'b';
refpqns.Color = 'c';
refmisfix.Color = 'g';
reffqls.Color = 'k';
ylim([0 150]);

score_title = "I-VDT-HMM Optimal Threshold Results per Frequency";
y_label = "Behavioral Scores";
x_label = "Sampling Frequencies";

title(score_title);
ylabel(y_label);
xlabel(x_label);

legend(SQnS, FQnS, PQnS, MisFix, FQlS, PQlS_P, PQlS_V, O_SQnS, O_FQnS, O_PQnS, O_MisFix, O_FQlS_PQlS, 'Location', 'bestoutside');

end

