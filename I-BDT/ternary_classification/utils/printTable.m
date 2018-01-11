function  printTable( id, result)
    function doit(name, vals)
        fprintf('%-6s', name);
        for j = 1 : length(vals)
            fprintf('| %6.2f ', vals(j));
        end
        fprintf(' |\n');
    end

classes = { 'fix', 'sac', 'pur' };

cur = result.stats;

fprintf('%-6s', id);
for j = 1 : length(cur.precision)
    fprintf('|%4s%3s%1s', '', classes{j},'');
end
fprintf(' |\n');

doit('acc', cur.accuracy);
doit('prec', cur.precision);
doit('rec', cur.recall);
doit('spec', cur.specificity);

fprintf('\n');

end

