function [ ret ] = compareClassification( c1, c2)

    function entries = convert(entries, from, to)
        entries( entries == from ) = to;
    end

assert(c1.count == c2.count, ...
    sprintf('[ERROR] Number of classifications do not match (%d x %d)\n', c1.count, c2.count));

ret.id = '';

c1.value = convert(c1.value, vor, noise);
c2.value = convert(c2.value, vor, noise);

ignore = c1.get(noise);
undefined = c2.get(undef);
differ = (c1.value ~= c2.value) & ~ignore & ~undefined;

mismatch = find(differ);
ce = ClassificationEnum;
for i = 1 : length(mismatch)
    idx = mismatch(i);
    gtClass = ce.str(c1.value(idx));
    tClass = ce.str(c2.value(idx));
    tSetter = char(c2.setter(idx));
    fprintf('[%5d] %10s -> %10s (%s)\n', idx-1, gtClass, tClass, tSetter);
end

cv1 = c1.value(~ignore);
cv2 = c2.value(~ignore);

ret.mat = confusionmat(cv1, cv2);
ret.stats = confusionmatStats(ret.mat);
[ ret.agreement, ret.ckappa, ret.h, ret.p ] = kappa(ret.mat);

end

