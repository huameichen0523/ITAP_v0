function varargout = ERM(varargin)
% ERM MATLAB code for ERM.fig
%      ERM, by itself, creates a new ERM or raises the existing
%      singleton*.
%
%      H = ERM returns the handle to a new ERM or the handle to
%      the existing singleton*.
%
%      ERM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERM.M with the given input arguments.
%
%      ERM('Property','Value',...) creates a new ERM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ERM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ERM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ERM

% Last Modified by GUIDE v2.5 06-Mar-2017 14:35:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ERM_OpeningFcn, ...
                   'gui_OutputFcn',  @ERM_OutputFcn, ...
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


% --- Executes just before ERM is made visible.
function ERM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ERM (see VARARGIN)


% Database related information
handles.DB.username = 'root';
handles.DB.password = 'M4SF5%Td';
handles.DB.driver = 'com.mysql.jdbc.Driver';
javaclasspath('C:\Program Files\MySQL\mysql-connector-java-5.1.40\mysql-connector-java-5.1.40-bin.jar');
handles.radioButtonColor{1} = RadioButtonColors('WHITE');
handles.radioButtonColor{2} = RadioButtonColors('BLACK');
handles.radioButtonColor{3} = RadioButtonColors('RED');
handles.radioButtonColor{4} = RadioButtonColors('GREEN');
set(handles.rb_DB,'CData',handles.radioButtonColor{1});
set(handles.rb_DB,'string','Database status');
set(handles.pb_connect,'enable','off');
set(handles.pb_disconnect,'enable','off');

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

% Choose default command line output for ERM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ERM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ERM_OutputFcn(hObject, eventdata, handles) 
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
        case 'PVO_UTIL0_session_514' % Database: 
            'Schema for PVO_UTIL0_session_514 has not been created',
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
    % plot WAMI image 
    handles = setWAMIBackground(handles);
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
set(handles.listbox_selectedLM,'String',{'Selected landmarks'});
set(handles.listbox_selectedLM,'Value',1);
return

function handles = setWAMIBackground(handles)
ax = handles.axes_Img;
II = handles.data.Img;
solidLandmarks = handles.solidLandmarks;
imshow(II,[],'parent',ax); hold on;
LM = handles.data.landmarks;
for i = 1:size(LM,1)
    if solidLandmarks(i)
        plot(ax,LM{i,2},LM{i,3},'ro','LineWidth',6);
    else
        plot(ax,LM{i,2},LM{i,3},'ro');
    end
end
hold off;

return

function handles = setLandmarksTB(handles)
    conn = handles.DB.conn;
    sql = 'SELECT landmark_name,center_ImgX,center_ImgY,description FROM landmarks;';
    m = exec(conn,sql);
    m = fetch(m);
    if isempty(m.Message)
        data = m.Data;
        set(handles.uitb_landmarks,'Data',data);
        handles.data.landmarks = data;
        handles.solidLandmarks = zeros(size(data,1),1);
    else
        msgbox(conn.Message,sql,'error');
    end
return

function handles = setTrackInfo(handles)
    conn = handles.DB.conn;
    sql = 'select distinct(track_id) from trajectory';
    m = exec(conn,sql);
    m = fetch(m);
    if isempty(m.Message)
        set(handles.edit_Total,'string',num2str(length(m.Data)));
    else
        msgbox(conn.Message,sql,'error');
    end
    sql = 'select max(track_length) from trajectory';
    m = exec(conn,sql);
    m = fetch(m);
    if isempty(m.Message)
        set(handles.edit_Max,'string',num2str(m.Data{1}));
    else
        msgbox(conn.Message,sql,'error');
    end
    sql = 'select min(track_length) from trajectory';
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
handles.solidLandmarks(from_idx) = 1;
handles = setWAMIBackground(handles);
tmp = get(handles.listbox_selectedLM,'String');
if iscell(tmp)
    to_data = tmp;
else
    to_data{1} = tmp;
end
to_data{end+1} = from_data{from_idx};
set(handles.listbox_selectedLM,'String',to_data);

guidata(hObject, handles);


% --- Executes on button press in pb_remove.
function pb_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

alldata = get(handles.pm_landmarks,'String');

data = get(handles.listbox_selectedLM,'String');
idx = get(handles.listbox_selectedLM,'Value');
if idx > 1
    newData = cell(1,1);
    newData{1} = data{1};
    for i = 2:length(data)
        if i~=idx
            newData{end+1} = data{i};
        else
            handles.solidLandmarks(find(strcmp(alldata,data{i})))=0;            
        end
    end
    set(handles.listbox_selectedLM,'String',newData);
    if idx > length(newData)
        set(handles.listbox_selectedLM,'Value',idx-1);
    end
end
handles = setWAMIBackground(handles);
guidata(hObject, handles);


% --- Executes on button press in pb_run.
function pb_run_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%
%===> Step 1: Build SQL to quiry DB
%
sql_select = 'SELECT DISTINCT(track_id) FROM trajectory ';
% min length
L_min = get(handles.edit_PoL_Min,'string');
sql_min = ['WHERE track_length > ', L_min,' '];
% max length
L_max = get(handles.edit_PoL_Max,'string');
sql_max = ['AND track_length < ',L_max,' '];

sql_complete = [sql_select,sql_min,sql_max];

% pass through
LM = handles.data.landmarks;
solidLandmarks = handles.solidLandmarks;
if sum(solidLandmarks) > 0 % Do have passing through LM requirement
    j = 1;
    for i = 1:size(LM,1)
        if solidLandmarks(i) == 1
            sql_LM{j} = ['AND track_id IN (',sql_select,' WHERE pow(img_loc_x-',num2str(LM{i,2}),',2)+pow(img_loc_y-',num2str(LM{i,3}),',2) < 100000) '];
            sql_complete = [sql_complete,sql_LM{j}];
            j = j+1;
        end
    end
end

conn = handles.DB.conn;
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
sql_select = 'SELECT img_loc_x, img_loc_y FROM trajectory WHERE track_id = ';
for i = 1:numTracks
    sql_complete = [sql_select,num2str(selectedTracks{i}),' ORDER BY pt_id'];
    m = exec(conn,sql_complete);
    m = fetch(m);
    tracks{i}.ID = selectedTracks{i};
    tmpX = cell2mat(m.Data(:,1));
    tmpY = cell2mat(m.Data(:,2));
    idx = tmpX~=0 & tmpY~=0;
    tracks{i}.img_x = tmpX(idx);
    tracks{i}.img_y = tmpY(idx);
end

%
%==> Step 3: Plot tracks
%
figure;
imshow(handles.data.Img);hold on;
for i = 1:numTracks
    plot( tracks{i}.img_x, tracks{i}.img_y,'g-','linewidth',1);
end
LM = handles.data.landmarks;
for i = 1:size(LM,1)
    if solidLandmarks(i)
        plot(LM{i,2},LM{i,3},'ro','LineWidth',6);
    end
end
    
% ==> Step 4: Populate results in uitb_result 
L = length(tracks);
Data = cell(L,2);
for i = 1:L
    Data{i,1} = num2str(tracks{i}.ID);
    Data{i,2} = num2str(length(tracks{i}.img_x));
end
set(handles.uitb_result,'Data',Data);   

    



function edit_ID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ID as text
%        str2double(get(hObject,'String')) returns contents of edit_ID as a double


% --- Executes during object creation, after setting all properties.
function edit_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ID (see GCBO)
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


% --- Executes on button press in pb_activity.
function pb_activity_Callback(hObject, eventdata, handles)
% hObject    handle to pb_activity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
