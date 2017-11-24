function write2json(trajectory,filename)
% trajectory is a cell consisting of 2 columns
% ex: trajectory{1} = [-84.1104   39.7983;  -84.1101   39.7983;  -84.1099
% 39.7984;  -84.1096   39.7984]

ss = regexp(filename, '\', 'split');
geometry=struct('type','LineString','coordinates',trajectory);
properties=struct('title', [ss{end},'.json'],...
    'thumbnail','CA==',...
    'resource_uri', 'http://example.com',...
    'created', '2012-09-01T00:09:19.368+0000',...
    'metadata_content_type_version', '1.0',...
    'metadata_content_type','Image Process',....
    'metadata', '<xml>DDF</xml>',...
    'modified', '2012-09-01T00:09:19.368+0000');
geojson_wami=struct('properties',properties,'type','Feature','geometry',geometry);

savejson('',geojson_wami,[ss{end},'_.json']);

% revise .json file
fin = fopen([ss{end},'_.json']);
fout = fopen([ss{end},'.json'],'w+');

while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, '\', '');
    s = strrep(s, '_', '-');
    fprintf(fout,'%s\n',s);
    disp(s)
end
fclose(fin);
fclose(fout);
[destPath,name,~] = fileparts(filename);
[SUCCESS,MESSAGE,MESSAGEID] = movefile([ss{end},'.json'],[fullfile(destPath,name),'.json']);
delete([ss{end},'_.json']);
