function varargout = Main_AddLandmarks(varargin)
% MAIN_ADDLANDMARKS MATLAB code for Main_AddLandmarks.fig
%      MAIN_ADDLANDMARKS, by itself, creates a new MAIN_ADDLANDMARKS or raises the existing
%      singleton*.
%
%      H = MAIN_ADDLANDMARKS returns the handle to a new MAIN_ADDLANDMARKS or the handle to
%      the existing singleton*.
%
%      MAIN_ADDLANDMARKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_ADDLANDMARKS.M with the given input arguments.
%
%      MAIN_ADDLANDMARKS('Property','Value',...) creates a new MAIN_ADDLANDMARKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_AddLandmarks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_AddLandmarks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_AddLandmarks

% Last Modified by GUIDE v2.5 29-Mar-2017 16:33:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_AddLandmarks_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_AddLandmarks_OutputFcn, ...
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


% --- Executes just before Main_AddLandmarks is made visible.
function Main_AddLandmarks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_AddLandmarks (see VARARGIN)

% Database related information
handles.DB.username = get(handles.edit_username,'string');
handles.DB.password = '';
handles.DB.driver = 'com.mysql.jdbc.Driver';
handles.DB.javaclasspath.path = 'C:\Program Files\MySQL\mysql-connector-java-5.1.40\mysql-connector-java-5.1.40-bin.jar';
handles.DB.javaclasspath.set = false;
handles.DB.dbname = 'mifs_s';
handles.DB.dburl =['jdbc:mysql://localhost:3306/' handles.DB.dbname];
handles.radioButtonColor{1} = RadioButtonColors('WHITE');
handles.radioButtonColor{2} = RadioButtonColors('BLACK');
handles.radioButtonColor{3} = RadioButtonColors('RED');
handles.radioButtonColor{4} = RadioButtonColors('GREEN');
set(handles.rb_DB,'CData',handles.radioButtonColor{1});
set(handles.rb_DB,'string','Database disconnect');
set(handles.pb_connect,'enable','on');
set(handles.pb_disconnect,'enable','off');

% Google Places API related setting
handles.GooglePlacesAPI.preStr.nearbysearch = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
handles.GooglePlacesAPI.preStr.photorequests = 'https://maps.googleapis.com/maps/api/place/photo?'; 
% parameters: key, location (in lat,lon ), radius (in meters, max: 50000),
% rankby ('prominence' or 'distance'), keyword, 
% type (https://developers.google.com/places/web-service/supported_types)
% 
handles.GooglePlacesAPI.params.key = 'AIzaSyB9RanBjRY0Ye3LYvAvBiN8BJytkilM6GM';






% Choose default command line output for Main_AddLandmarks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_AddLandmarks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_AddLandmarks_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_connect.
function pb_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.DB.javaclasspath.set == false
    if exist(handles.DB.javaclasspath.path,'file') == 2
        javaclasspath(handles.DB.javaclasspath.path);
        handles.DB.set = true;
    else
        msgbox('Please select MySQL connector');
    end
end
dbname = handles.DB.dbname;
username = handles.DB.username;
if isempty(handles.DB.password)
    %handles.DB.password = inputdlg('MySQL password:','MySQL Password',1);
    handles.DB.password = {'M4SF5%Td'};
end
if isempty(handles.DB.password)
    msgbox('Invalid password','MySQL password''warning');
    return
end
password = handles.DB.password;
driver = handles.DB.driver;
dburl = handles.DB.dburl;
conn = database(dbname, username, password{1}, driver, dburl);
if isempty(conn.Message) % connectted succefully
    set(handles.rb_DB,'CData',handles.radioButtonColor{4}); % green
    set(handles.rb_DB,'string','DB connected');
    set(handles.pb_connect,'enable','off');
    set(handles.pb_disconnect,'enable','on');
    handles.DB.conn = conn;
    % set Map scope
    handles = setMapScope(handles);
    
%     % set trajectory info 
%     handles = setTrackInfo(handles);
%     % set Landmarks table
%     handles = setLandmarksTB(handles); 
%     % plot WAMI image 
%     handles = setWAMIBackground(handles);
%     % populate PoL Analysis Criteria
%     handles = initPoLCriteria(handles);
    
else
    msgbox(conn.Message,'Database connection status','warn');
end    
guidata(hObject, handles);

% --- Executes on button press in pb_disconnect.
function pb_disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to pb_disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.rb_DB,'CData',handles.radioButtonColor{3}); % red
set(handles.rb_DB,'string','DB disconnected');
set(handles.pb_connect,'enable','on');
set(handles.pb_disconnect,'enable','off');
close(handles.DB.conn);
handles.DB.conn = '';
guidata(hObject, handles);

