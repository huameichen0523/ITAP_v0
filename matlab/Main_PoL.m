function varargout = Main_PoL(varargin)

%
% Usage: Main_PoL
%
% This script provides a template on how to create simple tab panels within a GUI. Each
% tab panel should be a different panel with different components and can be easily
% created with GUIDE. By using GUIDE, you can create as many different panels as you want
% and layout them in a comfortable way for building. When the script initiates, it places
% them one behind the other and handles their visibilities accordingly.
%
% The main idea behind Main_PoL is that you can create the tab labels by creating an
% equal number of static text uicontrols and layout them properly over an empty panel of
% proper defined size (see Main_PoL.fig in GUIDE). You can use then their positions to
% create axes objects (so that an edge line can be displayed around tabs without having to
% define the 'CData' property) and then create text objects (which are also more
% customizable than static text uicontrols) inside them. The control and highlighting of
% different tabs is performed through properly defined object callbacks (see code). The
% initial static text uicontrols are invisible in the final window. They are only used
% inside GUIDE for positioning purposes only.
%
% Make sure that the panel which is used for the proper placement of the static text
% uicontrols is the bigger one as the others will acquire its position. Ideally, the
% other panels should not be designed to be very different from the first one in terms of
% their dimensions because normally, in a multitab window all tabs should have the same
% size and the desired uicontrols should be fitted into them.
%
%
% Author: Panagiotis Moulos (pmoulos@eie.gr)
% Version: 1.0
% First created: June 4, 2007
% Last modified: June 8, 2007
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_PoL_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_PoL_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Main_PoL is made visible.
function Main_PoL_OpeningFcn(hObject, eventdata, handles, varargin)
% for writing GeoJason file
addpath(genpath('..\tools'));
% Set the colors indicating a selected/unselected tab
handles.unselectedTabColor=get(handles.tab1text,'BackgroundColor');
handles.selectedTabColor=handles.unselectedTabColor-0.1;

% Set units to normalize for easier handling
set(handles.tab1text,'Units','normalized')
set(handles.tab2text,'Units','normalized')
set(handles.tab3text,'Units','normalized')
set(handles.tab1Panel,'Units','normalized')
set(handles.tab2Panel,'Units','normalized')
set(handles.tab3Panel,'Units','normalized')
set(handles.control1Panel,'Units','normalized')
set(handles.control2Panel,'Units','normalized')
% Create tab labels (as many as you want according to following code template)

% Tab 1
pos1=get(handles.tab1text,'Position');
handles.a1=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.selectedTabColor,...
                'Position',[pos1(1) pos1(2) pos1(3) pos1(4)+0.01],...
                'ButtonDownFcn','Main_PoL(''a1bd'',gcbo,[],guidata(gcbo))');
handles.t1=text('String','Simulated Data',... %'Position',[(pos1(3)-pos1(1))/2,pos1(2)/2+pos1(4)],...
                'Units','normalized',...
                'Position',[.5,0.5],...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',12,...
                'Backgroundcolor',handles.selectedTabColor,...
                'ButtonDownFcn','Main_PoL(''t1bd'',gcbo,[],guidata(gcbo))');

% Tab 2
pos2=get(handles.tab2text,'Position');
pos2(1)=pos1(1)+pos1(3);
handles.a2=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Color',handles.unselectedTabColor,...
                'Position',[pos2(1) pos2(2) pos2(3) pos2(4)+0.01],...
                'ButtonDownFcn','Main_PoL(''a2bd'',gcbo,[],guidata(gcbo))');
handles.t2=text('String','Real Data',...
                'Units','normalized',...
                'Position',[0.5,0.5],...
                'HorizontalAlignment','center',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',12,...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','Main_PoL(''t2bd'',gcbo,[],guidata(gcbo))');
           
% Tab 3 
pos3=get(handles.tab3text,'Position');
pos3(1)=pos2(1)+pos2(3);
handles.a3=axes('Units','normalized',...
                'Box','on',...
                'XTick',[],...
                'YTick',[],...
                'Visible','off',...
                'Color',handles.unselectedTabColor,...
                'Position',[pos3(1) pos3(2) pos3(3) pos3(4)+0.01],...
                'ButtonDownFcn','Main_PoL(''a3bd'',gcbo,[],guidata(gcbo))');
