function varargout = ERM_kitware(varargin)
% ERM_kitware MATLAB code for ERM_kitware.fig
%      ERM_kitware, by itself, creates a new ERM_kitware or raises the existing
%      singleton*.
%
%      H = ERM_kitware returns the handle to a new ERM_kitware or the handle to
%      the existing singleton*.
%
%      ERM_kitware('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERM_kitware.M with the given input arguments.
%
%      ERM_kitware('Property','Value',...) creates a new ERM_kitware or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ERM_kitware_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ERM_kitware_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ERM_kitware

% Last Modified by GUIDE v2.5 14-Apr-2017 15:38:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ERM_kitware_OpeningFcn, ...
    'gui_OutputFcn',  @ERM_kitware_OutputFcn, ...
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


% --- Executes just before ERM_kitware is made visible.
function ERM_kitware_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ERM_kitware (see VARARGIN)


% Database related information
handles.DB.username = 'root';
handles.DB.password = 'M4SF5%Td';
handles.DB.driver = 'com.mysql.jdbc.Driver';
handles.path.WAMI_IMG = 'H:\WPAFB-21Oct2009\Data\registered_ref100';
javaclasspath('C:\Program Files\MySQL\mysql-connector-java-5.1.40\mysql-connector-java-5.1.40-bin.jar');
handles.radioButtonColor{1} = RadioButtonColors('WHITE');
handles.radioButtonColor{2} = RadioButtonColors('BLACK');
handles.radioButtonColor{3} = RadioButtonColors('RED');
handles.radioButtonColor{4} = RadioButtonColors('GREEN');
set(handles.rb_DB,'CData',handles.radioButtonColor{1});
set(handles.rb_DB,'string','Database status');
set(handles.pb_connect,'enable','off');
set(handles.pb_disconnect,'enable','off');

% set custom buttons
set(handles.togglebutton1,'CData',imread('play.jpg'));
set(handles.pb_stop,'CData',imread('Stop.jpg'));
set(handles.slider1,'Value',100);

% load background Image
try
    handles.path.imageFolder = 'C:\Users\Huamei Chen\OneDrive\Documents\IFI\HardSoftBAAProject\Report\Haibin\for Kyle\data_100-299';
    handles.data.Img = imread([handles.path.imageFolder,'\100.jpg']);
catch ME
    s = regexp(pwd,'\', 'split')
    imageFolder = '';
    for i = 1:length(s)
        if ~strcmp(s{i},'Report')
            imageFolder = [imageFolder,s{i},'\'];
        else
            imageFolder = [imageFolder,s{i},'\Haibin\for Kyle\data_100-299'];
            handles.path.imageFolder = imageFolder;
            handles.data.Img = imread([handles.path.imageFolder,'\100.jpg']);
            break
        end
    end
end

% Choose default command line output for ERM_kitware
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ERM_kitware wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ERM_kitware_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_dataSource.
function pb_dataSource_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dataSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile({'*.kw18';'*.mat';'*.txt'}, 'Trajectory file');
if FILENAME ~= 0
    handles.files.trajectory = fullfile(PATHNAME,FILENAME);
    set(handles.edit_trackFile,'string',handles.files.trajectory);
    [path,name,ext] = fileparts(FILENAME);
    switch name
        case 'PVO_UTIL0_session_514' % Same database for now
            handles.DB.dbname = 'mifs_s';
            handles.DB.dburl =['jdbc:mysql://localhost:3306/' handles.DB.dbname];%
            set(handles.pb_connect,'enable','on');
            set(handles.rb_DB,'CData',handles.radioButtonColor{3}); % red
            set(handles.rb_DB,'string','DB disconnected');
        case 'kw18_100-299' % Database mifs_s
            handles.DB.dbname = 'mifs_s';
            handles.DB.dburl =['jdbc:mysql://localhost:3306/' handles.DB.dbname];%
            set(handles.pb_connect,'enable','on');
            set(handles.rb_DB,'CData',handles.radioButtonColor{3}); % red
            set(handles.rb_DB,'string','DB disconnected');
        otherwise
    end
else
    msgbox('No file selected','Trajectory file selection','warn');
end

guidata(hObject, handles);

function edit_trackFile_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trackFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trackFile as text
%        str2double(get(hObject,'String')) returns contents of edit_trackFile as a double


% --- Executes during object creation, after setting all properties.
function edit_trackFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trackFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Min as text
%        str2double(get(hObject,'String')) returns contents of edit_Min as a double


% --- Executes during object creation, after setting all properties.
function edit_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Total_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Total as text
%        str2double(get(hObject,'String')) returns contents of edit_Total as a double


% --- Executes during object creation, after setting all properties.
function edit_Total_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Total (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Max as text
%        str2double(get(hObject,'String')) returns contents of edit_Max as a double


% --- Executes during object creation, after setting all properties.
function edit_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pb_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.rb_DB,'CData',handles.radioButtonColor{3}); % red
set(handles.rb_DB,'string','Database disconnected');
set(handles.pb_connect,'enable','on');
set(handles.pb_disconnect,'enable','off');
close(handles.DB.conn);
handles.DB.conn = '';
guidata(hObject, handles);


% --- Executes on button press in pb_connect.
function pb_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dbname = handles.DB.dbname;
username = handles.DB.username;
password = handles.DB.password;
driver = handles.DB.driver;
dburl = handles.DB.dburl;
conn = database(dbname, username, password, driver, dburl);
if isempty(conn.Message) % connectted succefully
    set(handles.rb_DB,'CData',handles.radioButtonColor{4}); % green
    set(handles.rb_DB,'string','Database connected');
    set(handles.pb_connect,'enable','off');
    set(handles.pb_disconnect,'enable','on');
    handles.DB.conn = conn;
    % set trajectory info
    handles = setTrackInfo(handles);
    
    % set Landmarks table
    handles = setLandmarksTB(handles);
    
    % plot Google map image
    handles = setWAMIBackground(handles);
    
    % plot Landmarks
    showLandmark(handles,handles.data.landmarks);
    
    % populate PoL Analysis Criteria
    handles = initPoLCriteria(handles);
    
else
    msgbox(conn.Message,'Database connection status','warn');
end
guidata(hObject, handles);



% ===== non-callback functions ==========%
function handles = initPoLCriteria(handles)
L_min = str2double(get(handles.edit_Min,'string'));
L_max = str2double(get(handles.edit_Max,'string'));
PoL_min = L_min + round(0.2*(L_max-L_min));
PoL_max = L_max - round(0.2*(L_max-L_min));
set(handles.edit_PoL_Min,'string',num2str(PoL_min));
set(handles.edit_PoL_Max,'string',num2str(PoL_max));
LM = handles.data.landmarks;
set(handles.pm_landmarks,'Value',1);
set(handles.pm_landmarks,'String',LM(1:size(LM,1)));
set(handles.listbox_selectedLM,'String','');
%set(handles.listbox_selectedLM,'Value',1);
return

function handles = setWAMIBackground(handles)
% set scope
conn = handles.DB.conn;
sql = 'select max(lat) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    lat_max = m.Data{1};
else
    msgbox(conn.Message,sql,'error');
end

sql = 'select min(lat) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    lat_min = m.Data{1};
else
    msgbox(conn.Message,sql,'error');
end

sql = 'select max(lon) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    lon_max = m.Data{1};
else
    msgbox(conn.Message,sql,'error');
end

sql = 'select min(lon) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    lon_min = m.Data{1};
else
    msgbox(conn.Message,sql,'error');
end
ax = handles.axes_Img;
cla(ax);
handles.mapHandle.landmark = plot(ax,[lon_min,lon_max],[lat_min,lat_max],'.');hold on;
handles.mapHandle.solidLandmark = plot(ax,[lon_min,lon_max],[lat_min,lat_max],'.');hold off;
YLim = [lat_min,lat_max];
XLim = [lon_min,lon_max];
set(ax,'XLim',XLim,'YLim',YLim);
mapType = 'hybrid';
%handles.mapHandle.googlemap = plot_google_map('Axis',ax,'MapType',mapType,'autoAxis',0,'Alpha',1); % roadmap, satellite, terrain, hybrid
[lonVect, latVect, uniImag] = plot_google_map('Axis',ax,'MapType',mapType,'autoAxis',0,'Alpha',1);
h = image(lonVect,latVect,uniImag, 'Parent', ax);
uistack(h,'bottom')
handles.mapHandle.googlemap.h = h;
%handles.mapHandle.googlemap.uniImag = uniImag;
handles.mapHandle.googlemap.lonVect = lonVect;
handles.mapHandle.googlemap.latVect = latVect;
handles.mapHandle.trafficFlow = '';
% layer2 = ones(1280,1280,3);
% LL =600;
% layer2(640-LL:640+LL,640-LL:640+LL,2:3) = 0;
% h2 = image(lonVect,latVect,layer2, 'Parent', ax);
% set(h2,'CData',layer2);
% set(h2,'AlphaData',0.5);
return

function handles = setLandmarksTB(handles)
conn = handles.DB.conn;
sql = 'SELECT name,lat,lng FROM googlelandmarks;';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    data = m.Data;
    L = size(data,1);
    for i = 1:L
        data{i,4} = true;
    end
    set(handles.uitb_landmarks,'Data',data);
    handles.data.landmarks = data;
    handles.auxData.largeLandmarkIdx = zeros(size(data,1),1);
else
    msgbox(conn.Message,sql,'error');
end
return

function handles = setTrackInfo(handles)
conn = handles.DB.conn;
sql = 'select distinct(track_id) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    set(handles.edit_Total,'string',num2str(length(m.Data)));
else
    msgbox(conn.Message,sql,'error');
end
sql = 'select max(track_length) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    set(handles.edit_Max,'string',num2str(m.Data{1}));
else
    msgbox(conn.Message,sql,'error');
end
sql = 'select min(track_length) from kitwaredata';
m = exec(conn,sql);
m = fetch(m);
if isempty(m.Message)
    set(handles.edit_Min,'string',num2str(m.Data{1}));
else
    msgbox(conn.Message,sql,'error');
end
return

function  basecir = RadioButtonColors(color)
tmp1=[196 193 190 207 62 86 91 67 212 191 195 201;...
    196 206 32 61 166 186 190 166 59 33 205 190;...
    199 38 180 209 227 229 232 231 215 179 35 198;...
    219 71 215 250 255 255 251 253 252 215 61 210;...
    67 169 230 250 255 255 254 255 253 225 167 62;...
    87 186 227 255 254 248 255 253 253 227 186 88;...
    86 191 227 253 252 255 255 251 252 228 186 86;...
    64 166 226 252 255 253 251 254 254 226 168 67;...
    219 64 215 254 255 253 252 255 253 213 60 211;...
    197 38 176 215 226 231 230 225 214 174 36 194;...
    196 206 34 65 169 189 190 163 60 35 207 193;...
    199 190 195 210 67 88 86 64 214 195 193 204];

tmp2=[191 191 195 182 0 0 0 0 184 193 191 193;...
    190 186 0 0 36 30 30 30 0 0 185 185;...
    189 0 37 15 16 7 9 17 17 37 0 194;...
    179 0 16 0 4 1 0 0 0 17 0 180;...
    0 33 16 0 2 1 0 0 0 15 38 0;...
    0 30 7 3 0 0 1 0 0 9 34 0;...
    0 36 10 2 0 3 4 0 0 9 31 0;...
    0 33 14 1 4 2 0 2 2 14 34 0;...
    183 0 17 0 3 0 0 2 0 17 0 181;...
    188 0 32 17 13 9 11 12 18 31 0 192;...
    190 186 0 0 34 32 36 33 0 0 185 184;...
    193 186 195 181 0 0 0 0 183 192 184 193];

tmp3 =[197 194 189 177 0 0 0 0 181 190 188 191;
    194 187 0 0 34 31 32 32 0 0 184 182;
    190 0 29 5 9 4 10 17 16 35 0 193;
    180 0 11 0 0 0 0 1 0 16 0 178;
    0 35 18 0 4 3 5 6 2 14 33 0;
    0 33 9 5 2 0 5 3 2 7 29 0;
    0 40 5 0 0 0 1 0 0 7 29 0;
    0 36 10 0 0 0 0 0 1 13 35 0;
    185 0 16 0 0 0 0 4 3 19 0 181;
    189 0 32 16 7 4 9 14 20 33 0 193;
    192 187 0 0 28 27 34 31 0 0 187 187;
    197 187 193 175 0 0 0 0 178 187 185 197];

switch color
    case 'RED'
        basecir(:,:,1) = tmp1;
        basecir(:,:,2) = tmp2;
        basecir(:,:,3) = tmp3;
    case 'GREEN'
        basecir(:,:,1) = tmp2;
        basecir(:,:,2) = tmp1;
        basecir(:,:,3) = tmp3;
    case 'BLACK'
        basecir(:,:,1) = tmp2;
        basecir(:,:,2) = tmp2;
        basecir(:,:,3) = tmp2;
    otherwise % WHITE
        basecir(:,:,1) = tmp1;
        basecir(:,:,2) = tmp1;
        basecir(:,:,3) = tmp1;
end
basecir=uint8(basecir);



function edit_PoL_Min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PoL_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PoL_Min as text
%        str2double(get(hObject,'String')) returns contents of edit_PoL_Min as a double


% --- Executes during object creation, after setting all properties.
function edit_PoL_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PoL_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_PoL_Max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_PoL_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_PoL_Max as text
%        str2double(get(hObject,'String')) returns contents of edit_PoL_Max as a double


% --- Executes during object creation, after setting all properties.
function edit_PoL_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_PoL_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pm_landmarks.
function pm_landmarks_Callback(hObject, eventdata, handles)
% hObject    handle to pm_landmarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_landmarks contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_landmarks


% --- Executes during object creation, after setting all properties.
function pm_landmarks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_landmarks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_selectedLM.
function listbox_selectedLM_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_selectedLM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_selectedLM contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_selectedLM


% --- Executes during object creation, after setting all properties.
function listbox_selectedLM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_selectedLM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_add.
function pb_add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

from_data = get(handles.pm_landmarks,'String');
from_idx = get(handles.pm_landmarks,'Value');
handles.auxData.largeLandmarkIdx(from_idx) = 1;
showLargeLandmark(handles,handles.auxData.largeLandmarkIdx);
tmp = get(handles.listbox_selectedLM,'String');
if iscell(tmp)
    to_data = tmp;
else
    to_data{1} = tmp;
end
if isempty(to_data{end})
    to_data{end} = from_data{from_idx};
else
    to_data{end+1} = from_data{from_idx};
end
handles.auxData.selectedLMIdx(length(to_data)) = from_idx;
set(handles.listbox_selectedLM,'value',length(to_data));
set(handles.listbox_selectedLM,'String',to_data);
guidata(hObject, handles);


% --- Executes on button press in pb_remove.
function pb_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.listbox_selectedLM,'String');
idx = get(handles.listbox_selectedLM,'Value');
k = 1;
newData = '';
for i = 1:length(data)
    if i~=idx
        newData{k} = data{i};
        k = k+1;
    else
        handles.auxData.largeLandmarkIdx(handles.auxData.selectedLMIdx(i))=0;
        handles.auxData.selectedLMIdx = removeItem(handles.auxData.selectedLMIdx,i);% remove the ith item in the first input
    end
end
set(handles.listbox_selectedLM,'String',newData);
if idx > length(newData)
    set(handles.listbox_selectedLM,'Value',idx-1);
end
showLargeLandmark(handles,handles.auxData.largeLandmarkIdx);
guidata(hObject, handles);


% --- Executes on button press in pb_run.
function pb_run_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
%===> Step 1: Build SQL to quiry DB
%
sql_select = 'SELECT DISTINCT(track_id) FROM kitwaredata ';
% min length
L_min = get(handles.edit_PoL_Min,'string');
sql_min = ['WHERE track_length > ', L_min,' '];
% max length
L_max = get(handles.edit_PoL_Max,'string');
sql_max = ['AND track_length < ',L_max,' '];

sql_complete = [sql_select,sql_min,sql_max];

% pass through
LM = handles.data.landmarks;
solidLandmarks = handles.auxData.largeLandmarkIdx;
if sum(solidLandmarks) > 0 % Do have passing through LM requirement
    j = 1;
    for i = 1:size(LM,1)
        if solidLandmarks(i) == 1
            sql_LM{j} = ['AND track_id IN (',sql_select,' WHERE pow(lat-',num2str(LM{i,2}),',2)+pow(lon-',num2str(LM{i,3}),',2) < 0.000001) '];
            sql_complete = [sql_complete,sql_LM{j}];
            j = j+1;
        end
    end
end

conn = handles.DB.conn;

% for creating a table, use the following statement
% m = exec(conn,'CREATE TABLE mifs_s.new_table_01 (id INT NOT NULL, col_01 VARCHAR(45) NULL);');
%

m = exec(conn,sql_complete);
m = fetch(m);
selectedTracks = '';
if isempty(m.Message)
    selectedTracks = m.Data;
else
    msgbox(m.Message,'Execute','error');
    return
end

if length(selectedTracks) == 1 && strcmp(selectedTracks{1},'No Data')
    msgbox(selectedTracks{1},'Execute','warn');
    return
end
%
%===> Step 2: Build SQL to get selected tracks
%
numTracks = length(selectedTracks);
sql_select = 'SELECT lat, lon FROM kitwaredata WHERE track_id = ';
h = waitbar(0,'Retrieving trajectories...');
for i = 1:numTracks
    waitbar(i/numTracks,h);
    sql_complete = [sql_select,num2str(selectedTracks{i}),' ORDER BY pt_id'];
    m = exec(conn,sql_complete);
    m = fetch(m);
    tracks{i}.ID = selectedTracks{i};
    tmpLat = cell2mat(m.Data(:,1));
    tmpLon = cell2mat(m.Data(:,2));
    idx = tmpLat~=0 & tmpLon~=0;
    tracks{i}.img_x = tmpLon(idx);
    tracks{i}.img_y = tmpLat(idx);
end
close(h);

%
%==> Step 3: Plot tracks
%
h2 = figure;
copyobj(handles.axes_Img,h2);
ax2 = gca;
set(ax2,'Position',[0.05 0.05 .9 .9]);
for i = 1:numTracks
    plot( ax2,tracks{i}.img_x, tracks{i}.img_y,'g-','linewidth',1);
end

% re-plot large landmarks


% ==> Step 4: Populate results in uitb_result
L = length(tracks);
Data = cell(L,2);
for i = 1:L
    Data{i,1} = num2str(tracks{i}.ID);
    Data{i,2} = num2str(length(tracks{i}.img_x));
end
set(handles.uitb_result,'Data',Data);

% Step 5: Polulate results in popup menu
set(handles.pm_ID,'string',Data(:,1));
set(handles.pm_ID,'value',1);

guidata(hObject, handles);




function pm_ID_Callback(hObject, eventdata, handles)
% hObject    handle to pm_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pm_ID as text
%        str2double(get(hObject,'String')) returns contents of pm_ID as a double


% --- Executes during object creation, after setting all properties.
function pm_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_play.
function pb_play_Callback(hObject, eventdata, handles)
% hObject    handle to pb_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% selected track_id
track_ids = get(handles.pm_ID,'string');
v = get(handles.pm_ID,'value');
track_id = track_ids{v};

% retrieve trajectory
conn = handles.DB.conn;
sql_select = 'SELECT frame_number, img_bbox_TL_x, img_bbox_TL_y, img_bbox_BR_x, img_bbox_BR_y  FROM kitwaredata WHERE track_id = ';
sql_complete = [sql_select,track_id];
m = exec(conn,sql_complete);
m = fetch(m);
frameNum = cell2mat(m.Data(:,1));
    TL_x = cell2mat(m.Data(:,2));
    TL_y = cell2mat(m.Data(:,3));
    BR_x = cell2mat(m.Data(:,4));
    BR_y = cell2mat(m.Data(:,5));

L = length(frameNum);
imgFolder = handles.path.WAMI_IMG;
if ~exist(imgFolder)
    directoryname = uigetdir('C:\IFT', 'Please specify the folder where the WPAFB09 data is in!');
    if directoryname == 0
        return
    else
        imgFolder = directoryname;
        handles.path.WAMI_IMG = imgFolder;
    end
end
    
imgPrefix = 'output_';
x_min = [];
x_max = [];
y_min = [];
y_max = [];
DX = 400;
DY = 400;
imgW = 26368;
imgH = 21248;
h = figure();
margin = 200;
for i = 1:L
    fullFileName = [imgFolder,'\',imgPrefix,num2str(frameNum(i)),'.jp2'];
    if isempty(x_min) || outOfScope([x_min,x_max,y_min,y_max],[TL_x(i),BR_x(i),BR_y(i),TL_y(i)],margin)
        x_min = max(1,TL_x(i)-DX);
        x_max = min(imgW,BR_x(i)+DX);
        y_min = max(1,TL_y(i)-DY);
        y_max = min(imgH,BR_y(i)+DY);
    end
    img = imread(fullFileName,'PixelRegion',{[y_min,y_max],[x_min,x_max]});
    img = insertShape(img,'Rectangle',[TL_x(i)-x_min,TL_y(i)-y_min,BR_x(i)-TL_x(i),BR_y(i)-TL_y(i)],'LineWidth',2);
    figure(h);imshow(img);    
    pause(0.4);
    drawnow;
end
guidata(hObject, handles);

    

function out = outOfScope(XY,xy,margin)

% XY is scope in [min_x,max_x,min_y,max_y]
% xy is BBox in the same order
%
out = false;
if (xy(1) - margin) <XY(1) || (xy(2)+margin) > XY(2) || (xy(3)-margin)<XY(3) || (xy(4)+margin) > XY(4)
    out = true;
end
return





% --- Executes on button press in pb_activity.
function pb_activity_Callback(hObject, eventdata, handles)
% hObject    handle to pb_activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% selected track_id
track_ids = get(handles.pm_ID,'string');
v = get(handles.pm_ID,'value');
track_id = track_ids{v};

% retrieve trajectory
conn = handles.DB.conn;
sql_select = 'SELECT img_loc_x, img_loc_y, lat,lon FROM kitwaredata WHERE track_id = ';
sql_complete = [sql_select,track_id];
m = exec(conn,sql_complete);
m = fetch(m);
tmpLat = cell2mat(m.Data(:,3));
tmpLon = cell2mat(m.Data(:,4));
imgX = cell2mat(m.Data(:,1));
imgY = cell2mat(m.Data(:,2));
traceXY = [imgX,imgY];
traceLonLat = [tmpLon,tmpLat];

% get activity vector
var = getVar();
activity = getActivity(traceXY, var);
drawTrace(traceLonLat, activity, var);  

function var = getVar()

var.draw_segment =              false;
var.draw_activity =             true;
var.draw_legend =               true;
var.use_sp_line_fit =           false;

var.stay_threshold =            1.0/5;
var.speed_change_threshold =    0.02; % ratio
var.turning_threshold =         25; % degrees
var.entry_seq_length =          0.33333;
var.exit_seq_length =           0.33333;
var.start_end_seq_len =         8;
var.smooth_points =             4; % used by spcrv
var.C =                         50;

var.img_path =                  './image';
var.line_width =                12;
if isunix
    var.font =                  'UbuntuMono-B';
else
    var.font =                  'Consolas Bold';
end

var.ENTRY =         1;
var.EXIT =          2;
var.STAY =          3;
var.LEFT_TURN =     4;
var.RIGHT_TURN =    5;
var.ACCELERATE =    6;
var.SLOWDOWN =      7;
var.UNKOWN =        -1;

% --- Executes when entered data in editable cell(s) in uitb_landmarks.
function uitb_landmarks_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitb_landmarks (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

data=get(hObject,'Data');
if eventdata.EditData == 1
    data{eventdata.Indices(1),eventdata.Indices(2)} = true;
else
    data{eventdata.Indices(1),eventdata.Indices(2)} = false;
end
set(hObject,'Data',data);
showLandmark(handles,data);
guidata(hObject, handles);

function showLandmark(handles,data)
L = size(data,1);
xi = [];
yi=[];
for i = 1:L
    if data{i,4} == true
        xi=[xi,data{i,3}];
        yi=[yi,data{i,2}];
    end
end
set(handles.mapHandle.landmark,'Xdata',xi,'Ydata',yi,'Marker','o','MarkerFaceColor','blue','Color',[1 0 0]);

function showLargeLandmark(handles,solidLandmark)
landmarks = handles.data.landmarks;
xi=[];
yi=[];
L = length(landmarks);
for i = 1:L
    if solidLandmark(i) == 1
        xi = [xi,landmarks{i,3}];
        yi = [yi,landmarks{i,2}];
    end
end
set(handles.mapHandle.solidLandmark,'XData',xi,'YData',yi,'Marker','o','MarkerFaceColor','green','Color',[1 0 0],'MarkerSize',10,'LineWidth',2);


function newArray = removeItem(inputArray,i)
L = length(inputArray);
newArray = zeros(1,L-1);
k = 1;
for j = 1:L
    if j ~= i
        newArray(k)=inputArray(j);
        k = k+1;
    end
end

function drawTrace(trace, activity, var)

color_name = colormap(lines);
trace_length = size(trace, 1);

color_value = zeros(trace_length, 3);
for i = 1 : trace_length
    if activity(i, 1) < 1
        color_value(i, :) = [0, 0, 0] * 255;
    else
        color_value(i, :) = color_name(activity(i, 1), :) * 255;
    end
end
%centers = [trace(:, 10) + trace(:, 12), trace(:, 11) + trace(:, 13)]/2;
trace = fitTrace(trace, var);
figure;
L = length(trace);
for i = 1:L-1
    plot(trace(i:i+1,1),trace(i:i+1,2),'Color', color_value(i,:)/255,'LineWidth', 2);hold on;
end
plot_google_map('Axis',gca,'MapType','satellite','autoAxis',0,'Alpha',1);
drawLegend(gca, var)


function drawLegend(ax, var)

color_name = colormap(lines);
XLim = get(ax,'XLim');
YLim = get(ax,'YLim');
X = XLim(2);
Y = YLim(2);
dY = (YLim(1)- YLim(2))/15;
dX = (XLim(2)- XLim(1))/100;
X = X+dX;
text(X,Y,'ENTRY','color',color_name(var.ENTRY, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'EXIT','color',color_name(var.EXIT, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'STAY','color',color_name(var.STAY, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'LEFT TURN','color',color_name(var.LEFT_TURN, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'RIGHT TURN','color',color_name(var.RIGHT_TURN, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'ACCELERATE','color',color_name(var.ACCELERATE, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'SLOWDOWN','color',color_name(var.SLOWDOWN, :),'fontsize',10);
Y = Y+dY;
text(X,Y,'NORMAL','color',[0,0,0],'fontsize',10);






% format_str = '%-12s';
% text_str = { sprintf(format_str, 'ENTRY'), sprintf(format_str, 'EXIT'), ...
%     sprintf(format_str, 'STAY'), sprintf(format_str, 'LEFT_TURN'), ...
%     sprintf(format_str, 'RIGHT_TURN'), sprintf(format_str, 'ACCELERATE'), ...
%     sprintf(format_str, 'SLOWDOWN'), sprintf(format_str, 'NORMAL')};
% position = [];
% panelHeight = 250;
% for ii=1 : size(text_str, 2)
%     position = [position; [100, (ii - 1) * panelHeight + 100]];
% end
% box_color = [];
% box_color(end + 1, :) = color_name(var.ENTRY, :) * 255;
% box_color(end + 1, :) = color_name(var.EXIT, :) * 255;
% box_color(end + 1, :) = color_name(var.STAY, :) * 255;
% box_color(end + 1, :) = color_name(var.LEFT_TURN, :) * 255;
% box_color(end + 1, :) = color_name(var.RIGHT_TURN, :) * 255;
% box_color(end + 1, :) = color_name(var.ACCELERATE, :) * 255;
% box_color(end + 1, :) = color_name(var.SLOWDOWN, :) * 255;
% box_color(end + 1, :) = [255, 255, 255];
% 
% RGB = insertText(img, position, text_str, 'Font', var.font, ...
%     'FontSize', 150, 'BoxColor', box_color, 'BoxOpacity', 1, 'TextColor', 'black');


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


set(handles.edit_currentFrame,'string',num2str(round(get(hObject,'Value'))));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pb_flow.
function pb_flow_Callback(hObject, eventdata, handles)
% hObject    handle to pb_flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imgFolder = handles.path.WAMI_IMG;
imgPrefix = 'output_';
min_i = 100;
max_i = 1123;


function edit_currentFrame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_currentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_currentFrame as text
%        str2double(get(hObject,'String')) returns contents of edit_currentFrame as a double


% --- Executes during object creation, after setting all properties.
function edit_currentFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_currentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1

if get(hObject,'Value') == 1
    set(hObject,'CData',imread('pause.jpg'));
    if get(handles.dummyRun,'Value') == 0
        set(handles.dummyRun,'Value',1);
    end
    playTraffic(handles);
else
    set(hObject,'CData',imread('play.jpg'));
end


function playTraffic(handles)
 
imgFolder = handles.path.WAMI_IMG;
imgPrefix = 'output_';
while get(handles.slider1,'value') < get(handles.slider1,'Max')
    % check if stop button is pressed
    if get(handles.dummyRun,'Value') == 0
        set(handles.togglebutton1,'CData',imread('play.jpg'));
        set(handles.togglebutton1,'Value',0);
        % reset Google Map
        uistack(handles.mapHandle.trafficFlow,'bottom');
        break
    end
    if get(handles.togglebutton1,'value') == 0
            % pause; do noting
            pause(1);
    else
        handles = playTrafficAtFrameNum(handles,round(get(handles.slider1,'value')));
        set(handles.slider1,'value',1+get(handles.slider1,'value'));
        set(handles.edit_currentFrame,'string',num2str(round(get(handles.slider1,'value'))));
    end
end
set(handles.togglebutton1,'CData',imread('play.jpg'));
set(handles.togglebutton1,'Value',0);
%set(handles.dummySlider,'value',1);
set(handles.slider1,'value',get(handles.slider1,'min'));
set(handles.dummyRun,'Value',0);
set(handles.edit_currentFrame,'string',num2str(get(handles.slider1,'min')));

function handles = playTrafficAtFrameNum(handles,frameNum)

ax = handles.axes_Img;
lonVect = handles.mapHandle.googlemap.lonVect;
latVect = handles.mapHandle.googlemap.latVect;
max_lat = latVect(1);
min_lon = lonVect(1);
diffLon = mean(diff(lonVect));
diffLat = mean(diff(latVect));

% retrieve track points
conn = handles.DB.conn;
sql_select = 'SELECT lat,lon FROM kitwaredata WHERE frame_number = ';
sql_complete = [sql_select,num2str(frameNum)];
m = exec(conn,sql_complete);
m = fetch(m);
tmpLat = cell2mat(m.Data(:,1));
tmpLon = cell2mat(m.Data(:,2));
imgX = round((tmpLon - min_lon)/diffLon);
imgY = round((tmpLat - max_lat)/diffLat);

% make traffic layer
img_W = length(lonVect);
img_H = length(latVect);
layer2 = ones(img_H,img_W,3);
L = length(imgX);
LL = 2;
for i = 1:L
    layer2(max(1,imgY(i)-LL):min(imgY(i)+LL,img_H),max(1,imgX(i)-LL):min(img_W,imgX(i)+LL),2:3) = 0;    
end
layer2(:,:,2) = conv2(layer2(:,:,2),ones(5)/25,'same');
layer2(:,:,3) = conv2(layer2(:,:,3),ones(5)/25,'same');


if isempty(handles.mapHandle.trafficFlow)
    handles.mapHandle.trafficFlow = image(lonVect,latVect,layer2, 'Parent', ax); 
    set(handles.mapHandle.trafficFlow,'AlphaData',0.4);
    %uistack(handles.mapHandle,'top');
    %uistack(handles.mapHandle.trafficFlow,'top');
else
    set(handles.mapHandle.trafficFlow,'CData',layer2);
end
drawnow;



return



% --- Executes on button press in pb_stop.
function pb_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.dummyRun,'Value') == 1
    set(handles.dummyRun,'Value',0);
end

% --- Executes on button press in dummyRun.
function dummyRun_Callback(hObject, eventdata, handles)
% hObject    handle to dummyRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dummyRun


% --- Executes during object creation, after setting all properties.
function dummyRun_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dummyRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
