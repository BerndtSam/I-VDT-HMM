datasetDir = './etra2016-ibdt-dataset';
groundTruth = 'reviewed.csv';
target = 'classification.csv';

ids = {
      '1/1' ; '1/2' ; '1/3' ; '1/4' ...
    ; '2/1' ; '2/2' ; '2/3' ; '2/4' ...
    ; '3/1' ; '3/2' ; '3/3' ; '3/4' ...
    ; '4/1' ; '4/2' ; '4/3' ; '4/4' ...
    ; '5/1' ; '5/2' ; '5/3' ; '5/4' ...
    ; '6/1' ; '6/2' ; '6/3' ; '6/4' ...

    }
gRows = 6;
gCols = length(ids)/gRows;

fprintf('Dataset directory: %s\n', datasetDir);
fprintf('Ground truth file: %s\n', groundTruth);
fprintf('Target file: %s\n', target);

addpath('classification');
addpath('utils');
