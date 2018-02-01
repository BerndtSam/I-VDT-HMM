function [ output_args ] = AlgorithmComparison( frequency, sample )
%ALGORITHMCOMPARISON Summary of this function goes here
%   Detailed explanation goes here

%[clean, noisy] = ConcatenateData(["s_007"], [30, 100, 500, 1000], "Results/");
%data = [clean; noisy;];frequency_threshold_scores

importDir = "OptimalData/";
matExtension = ".mat";
IVDTHMMFile = importDir + "IVDTHMM-f" + frequency + "-" + sample + matExtension;
IVDTFile = importDir + "IVDT-f" + frequency + "-" + sample + matExtension;
IBDTFile = importDir + "IBDT-f" + frequency + "-" + sample + matExtension;

IVDTHMMData = load(IVDTHMMFile);
IVDTData = load(IVDTFile);
IBDTData = load(IBDTFile);

IVDTData = IVDTData.frequency_threshold_scores;
IBDTData = IBDTData.frequency_threshold_scores;

IVDTHMMData = [ IVDTHMMData.best_SQnS, IVDTHMMData.best_FQnS, IVDTHMMData.best_PQnS, IVDTHMMData.best_MisFix, IVDTHMMData.best_FQlS, IVDTHMMData.best_PQlS_P, IVDTHMMData.best_PQlS_V];
IVDTData = IVDTData(1,7:length(IVDTData));
IBDTData = IBDTData(1,7:length(IBDTData));

data = [IVDTHMMData; IVDTData; IBDTData];
data = transpose(data);

O_SQnS = "Ideal SQnS";
O_FQnS = "Ideal FQnS";
O_PQnS = "Ideal PQnS";
O_MisFix = "Ideal MisFix";
O_FQlS_PQlS = "Ideal FQlS/PQlS_P/PQlS_V";

SQnS = "SQnS";
FQnS = "FQnS";
PQnS = "PQnS";
MisFix = "MisFix";
FQlS = "FQlS";
PQlS_P = "PQlS_P";
PQlS_V = "PQlS_V";

IVDTHMM = "I-VDT-HMM";
IVDT = "I-VDT";
IBDT = "I-BDT";

optimal_SQnS = 100;
%optimal_FQnS = 83.9;
%optimal_PQnS = 52;
optimal_FQnS = 81.5991;
optimal_PQnS = 52.04;
optimal_MisFix = 7.1;
optimal_FQlS = 0;
optimal_PQlS_P = 0;
optimal_PQlS_V = 0;

x_titles = [SQnS, FQnS, PQnS, MisFix, FQlS, PQlS_P, PQlS_V];

figure;
ylim([0 150]);
bar([1 2 3 4 5 6 7],[data(1,:); data(2,:); data(3,:); data(4,:); data(5,:); data(6,:); data(7,:);])
%set(gca,"xticklabel",x_titles)
xticklabels(x_titles)
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

score_title = "Comparison of Algorithms using " + strrep(sample, '_', '-') + " at f" + frequency;
y_label = "Scores";
x_label = "Behavioral Scores";

title(score_title);
ylabel(y_label);
xlabel(x_label);

legend(IVDTHMM, IVDT, IBDT, O_SQnS, O_FQnS, O_PQnS, O_MisFix, O_FQlS_PQlS, "Location", "bestoutside");

end


