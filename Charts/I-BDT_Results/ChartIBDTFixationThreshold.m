function [  ] = ChartIBDTFixationThreshold( data, x_titles, subject, frequency, location )
%CHARTIBDTFIXATIONTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
O_SQnS = 'Opt. SQnS';
O_FQnS = 'Opt. FQnS';
O_PQnS = 'Opt. PQnS';
O_MisFix = 'Opt. MisFix';
O_FQlS_PQlS = 'Opt. FQlS/PQlS_P/PQlS_V';

SQnS = 'SQnS';
FQnS = 'FQnS';
PQnS = 'PQnS';
MisFix = 'MisFix';
FQlS = 'FQlS';
PQlS_P = 'PQlS_P';
PQlS_V = 'PQlS_V';

optimal_SQnS = 100;
optimal_FQnS = 83.9;
optimal_PQnS = 52;
optimal_MisFix = 7.1;
optimal_FQlS = 0;
optimal_PQlS_P = 0;
optimal_PQlS_V = 0;

figure;
bar([1 2 3 4 5 6],[data(1,:); data(2,:); data(3,:); data(4,:); data(5,:); data(6,:)])
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

score_title = "I-BDT " + subject + " " + frequency + " " + "Fixation Threshold";
y_label = "Behavioral Scores";
x_label = "Fixation Thresholds";

title(score_title);
ylabel(y_label);
xlabel(x_label);

legend(SQnS, FQnS, PQnS, MisFix, FQlS, PQlS_P, PQlS_V, O_SQnS, O_FQnS, O_PQnS, O_MisFix, O_FQlS_PQlS, 'Location', location);

end

