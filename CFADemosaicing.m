function varargout = CFADemosaicing(varargin)
% CFADEMOSAICING MATLAB code for CFADemosaicing.fig
%      CFADEMOSAICING, by itself, creates a new CFADEMOSAICING or raises the existing
%      singleton*.
%   
%      H = CFADEMOSAICING returns the handle to a new CFADEMOSAICING or the handle to
%      the existing singleton*.
%
%      CFADEMOSAICING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CFADEMOSAICING.M with the given input arguments.
%
%      CFADEMOSAICING('Property','Value',...) creates a new CFADEMOSAICING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CFADemosaicing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CFADemosaicing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CFADemosaicing

% Last Modified by GUIDE v2.5 29-Jun-2015 12:55:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CFADemosaicing_OpeningFcn, ...
                   'gui_OutputFcn',  @CFADemosaicing_OutputFcn, ...
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


% --- Executes just before CFADemosaicing is made visible.
function CFADemosaicing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CFADemosaicing (see VARARGIN)
global isFirstLoad;


handles.originalImage = 0;
handles.bayerImage = 0;

handles.nearestNeighbor = 0;
handles.linearInterpolation = 0;
handles.cubicInterpolation = 0;
handles.ACPInterpolation = 0;
handles.hybridInterpolation = 0;

handles.method = 0;

handles.current_data = 0;

isFirstLoad = false;

handles.cmse = 0;
handles.cpsnr = 0;

handles.filename = 0;

disp('start');

% Choose default command line output for CFADemosaicing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CFADemosaicing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CFADemosaicing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    [handles.filename, path] = uigetfile('*.*', 'Pick an image file');
    
    global isFirstLoad;
     
    if( isequal(handles.filename,0) || isequal(path,0))
        
        disp('User pressed cancel');
       
    else
        
        disp(['User selected ', fullfile(path, handles.filename)]);
               
        handles.originalImage = imread(fullfile(path, handles.filename));
        
        handles.bayerImage = BayerFilter(handles.originalImage);
         
        if (isFirstLoad == true)
            delete(get(handles.demosaiced_image_axes,'Children'));
        end    
        
        isFirstLoad = true;
 
        axes(handles.original_image_axes);
        imshow(handles.originalImage);
        
        temp(:,:,1) = handles.bayerImage(:,:,1) + handles.bayerImage(:,:,2) + handles.bayerImage(:,:,3);
        temp(:,:,2) = temp(:,:,1);
        temp(:,:,3) = temp(:,:,1);
        
        axes(handles.bayer_image_axes);
        imshow(temp);
        
        handles.nearestNeighbor = 0;
        handles.linearInterpolation = 0;
        handles.cubicInterpolation = 0;
        handles.ACPInterpolation = 0;
        handles.hybridInterpolation = 0;
        
        set(handles.cmse_text, 'String', 'CMSE = 0');
        set(handles.cpsnr_text, 'String', 'CPSNR = 0');
        
        guidata(hObject, handles);
 
    end  

% --- Executes on button press in convert_image.
function convert_image_Callback(hObject, eventdata, handles)
% hObject    handle to convert_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global val;
    
    if ( handles.bayerImage == 0)
        
        h = msgbox('Please load an image!','Warning!','warn');
    
    else
         
        h = msgbox('Please Wait...','Process');
  
        switch val
            case 1
                if( handles.nearestNeighbor == 0)
                    handles.nearestNeighbor = NearestNeighbor(handles.bayerImage);
                end
                handles.method = 'NN';
                handles.current_data = handles.nearestNeighbor;
                [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.nearestNeighbor, 0);
            case 2
                if( handles.linearInterpolation == 0)
                     handles.linearInterpolation = LinearInterpolation(handles.bayerImage);
                end     
                handles.method = 'LI';
                handles.current_data = handles.linearInterpolation; 
                [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.linearInterpolation, 1);
            case 3
                if( handles.cubicInterpolation == 0)
                    handles.cubicInterpolation = CubicInterpolation(handles.bayerImage);
                end    
                handles.method = 'CI';
                handles.current_data = handles.cubicInterpolation;
                [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.cubicInterpolation, 3);
            case 4    
                if ( handles.ACPInterpolation == 0)            
                    handles.ACPInterpolation = ACPInterpolation(handles.bayerImage);
                end    
                handles.method = 'ACPI';
                handles.current_data = handles.ACPInterpolation;
                [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.ACPInterpolation, 2);
            case 5    
                if ( handles.hybridInterpolation == 0)            
                    handles.hybridInterpolation = HybridInterpolation(handles.bayerImage);
                end    
                handles.method = 'HI';
                handles.current_data = handles.hybridInterpolation ;
                [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.hybridInterpolation, 2);
               
        end  

        delete(h);

        guidata(hObject, handles);

        axes(handles.demosaiced_image_axes);
        imshow(handles.current_data);

        set(handles.cmse_text, 'String', ['CMSE = ',num2str(handles.cmse)]);
        set(handles.cpsnr_text, 'String', ['CPSNR = ',num2str(handles.cpsnr)]);
    end   
    
% --- Executes on selection change in demosaicing_type.
function demosaicing_type_Callback(hObject, eventdata, handles)
% hObject    handle to demosaicing_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global val;
    val = get(hObject, 'Value');

%     str = cellstr(str);
    
%     switch str{val}
%         case 'Nearest Neighbor'
%             handles.current_data = handles.nearestNeighbor;
%             [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.nearestNeighbor, 0);
%         case 'Linear Interpolation'
%             handles.current_data = handles.linearInterpolation;
%             [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.linearInterpolation, 1);
%         case 'Cubic Interpolation'
%             handles.current_data = handles.cubicInterpolation;
%             [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.cubicInterpolation, 3);
%         case 'ACP Interpolation'    
%             handles.current_data = handles.ACPInterpolation;
%             [handles.cmse, handles.cpsnr] = CMSEandCPSNR(handles.originalImage, handles.ACPInterpolation, 2);
%      end    
    
    guidata(hObject, handles);
   
% Hints: contents = cellstr(get(hObject,'String')) returns demosaicing_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from demosaicing_type


% --- Executes during object creation, after setting all properties.
function demosaicing_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to demosaicing_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    global val;
    val = get(hObject, 'Value');

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_SizeChangedFcn(hObject, eventdata, handles)


% --- Executes on button press in save_image.
function save_image_Callback(hObject, eventdata, handles)
% hObject    handle to save_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[folderPath] = uigetdir('', 'Choose a folder to save image...');
     
    if( isequal(folderPath,0) || isequal(handles.filename,0) || isequal(handles.current_data,0))
        
        disp('User pressed cancel or image is not created');
       
    else
        
        filename = strcat(handles.method,'_',handles.filename)
        path = fullfile( folderPath, filename)
        imwrite(handles.current_data, path);
        
    end    
