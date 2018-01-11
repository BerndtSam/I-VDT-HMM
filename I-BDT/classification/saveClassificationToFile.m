function saveClassificationToFile( d, fileName )

f = fopen(fileName, 'w+');

for i = 1 : length(d.v)
     fprintf(f, '%d,%d,%d\n', i, d.c.value(i), d.t(i));
end

fclose(f);

end

