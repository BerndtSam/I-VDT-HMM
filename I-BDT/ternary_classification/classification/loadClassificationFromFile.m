function [ ret ] = loadClassificationFromFile( fileName )

iIdx = 1;
classIdx = 2;
tIdx = 3;

target = importdata( fileName , ',');

[rows, cols] = size(target);
assert( cols >= 3, strcat('Not enough columns on file: ', fileName) );

ret = ClassificationClass(rows);

for i = 1 : rows
    ret.value(i) = target(i, classIdx);
    ret.ts(i) = target(i, tIdx);
    ret.setter{i} = 'unknown';
end

end