handles.t3=text('String','Tab 3',...
                'Units','normalized',...
                'Position',[pos3(3)/2,pos3(2)/2+pos3(4)],...
                'HorizontalAlignment','left',...
                'VerticalAlignment','middle',...
                'Margin',0.001,...
                'FontSize',8,...
                'Visible','off',...
                'Backgroundcolor',handles.unselectedTabColor,...
                'ButtonDownFcn','Main_PoL(''t3bd'',gcbo,[],guidata(gcbo))');
            
% Manage panels (place them in the correct position and manage visibilities)
pan1pos=get(handles.tab1Panel,'Position');
set(handles.tab2Panel,'Position',pan1pos);
set(handles.tab3Panel,'Position',pan1pos);
set(handles.tab2Panel,'Visible','off');
set(handles.tab3Panel,'Visible','off');

ctr1pos=get(handles.control1Panel,'Position');
set(handles.control2Panel,'Position',ctr1pos.*[1 1 1 1.5]-[0 ctr1pos(4)/2 0 0]);
%set(handles.control2Panel,'Position',ctr1pos.*[1 1 1 1]-[0 0 0 0]);
set(handles.control2Panel,'Visible','off');

% PoL part 1: simulated data
% load pre-generated simulated trajectories
handles.similatedData = loadSimilatedData();

% PoL part 2: real data
dataFile = '.\input\PVO_UTIL0_session_514_ref100.kw18';
handles.realData.kw18 = loadRealData(dataFile);
handles.realData.allTracks = loadAllTracksFromKw18(handles.realData.kw18);% including generation of binary track images
handles.realData.minL_old = str2double(get(handles.edit_minL,'string')); % min track length
handles.realData.maxL_old = str2double(get(handles.edit_maxL,'string')); % max track length
handles.realData.selectedTracks = loadSelectedTracks(handles.realData.allTracks,handles.realData.minL_old,handles.realData.maxL_old);
handles.realData.tSNE.data = loadTSNEData(handles.realData.selectedTracks);


% load tSNE model
tmp = load('.\input\Pre-generated\Model_tSNE_realData.mat'); % pre-traind paramatric tSNE model
handles.realData.tSNE.network = tmp.network;

% prepare output to DDF
if ~exist('output','dir')
    mkdir('output');
end
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_PoL wait for user response (see UIRESUME)
% uiwait(handles.simpletabfig);


% --- Outputs from this function are returned to the command line.
function varargout = Main_PoL_OutputFcn(hObject, eventdata, handles) 


% Text object 1 callback (tab 1)
function t1bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.a1,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')
set(handles.control1Panel,'Visible','on')
set(handles.control2Panel,'Visible','off')
% Text object 2 callback (tab 2)
function t2bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.a2,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')
set(handles.control2Panel,'Visible','on')
set(handles.control1Panel,'Visible','off')

% Text object 3 callback (tab 3)
function t3bd(hObject,eventdata,handles)

set(hObject,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.a3,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.tab3Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab2Panel,'Visible','off')


% Axes object 1 callback (tab 1)
function a1bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.t1,'BackgroundColor',handles.selectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab1Panel,'Visible','on')
set(handles.tab2Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Axes object 2 callback (tab 2)
function a2bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a3,'Color',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab2Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab3Panel,'Visible','off')


% Axes object 3 callback (tab 3)
function a3bd(hObject,eventdata,handles)

set(hObject,'Color',handles.selectedTabColor)
set(handles.a1,'Color',handles.unselectedTabColor)
set(handles.a2,'Color',handles.unselectedTabColor)
set(handles.t3,'BackgroundColor',handles.selectedTabColor)
set(handles.t1,'BackgroundColor',handles.unselectedTabColor)
set(handles.t2,'BackgroundColor',handles.unselectedTabColor)
set(handles.tab3Panel,'Visible','on')
set(handles.tab1Panel,'Visible','off')
set(handles.tab2Panel,'Visible','off')


% --- Executes on button press in pb_dataGen.
function pb_dataGen_Callback(hObject, eventdata, handles)

imgdir='.\input\';% image directory
filename='100.jpg';% background frame
I=imread([imgdir,filename]);
%h=handles.axes_traffic;
%set(handles.axes_traffic,'visible','on');
% figure;
imshow(I,[],'Parent',handles.axes_traffic);
if ~ishold(handles.axes_traffic)
   hold(handles.axes_traffic);
