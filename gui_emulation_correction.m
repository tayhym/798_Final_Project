function varargout = gui_emulation_correction(varargin)
% GUI_EMULATION_CORRECTION MATLAB code for gui_emulation_correction.fig
%      GUI_EMULATION_CORRECTION, by itself, creates a new GUI_EMULATION_CORRECTION or raises the existing
%      singleton*.
%
%      H = GUI_EMULATION_CORRECTION returns the handle to a new GUI_EMULATION_CORRECTION or the handle to
%      the existing singleton*.
%
%      GUI_EMULATION_CORRECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_EMULATION_CORRECTION.M with the given input arguments.
%
%      GUI_EMULATION_CORRECTION('Property','Value',...) creates a new GUI_EMULATION_CORRECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_emulation_correction_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_emulation_correction_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_emulation_correction

% Last Modified by GUIDE v2.5 11-Nov-2014 17:30:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_emulation_correction_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_emulation_correction_OutputFcn, ...
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


% --- Executes just before gui_emulation_correction is made visible.
function gui_emulation_correction_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_emulation_correction (see VARARGIN)

%--------modification begins here------------------%

% create video object - code based on 
% http://www.mathworks.com/matlabcentral/answers/96242-
% how-can-i-insert-live-video-into-a-matlab-gui-using-image-acquisition-toolbox

imaqreset
vidobj=videoinput('macvideo',1);
triggerconfig(vidobj, 'manual');
run = true;

handles.vidobj = vidobj;
set(handles.vidobj,'TimerPeriod', 0.05, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'... 
                    % Update handles
                      'image(getsnapshot(handles.vidobj));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);                      
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

%--------modification ends here--------------------%


% Choose default command line output for gui_emulation_correction
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_emulation_correction wait for user response (see UIRESUME)
% --------modification start--------% 

uiwait(handles.gui_emulation_correction);

% --------modification end----------%

% --- Outputs from this function are returned to the command line.
function varargout = gui_emulation_correction_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%------modification start------%
handles.output = hObject;

%------modification end--------%
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%------------modification start--------------%
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
      % Camera is off. Change button string and start camera.
      set(handles.startStopCamera,'String','Stop Camera')
      start(handles.video)
      set(handles.startAcquisition,'Enable','on');
      set(handles.captureImage,'Enable','on');
else
      % Camera is on. Stop camera and change button string.
      set(handles.startStopCamera,'String','Start Camera')
      stop(handles.video)
      set(handles.startAcquisition,'Enable','off');
      set(handles.captureImage,'Enable','off');
end
%------------modification end--------------%

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function cameraAxes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameraAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate cameraAxes


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