% --- Executes on button press in rb_DB.
function rb_DB_Callback(hObject, eventdata, handles)
% hObject    handle to rb_DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_DB



function edit_username_Callback(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_username as text
%        str2double(get(hObject,'String')) returns contents of edit_username as a double


% --- Executes during object creation, after setting all properties.
function edit_username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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



function edit_connector_Callback(hObject, eventdata, handles)
% hObject    handle to edit_connector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_connector as text
%        str2double(get(hObject,'String')) returns contents of edit_connector as a double


% --- Executes during object creation, after setting all properties.
function edit_connector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_connector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_selectConnector.
function pb_selectConnector_Callback(hObject, eventdata, handles)
% hObject    handle to pb_selectConnector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME, FILTERINDEX] = uigetfile({'*.jar'}, 'MySQL connection Java class file');
if FILENAME ~= 0
    handles.DB.javaclasspath.path = fullfile(PATHNAME,FILENAME);
    set(handles.edit_connector,'string',handles.DB.javaclasspath.path);
else
    msgbox('No file selected','MySQL connection Java class file','warn');
end

guidata(hObject, handles);



function edit_center_lat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_center_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_center_lat as text
%        str2double(get(hObject,'String')) returns contents of edit_center_lat as a double


% --- Executes during object creation, after setting all properties.
function edit_center_lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_center_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_center_lon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_center_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_center_lon as text
%        str2double(get(hObject,'String')) returns contents of edit_center_lon as a double


% --- Executes during object creation, after setting all properties.
function edit_center_lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_center_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dlat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dlat as text
%        str2double(get(hObject,'String')) returns contents of edit_dlat as a double


% --- Executes during object creation, after setting all properties.
function edit_dlat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dlon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dlon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dlon as text
%        str2double(get(hObject,'String')) returns contents of edit_dlon as a double


% --- Executes during object creation, after setting all properties.
function edit_dlon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dlon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = setMapScope(handles)
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

lat_center = (lat_min + lat_max)/2;
lon_center = (lon_min + lon_max)/2;
dlat = lat_max - lat_min;
dlon = lon_max - lon_min;
set(handles.edit_center_lat,'string',num2str(lat_center));
set(handles.edit_center_lon,'string',num2str(lon_center));
set(handles.edit_dlat,'string',num2str(dlat));
set(handles.edit_dlon,'string',num2str(dlon));

% Default landmark center
set(handles.edit_lm_lat,'string',num2str(lat_center));
set(handles.edit_lm_lon,'string',num2str(lon_center));


% --- Executes on button press in pb_show.
function pb_show_Callback(hObject, eventdata, handles)
% hObject    handle to pb_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

