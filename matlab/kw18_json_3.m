% transfrom the kw18 data to json form data. 
% Use the longtitude and altitude coordinates.
clc;
clear;
tic;

load('A.mat')  %load ground truth

%find all the trajectories start from the seleted frame;
bb=size(A,1);  % the row length of A;
num=1;  %number of trajectories
start=[1];

for i=2:1:bb
    if (A(i,1)~=A(i-1,1))
        num=num+1;
        start=[start,i];  % find the starting row of each trajectory
    end
end

trajectory=cell(1,1);  % 1 can be changed to any other number;
trajectory_length=zeros(1,num);
% trajectory_ind=1000;   % index for trajectory, from 1 to 19158.

for trajectory_ind=1 % 1 can be changed to any other numer;
    c=[];
    trajectoryX=zeros(1,A(start(trajectory_ind),2));
    trajectoryY=zeros(1,A(start(trajectory_ind),2));
    trajectory_length(trajectory_ind)=A(start(trajectory_ind),2);  % trajectory length;
    
    for i=1:1:length(trajectoryX)
        trajectoryX(i)=(A(start(trajectory_ind)+i-1,15));
        trajectoryY(i)=(A(start(trajectory_ind)+i-1,16));
        c=[c
            [trajectoryX(i), trajectoryY(i)]];
    end
    
    trajectory{trajectory_ind}=c;
    
end

geometry=struct('type','LineString','coordinates',trajectory);
properties=struct('title', 'wami',...
    'thumbnail','CA==',...
    'resource_uri', 'http://example.com',...
    'created', '2012-09-01T00:09:19.368+0000',...
    'metadata_content_type_version', '1.0',...
    'metadata_content_type','Image Process',....
    'metadata', '<xml>DDF</xml>',...
    'modified', '2012-09-01T00:09:19.368+0000');
geojson_wami=struct('properties',properties,'type','GeometryCollection','geometry',geometry);

savejson('',geojson_wami,'geojson_wami_12.json')

toc;



