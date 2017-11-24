fin = fopen('geojson_wami_12.json');
fout = fopen('output.txt','w+');

while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, '\', '');
    s = strrep(s, '_', '-');
    fprintf(fout,'%s\n',s);
    disp(s)
end

fclose(fin)
fclose(fout)