center_lat = str2double(get(handles.edit_center_lat,'string'));
center_lon = str2double(get(handles.edit_center_lon,'string'));
dLat = str2double(get(handles.edit_dlat,'string'));
dLon = str2double(get(handles.edit_dlon,'string'));
ax = handles.axes_img;
cla(ax);
handles.mapHandle.lmHandle = plot(ax,[center_lon-dLon/2,center_lon+dLon/2],[center_lat-dLat/2,center_lat+dLat/2],'.');
YLim = [center_lat-dLat/2,center_lat+dLat/2];
XLim = [center_lon-dLon/2,center_lon+dLon/2];
set(ax,'XLim',XLim,'YLim',YLim);
data = get(handles.pm_mapType,'string');
v = get(handles.pm_mapType,'value');
mapType = data{v};
handles.mapHandle.GoogleMap = plot_google_map('Axis',ax,'MapType',mapType,'autoAxis',0,'Alpha',1); % roadmap, satellite, terrain, hybrid
guidata(hObject, handles);


% --- Executes on selection change in pm_type.
function pm_type_Callback(hObject, eventdata, handles)
% hObject    handle to pm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_type


% --- Executes during object creation, after setting all properties.
function pm_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_rankedby.
function pm_rankedby_Callback(hObject, eventdata, handles)
% hObject    handle to pm_rankedby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_rankedby contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_rankedby