end
R = rand;
if R < 0.2
    WeekdayMorning;
elseif R < 0.4
    WeekdayAfternoon;
elseif R < 0.6 
    Weekend;
else
    RandomPattern;    
end

% --- Executes on button press in pb_TrackVisualization.
function pb_TrackVisualization_Callback(hObject, eventdata, handles)
% hObject    handle to pb_TrackVisualization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('map');
colormap(map);
tSNE_mapping;
load('.\working\mapped_test_X'); 
load('.\working\test_labels'); 
h3=handles.axes_2dView;
scatter(h3,mapped_test_X(:,1), mapped_test_X(:,2), 9, ones(1,length(test_labels)));
title(h3,'Embedding of test data');
axes(h3);
set(h3,'yticklabel',[]);
set(h3,'xticklabel',[]);
set(h3,'xtick',[]);
set(h3,'ytick',[]);
text(-40,15,'N-NE');
text(8,-45,'N-SW');
text(38,-15,'NE-N');
text(-7,-5,'NE-S');
text(48,32,'S');
text(42,45,'N');
text(-12,-43,'SW');
text(-23,-36,'NE');
text(8,45,'S-NE');
text(30,-35,'S-SW');
text(22,50,'SW-N');
text(-18,13,'SW-S');

% --- Executes on button press in pb_PoL.
function pb_PoL_Callback(hObject, eventdata, handles)
% hObject    handle to pb_PoL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('map');
colormap(map);
a=load('.\working\structData.mat');
c=MultiLayerSoftmaxClassifier(a.structData.X');
count=hist(handles.axes_hist4,c,0.5:1:11.5);
bar(handles.axes_hist4,1:12,count/sum(count));
set(handles.axes_hist4,'XTickLabel',handles.barLabel);
k1=count/sum(count);

b1=load('.\input\Pre-generated\trainData_WeekdayMorning.mat');
d1=MultiLayerSoftmaxClassifier(b1.trainData.X');
k21=hist(d1,0.5:1:11.5);
k21=k21/sum(k21);
b2=load('.\input\Pre-generated\trainData_WeekdayAfternoon.mat');
d2=MultiLayerSoftmaxClassifier(b2.trainData.X');
k22=hist(d2,0.5:1:11.5);
k22=k22/sum(k22);
b3=load('.\input\Pre-generated\trainData_Weekend.mat');
d3=MultiLayerSoftmaxClassifier(b3.trainData.X');
k23=hist(d3,0.5:1:11.5);
k23=k23/sum(k23);

KL1=sum(k1.*log2(k1./k21));
KL2=sum(k1.*log2(k1./k22));
KL3=sum(k1.*log2(k1./k23));
set(handles.txt_KL1,'string',num2str(KL1));
set(handles.txt_KL2,'string',num2str(KL2));
set(handles.txt_KL3,'string',num2str(KL3));

[v,pol] = min([KL1,KL2,KL3]);
if v < 0.06
switch pol
    case 1
        set(handles.txt_pattern,'string','Weekday morning');
    case 2
        set(handles.txt_pattern,'string','Weekday afternoon');
    case 3
        set(handles.txt_pattern,'string','Weekend');
    otherwise
        set(handles.txt_pattern,'string','Unknown pattern');
end
else
    set(handles.txt_pattern,'string','Unknown pattern');
end
        
% load pre-generate trajectories to speed up 
function similatedData = loadSimilatedData()
    similatedData.N_NE = load('.\input\Pre-generated\track_N_NE.mat');
    similatedData.N_SW = load('.\input\Pre-generated\track_N_SW.mat');
    similatedData.NE_N = load('.\input\Pre-generated\track_NE_N.mat');
    similatedData.NE_S = load('.\input\Pre-generated\track_NE_S.mat');
    similatedData.S = load('.\input\Pre-generated\track_S.mat');
    similatedData.N = load('.\input\Pre-generated\track_N.mat');
    similatedData.SW = load('.\input\Pre-generated\track_SW.mat');
    similatedData.NE = load('.\input\Pre-generated\track_NE.mat');
    similatedData.S_NE = load('.\input\Pre-generated\track_S_NE.mat');
    similatedData.S_SW = load('.\input\Pre-generated\track_S_SW.mat');
    similatedData.SW_N = load('.\input\Pre-generated\track_SW_N.mat');
    similatedData.SW_S = load('.\input\Pre-generated\track_SW_S.mat');


% --- Executes on button press in pb_LoadModels.
function pb_LoadModels_Callback(hObject, eventdata, handles)
% hObject    handle to pb_LoadModels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b1=load('.\input\Pre-generated\trainData_WeekdayMorning.mat');
b2=load('.\input\Pre-generated\trainData_WeekdayAfternoon.mat');
b3=load('.\input\Pre-generated\trainData_Weekend.mat');    
handles.barLabel = {'N-NE','N-SW','NE-N','NE-S','S','N','SW','NE','S-NE','S-SW','SW-N','SW-S'};
c=MultiLayerSoftmaxClassifier(b1.trainData.X');
count = hist(handles.axes_hist1,c,0.5:1:11.5);
bar(handles.axes_hist1,1:12,count/sum(count));
set(handles.axes_hist1,'XTickLabel',handles.barLabel);
title(handles.axes_hist1,'Weekday morning pattern');

c=MultiLayerSoftmaxClassifier(b2.trainData.X');
count = hist(handles.axes_hist2,c,0.5:1:11.5);
bar(handles.axes_hist2,1:12,count/sum(count));
set(handles.axes_hist2,'XTickLabel',handles.barLabel);
title(handles.axes_hist2,'Weekday afternoon pattern');

c=MultiLayerSoftmaxClassifier(b3.trainData.X');
count = hist(handles.axes_hist3,c,0.5:1:11.5);
bar(handles.axes_hist3,1:12,count/sum(count));
set(handles.axes_hist3,'XTickLabel',handles.barLabel);
title(handles.axes_hist3,'Weekend pattern');

guidata(hObject, handles);



% --- Executes on button press in pb2_dispData.
function pb2_dispData_Callback(hObject, eventdata, handles)
% hObject    handle to pb2_dispData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
ax=handles.axes_realData;
minL = str2double(get(handles.edit_minL,'string'));
maxL = str2double(get(handles.edit_maxL,'string'));
if handles.realData.minL_old ~= minL ...
        || handles.realData.maxL_old ~= maxL % minL or maxL is changed
    handles.realData.selectedTracks = loadSelectedTracks(handles.realData.allTracks,minL,maxL);
    handles.realData.tSNE.data = loadTSNEData(handles.realData.selectedTracks);
    handles.realData.maxL_old = maxL;
    handles.realData.minL_old = minL;
end

selectedTracks = handles.realData.selectedTracks;
numTracks = length(selectedTracks);
idx = 1:numTracks;
plotSeletectedTracks(ax,selectedTracks,idx,'');

% cla(ax,'reset');
% for i = 1:numTracks
%     plot(ax,selectedTracks{i}.trajectoryX,selectedTracks{i}.trajectoryY,'r-','linewidth',2);
%     if i == 1
%          hold(ax,'on');
%     end
% end
% hold(ax,'off');
% toc;
% tic;
% plot_google_map('Axis',ax,'MapType','hybrid','autoAxis',0,'Alpha',1); % roadmap, satellite, terrain, hybrid
% toc;
% display histogram
dispHist(handles.axes_histReal, handles.realData.selectedTracks);


function realData_all = loadRealData(fileName)
[p,n,~]= fileparts(fileName);
if exist(fullfile(p,[n,'.mat']),'file') == 0 % if .mat file does not exist
    fileID=fopen(fileName,'r');
    line = fgetl(fileID);
    lineNum = 0;
    while line ~= -1
        if line(1) ~= '#'
            lineNum = lineNum + 1;
        end
        line = fgetl(fileID);
    end
    fclose(fileID);
    % % fill A matrix, each row is a kw18 record
    A = zeros(lineNum,20);
    fileID=fopen(fileName,'r');
    lineNum = 0;
    line = fgetl(fileID);
    while line ~= -1
        if line(1) ~= '#'
            lineNum = lineNum + 1;
            A(lineNum,:) = sscanf(line,'%f',20);
        end
        line = fgetl(fileID);
    end
    fclose(fileID);
    save(fullfile(p,[n,'.mat']),'A');    
else % if .mat file exist
    load(fullfile(p,[n,'.mat']));  
end
realData_all = A;

function trajectory = loadAllTracksFromKw18(A)

% determine canvas image size
longMax = max(A(:,15));
longMin = min(A(:,15));
latMax = max(A(:,16));
latMin = min(A(:,16));
resolution = 0.001; % default pixel resolution 

%find the number of trajectories;
b=size(A,1);  % the row length of A;
trackNum=1;  %number of trajectories
start=[1];
for i=2:b
    if (A(i,1)~=A(i-1,1))
        trackNum=trackNum+1;
        start=[start,i];  % find the starting row of each trajectory
    end
end

trajectory=cell(1,trackNum);
validTrackCount = 0;
for trajectory_ind=1:trackNum
    trajectoryX=zeros(1,A(start(trajectory_ind),2));
    trajectoryY=zeros(1,A(start(trajectory_ind),2));
    L = length(trajectoryX);
    if L > 1
        validTrackCount = validTrackCount + 1;
        %validTrackIdx(validTrackCount) = trajectory_ind;
        canvasI = zeros(ceil((latMax - latMin) / resolution)+1 , ceil((longMax - longMin) / resolution)+1);
        for i=1:1:length(trajectoryX)
            trajectoryX(i)=A(start(trajectory_ind)+i-1,15);
            trajectoryY(i)=A(start(trajectory_ind)+i-1,16);
            px = ceil((trajectoryX(i) - longMin)/resolution)+1;
            py = ceil((trajectoryY(i) - latMin)/resolution)+1;
            canvasI(py,px) = 1;
        end
        trajectory{trajectory_ind}=struct('trajectoryX',trajectoryX,'trajectoryY',trajectoryY,'trajectoryImg',canvasI,'trajectoryLength',L);
    end
end

function tracks = loadSelectedTracks(trajectory,lengthMin,lengthMax)

trackNum = length(trajectory);
% get size of selected tracks
ind = 0;
for i = 1:trackNum
    if trajectory{i}.trajectoryLength > lengthMin && trajectory{i}.trajectoryLength < lengthMax
        ind = ind + 1;             
    end
end
tracks = cell(1,ind);
ind = 0;
for i = 1:trackNum
    if trajectory{i}.trajectoryLength > lengthMin && trajectory{i}.trajectoryLength < lengthMax
        ind = ind + 1; 
        tracks{ind} = trajectory{i};
    end
end

function dispHist(ax,selectedTracks)

L = length(selectedTracks);
LL = zeros(1,L);
for i = 1:L
  LL(i) = selectedTracks{i}.trajectoryLength;
end
[N,X] = hist(LL);
bar(ax,X,N);
title(ax,'Histogram of Trajectory Length');

function data = loadTSNEData(selectedTracks)
L = length(selectedTracks);
X = zeros(L,numel(selectedTracks{1}.trajectoryImg));
Y = ones(L,1);
for  i = 1 : L
    X(i,:) = selectedTracks{i}.trajectoryImg(:);
end
data.X = X;
data.Y = Y;

function edit_minL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_minL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_minL as text
%        str2double(get(hObject,'String')) returns contents of edit_minL as a double


% --- Executes during object creation, after setting all properties.
function edit_minL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_minL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_maxL_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxL as text
%        str2double(get(hObject,'String')) returns contents of edit_maxL as a double


% --- Executes during object creation, after setting all properties.
function edit_maxL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb2_trackVisuliazation.
function pb2_trackVisuliazation_Callback(hObject, eventdata, handles)
% hObject    handle to pb2_trackVisuliazation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('map');
colormap(map);
ax=handles.axes2_2dOriginal;
minL = str2double(get(handles.edit_minL,'string'));
maxL = str2double(get(handles.edit_maxL,'string'));
if handles.realData.minL_old ~= minL ...
        || handles.realData.maxL_old ~= maxL % minL or maxL is changed
    handles.realData.selectedTracks = loadSelectedTracks(handles.realData.allTracks,minL,maxL);
    handles.realData.tSNE.data = loadTSNEData(handles.realData.selectedTracks);
    handles.realData.maxL_old = maxL;
    handles.realData.minL_old = minL;
end
mapped_X  = run_data_through_network(handles.realData.tSNE.network, handles.realData.tSNE.data.X);
scatter(ax,mapped_X(:,1), mapped_X(:,2), 31, handles.realData.tSNE.data.Y);
handles.realData.tSNE.data.mappedX = mapped_X;
guidata(hObject, handles);
%set(ax,'yticklabel',[]);
%set(ax,'xticklabel',[]);
%set(ax,'xtick',[]);
%set(ax,'ytick',[]);




% --- Executes on button press in pb2_freqPatterns.
function pb2_freqPatterns_Callback(hObject, eventdata, handles)
% hObject    handle to pb2_freqPatterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pb2_trackVisuliazation_Callback(handles.pb2_trackVisuliazation, eventdata, handles)
ax = handles.axes2_2dOriginal;
X = handles.realData.tSNE.data.mappedX;
sigma = str2double(get(handles.edit2_radius,'string'))/3;
clusterSize_min = str2double(get(handles.edit2_minClusterSize,'string'));
cluster = ParticleClustering(ax,X,sigma,clusterSize_min);
if ~isempty(cluster)
    handles.realData.cluster = cluster;
    plotClusterInRed(gca,X,cluster,'',true);
    set(gca,'Xlim',get(ax,'Xlim'));
    set(gca,'Ylim',get(ax,'Ylim'));
    title('Clustering Result'); 
    sortedIdx = sortCluster(cluster);
    handles.realData.clusterSortedIdx = sortedIdx;
    % fill table
    L = length(sortedIdx);
    D = cell(L,3);
    for  i = 1 : L
        D{i,1} = num2str(cluster{sortedIdx(i)}.center);
        D{i,2} = num2str(cluster{sortedIdx(i)}.size);
        D{i,3} = false;
    end
    set(handles.uitable_cluster,'Data',D);
    handles.realData.selectedClusterIdx = [];
end
% clear output folder
delete('./output/*.*');
guidata(hObject, handles);

function edit2_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit2_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2_radius as text
%        str2double(get(hObject,'String')) returns contents of edit2_radius as a double


% --- Executes during object creation, after setting all properties.
function edit2_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_minClusterSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit2_minClusterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2_minClusterSize as text
%        str2double(get(hObject,'String')) returns contents of edit2_minClusterSize as a double


% --- Executes during object creation, after setting all properties.
function edit2_minClusterSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2_minClusterSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plotClusterInRed(ax,X,cluster,color,reset)
colors = ['b','g','r','c','m','y','k'];
if reset
    cla(ax);
end
hold(ax,'on');
L = length(cluster);
for i = 1:L
    LL = length(cluster{i}.idx);
    if isempty(color)
        c = colors(mod(i,7)+1);
    else
        c = color;
    end
    for j = 1:LL
        plot(ax,X(cluster{i}.idx(j),1),X(cluster{i}.idx(j),2),[c,'o'],'markersize',5);
    end
end
hold(ax,'off');

function plotSeletectedTracks(ax,selectedTracks,idx,fileName)
cla(ax,'reset');
numTracks = length(idx);
h = waitbar(0,'Plotting trajectories...');
for i = 1:numTracks
    if rem(i,2000) == 0
    waitbar(i/numTracks,h)
    end
    plot(ax,selectedTracks{idx(i)}.trajectoryX,selectedTracks{idx(i)}.trajectoryY,'r-','linewidth',2);
    if i == 1
         hold(ax,'on');
    end
end
close(h);
hold(ax,'off');
tic;
h = waitbar(0.1,'Loading Google Map');
plot_google_map_2('Axis',ax,'MapType','hybrid','autoAxis',1,'Alpha',1,'fileName', fileName); % roadmap, satellite, terrain, hybrid
close(h);
toc;
title(ax,[num2str(numTracks),' trajectories loaded.']);

% --- Executes when selected cell(s) is changed in uitable_cluster.
function uitable_cluster_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_cluster (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if isempty(eventdata.Indices)
return
end
ax = handles.axes_realData;
tableData = get(hObject,'Data');
if eventdata.Indices(2) == 3 % check/uncheck selection
    tableData{eventdata.Indices(1),eventdata.Indices(2)} = ~tableData{eventdata.Indices(1),eventdata.Indices(2)};
end
set(hObject,'Data',tableData);
fileName = [[pwd,'\output\Cluster_'],num2str(eventdata.Indices(1))];
selectedTracks = handles.realData.selectedTracks;
mappedX = handles.realData.tSNE.data.mappedX;
clusters = handles.realData.cluster;
clusterSortedIdx = handles.realData.clusterSortedIdx;
selectedClusterIdx = clusterSortedIdx(eventdata.Indices(1));
trackIdx = clusters{selectedClusterIdx}.idx;
plotClusterInRed(handles.axes2_2dOriginal,mappedX,clusters(selectedClusterIdx),'k',false);
if isfield(handles.realData,'selectedClusterIdx')
    oldSelectedClusterIdx = handles.realData.selectedClusterIdx;
else
   oldSelectedClusterIdx = [];    
end
handles.realData.selectedClusterIdx = selectedClusterIdx;
if ~isempty(oldSelectedClusterIdx)
    plotClusterInRed(handles.axes2_2dOriginal,mappedX,clusters(oldSelectedClusterIdx),'r',false);
end
if exist([fileName,'.jpg'],'file')
    II = imread([fileName,'.jpg']);
    hold(ax,'off');
    imshow(II,[],'parent',ax);
    guidata(hObject, handles);
    %set(ax,'YDir','normal');
    return
end

plotSeletectedTracks(ax,selectedTracks,trackIdx,[fileName,'.jpg']);
saveClusterCenter2Jason(mappedX,selectedTracks,trackIdx,fileName);
guidata(hObject, handles);


% --- Executes on button press in pb_DDFSend.
function pb_DDFSend_Callback(hObject, eventdata, handles)
% hObject    handle to pb_DDFSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% movefile('./output/*.jpg','C:\DIB\ddf-2.9.3\ddf-2.9.3\inbox');

% get list of files to be sent
tbData = get(handles.uitable_cluster,'Data');
[m,n]  = size(tbData);
% if n == 3
%      msgbox('No cluster is selected. No file is sent to DDF.','Send to DDF');
%      return
% end
fileNamePre = [pwd,'\output\Cluster_'];
fileList = '';
fileList2 = '';
j = 0;
for i = 1:m
    if tbData{i,3} == true
        j = j+1;
        fileList{j}=[fileNamePre,num2str(i),'.jpg'];
        fileList2{j}=[fileNamePre,num2str(i),'.json'];
    end
end
ddfIP = get(handles.edit_ddfIP,'string');
ddfPort = get(handles.edit_ddfPort,'string');
ddfCommand = ['java -jar ./tools/DDFAgent-1.0-Beta-jar-with-dependencies.jar -url https://',ddfIP,':',ddfPort,' -o file -file '];

for i = 1:j
    h = msgbox(['Uploading ',fileList{i},' to DDF...'],'Send to DDF');
    [status, cmdOut] = system([ddfCommand,'"',fileList{i},'"']);
    close(h);
    h = msgbox(['Uploading ',fileList2{i},' to DDF...'],'Send to DDF');
    [status, cmdOut] = system([ddfCommand,fileList2{i}]);
    close(h);
end

% Call DDFAgent-1.0-Beta-jar-with-dependencies.jar to send to DDF

        



% --- Executes during object creation, after setting all properties.
function uitable_cluster_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable_cluster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_ddfIP_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ddfIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ddfIP as text
%        str2double(get(hObject,'String')) returns contents of edit_ddfIP as a double


% --- Executes during object creation, after setting all properties.
function edit_ddfIP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ddfIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ddfPort_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ddfPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ddfPort as text
%        str2double(get(hObject,'String')) returns contents of edit_ddfPort as a double


% --- Executes during object creation, after setting all properties.
function edit_ddfPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ddfPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function saveClusterCenter2Jason(mappedX,selectedTracks,trackIdx,fileName)
clusterCenter = mean(mappedX(trackIdx,:));
D = sum((mappedX(trackIdx,:) - ones(length(trackIdx),1)*clusterCenter).^2,2);
[val,ind] = min(D);
trajectory{1}(:,1) = selectedTracks{trackIdx(ind)}.trajectoryX;
trajectory{1}(:,2) = selectedTracks{trackIdx(ind)}.trajectoryY;
write2json(trajectory,fileName);


    


% --- Executes on button press in pb_ERM.
function pb_ERM_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ERM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ERM_kitware(handles);


% --- Executes on button press in pb_LMDB.
function pb_LMDB_Callback(hObject, eventdata, handles)
% hObject    handle to pb_LMDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_AddLandmarks;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over tab2text.
function tab2text_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to tab2text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
