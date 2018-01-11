function [ d, r, gt ] = run(datasetDir, groundTruth, target, id)

base = [ datasetDir '\' id '\' ];
availableJournals = dir( [ base '*journal*.txt' ] );
in = [ base, availableJournals(1).name ];
out = strcat(base, target);
gtName = strcat(base, groundTruth);

d = classify(in, out);

t = d.c;
    
gt = loadClassificationFromFile(gtName);
fprintf('%s\n', gtName);
fprintf('%s\n', out);
r = compareClassification(gt, t);
r.id = id;

fprintf('\n')

disp('   fix   sac   pur');
disp(r.mat);

fprintf('\n')

printTable(id, r);

end