% --- Executes during object creation, after setting all properties.
function pm_rankedby_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_rankedby (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lm_lat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lm_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lm_lat as text
%        str2double(get(hObject,'String')) returns contents of edit_lm_lat as a double


% --- Executes during object creation, after setting all properties.
function edit_lm_lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lm_lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_lm_lon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lm_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lm_lon as text
%        str2double(get(hObject,'String')) returns contents of edit_lm_lon as a double


% --- Executes during object creation, after setting all properties.
function edit_lm_lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lm_lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_lm_request.
function pb_lm_request_Callback(hObject, eventdata, handles)
% hObject    handle to pb_lm_request (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = clearTable(handles);
requestStr = handles.GooglePlacesAPI.preStr.nearbysearch;
% get type
v = get(handles.pm_type,'value');
s = get(handles.pm_type,'string');
str = s{v};
requestStr = [requestStr,'type=',str];
handles.GooglePlacesAPI.params.type = str;

% get rankedby (not working)
% v = get(handles.pm_rankedby,'value');
% s = get(handles.pm_rankedby,'string');
% str = s{v};
% requestStr = [requestStr,'&rankedby=',str];
% handles.GooglePlacesAPI.params.rankedby = str;

% get Radius
str = get(handles.edit_radius,'string');
requestStr = [requestStr,'&radius=',str];

% get Location
lat = get(handles.edit_lm_lat,'string');
lon = get(handles.edit_lm_lon,'string');
str = [lat,',',lon];
requestStr = [requestStr,'&location=',str];

% get keywork
str = get(handles.edit_keyword,'string');
if ~isempty(str) && ~strcmp(str,'keyword')
    requestStr = [requestStr,'&keyword=',str];
end

% API key
str = handles.GooglePlacesAPI.params.key;
requestStr = [requestStr,'&key=',str];

% Make request
landmarks = webread(requestStr);
if strcmp(landmarks.status,'OK')
    handles.landmarks = landmarks;
    handles = populateLMTable(handles);
    msg = 'Landmark retrieval completed';
else
    msg = 'No landmark is retrieved'; 
end
msgbox(msg,'Google Places API');
guidata(hObject, handles);


function edit_radius_Callback(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_radius as text
%        str2double(get(hObject,'String')) returns contents of edit_radius as a double


% --- Executes during object creation, after setting all properties.
function edit_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = populateLMTable(handles)
landmarks = handles.landmarks;
N = length(landmarks.results);
Data = '';
if N == 1    
    location = [num2str(landmarks.results.geometry.location.lat),',',num2str(landmarks.results.geometry.location.lng)];
    if isValidLocation(handles,location)
        Data{1,1} = landmarks.results.name;
        Data{1,2} = location;  
        Data{1,3} = 1;         
    end
else
    k = 1;
    for i = 1:N
        if iscell(landmarks.results)
           location = [num2str(landmarks.results{i}.geometry.location.lat),',',num2str(landmarks.results{i}.geometry.location.lng)];
           name = landmarks.results{i}.name;           
        else
            location = [num2str(landmarks.results(i).geometry.location.lat),',',num2str(landmarks.results(i).geometry.location.lng)];
            name = landmarks.results(i).name;            
        end
        if isValidLocation(handles,location)
            Data{k,1} = name;
            Data{k,2} = location;
            Data{k,3} = i;
            k = k+1;
        end
    end
end
set(handles.uitb_LM,'data',Data(1:end,1:2));
handles.lmTBData = Data; % augmented uitb_LM data with index information 


% --- Executes when entered data in editable cell(s) in uitb_LM.
function uitb_LM_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitb_LM (see GCBO)
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
    if data{i,3} == true
        latlon = regexp(data{i,2},',','split');
        xi=[xi,str2double(latlon{2})];
        yi=[yi,str2double(latlon{1})];
    end
end
set(handles.mapHandle.lmHandle,'Xdata',xi,'Ydata',yi,'Marker','o','MarkerFaceColor','blue','Color',[1 0 0]);

        
function  handles = clearTable(handles)
set(handles.uitb_LM,'Data','');
handles.lmTBData = '';

function out = isValidLocation(handles,location)
tmp = regexp(location,',','split');
lat = str2double(tmp{1});
lon = str2double(tmp{2});
Xlim = get(handles.axes_img,'XLim');
Ylim = get(handles.axes_img,'YLim');
min_lat = Ylim(1);
max_lat = Ylim(2);
min_lon = Xlim(1);
max_lon = Xlim(2);
if     lat < max_lat && lat > min_lat ... 
    && lon < max_lon && lon > min_lon 
    out = true;
else
    out = false;
end



function edit_keyword_Callback(hObject, eventdata, handles)
% hObject    handle to edit_keyword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_keyword as text
%        str2double(get(hObject,'String')) returns contents of edit_keyword as a double


% --- Executes during object creation, after setting all properties.
function edit_keyword_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_keyword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pm_mapType.
function pm_mapType_Callback(hObject, eventdata, handles)
% hObject    handle to pm_mapType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pm_mapType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pm_mapType


% --- Executes during object creation, after setting all properties.
function pm_mapType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pm_mapType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_Add2DB.
function pb_Add2DB_Callback(hObject, eventdata, handles)
% hObject    handle to pb_Add2DB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

conn = handles.DB.conn;
data = get(handles.uitb_LM,'Data');
data_augmented = handles.lmTBData;
landmarks = handles.landmarks;

for i = 1:size(data,1)
    if data{i,3} == 1 % selected
        try
            result = landmarks.results{data_augmented{i,3}};
        catch ME
            result = landmarks.results(data_augmented{i,3});
        end
        placeID = result.place_id;
        lat = num2str(result.geometry.location.lat);
        lng = num2str(result.geometry.location.lng);
        name = result.name;
        try % not every result has photos
            photo_reference = result.photos.photo_reference;
        catch ME
            photo_reference = '';
        end
        icon = result.icon;
        tmp = result.types;
        types = tmp{1};
        for i2 = 2:length(tmp)
            types = [types,',',tmp{i2}];
        end        
        sql = ['select id from googlelandmarks where place_id = ','"',placeID,'"'];
        m = exec(conn,sql);
        m = fetch(m);
        if isempty(m.Message)
            if strcmp('No Data',m.Data{1}) % insert
               sql = ['INSERT INTO googlelandmarks (place_id,lat,lng,name,photo_reference,icon,types) VALUES(',...
                      '"',placeID,'",',lat,',',lng,',"',name,'",','"',photo_reference,'",',...
                      '"',icon,'",','"',types,'")'];
               m = exec(conn,sql);
                if ~isempty(m.Message)
                     msgbox(m.Message,sql,'error');
                end           
            end
        else
            msgbox(m.Message,sql,'error');
        end
    end
end
msgbox('Selected landmarks added into database','Landmarks','none');
