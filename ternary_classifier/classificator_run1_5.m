function varargout = classificator_run1_5(varargin)
% CLASSIFICATOR_RUN1_5 M-file for classificator_run1_5.fig
%      CLASSIFICATOR_RUN1_5, by itself, creates a new CLASSIFICATOR_RUN1_5 or raises the existing
%      singleton*.
%
%      H = CLASSIFICATOR_RUN1_5 returns the handle to a new CLASSIFICATOR_RUN1_5 or the handle to
%      the existing singleton*.
%
%      CLASSIFICATOR_RUN1_5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFICATOR_RUN1_5.M with the given input arguments.
%
%      CLASSIFICATOR_RUN1_5('Property','Value',...) creates a new CLASSIFICATOR_RUN1_5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classificator_run1_5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classificator_run1_5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help classificator_run1_5

% Last Modified by GUIDE v2.5 24-Oct-2012 19:22:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classificator_run1_5_OpeningFcn, ...
                   'gui_OutputFcn',  @classificator_run1_5_OutputFcn, ...
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


% --- Executes just before classificator_run1_5 is made visible.
function classificator_run1_5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classificator_run1_5 (see VARARGIN)

% Choose default command line output for classificator_run1_5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classificator_run1_5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = classificator_run1_5_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Use_IVT_Model_Checkbox.
function Use_IVT_Model_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Use_IVT_Model_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_IVT_Model_Checkbox

% Create array of all GUI widgets that belongs to I-VT Model
    tmp_widgets = {'IVT_Saccade_Detection_Threshold'};
    invoke_state_change = false;
% Get state of checkbox
    if(get(hObject,'Value') > 0),tmp_enable_state='on'; invoke_state_change = true;
    elseif( ~get( findobj('Tag', 'Use_IVVT_Model_Checkbox'), 'Value') ), tmp_enable_state='off'; invoke_state_change = true;
    end
    if( invoke_state_change ),change_model_settings_state(tmp_widgets,tmp_enable_state);end

% --- Executes on button press in Use_USER_Model_Checkbox.
function Use_USER_Model_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Use_USER_Model_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_USER_Model_Checkbox

% Create array of all GUI widgets that belongs to I-HMM Model
    tmp_widgets = {'Field1';'Field2'};
    invoke_state_change = false;
% Get state of checkbox
    if(get(hObject,'Value') > 0), tmp_enable_state='on'; invoke_state_change = true;
    else tmp_enable_state='off'; invoke_state_change = true;
    end
    if( invoke_state_change ),change_model_settings_state(tmp_widgets,tmp_enable_state);end


% --- Executes on button press in Convert_Data.
function Convert_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Convert_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Convert_Data
% Create array of all GUI widgets that belongs to I-HMM Model
    tmp_widgets = {'Image_Width_ETU';'Image_Height_ETU';'Image_Width_MM';'Image_Height_MM';'Distance_From_Screen';'Distance_To_Eye_Level';'Distance_To_Lower_Screen_Edge'};
% Get state of checkbox
    if(get(hObject,'Value') > 0)
        tmp_enable_state='on';
    else
        tmp_enable_state='off';
    end
    change_model_settings_state(tmp_widgets,tmp_enable_state);
    
% --- Executes on button press in Filtrate_Saccades.
function Filtrate_Saccades_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrate_Saccades (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Filtrate_Saccades
% Create array of all GUI widgets that belongs to I-HMM Model
    tmp_widgets = {'Minimal_Saccade_Amplitude';'Maximal_Saccade_Amplitude';'Minimal_Saccade_Length'};
% Get state of checkbox
    if(get(hObject,'Value') > 0)
        tmp_enable_state='on';
    else
        tmp_enable_state='off';
    end
    change_model_settings_state(tmp_widgets,tmp_enable_state);
    
    
% --- Executes on button press in Enable_Plots.
function Enable_Plots_Callback(hObject, eventdata, handles)
% hObject    handle to Enable_Plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Enable_Plots
% Create array of all GUI widgets that belongs to I-HMM Model
    tmp_widgets = {'Plot_Mode_1';'Plot_Mode_2';'Plot_Mode_3';'Plot_Mode_4'};
% Get state of checkbox
    if(get(hObject,'Value') > 0)
        tmp_enable_state='on';
    else
        tmp_enable_state='off';
    end
    change_model_settings_state(tmp_widgets,tmp_enable_state);

    
% This procedure executes only in case of execute button pushed - its mean
% that we setup all variables and ready to proceed to classifications

% --- Executes on button press in Execute_Classification_Button.
function Execute_Classification_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Execute_Classification_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
path(path,'classificator_1.5');
    
    local_error = 0;    % Flag for local errors - mistyped parameters etc
    model_count = 0;    % Model counter - how much models we are using
    i = 0;

% Switch off Classify button
    set( findobj('Tag','Execute_Classification_Button'), 'Enable', 'Inactive');

% Below there is five almost identical code blocks. Each of them reading
% parameters for one model

% ========== I-VT Model settings START ================
    MODEL_SETTINGS.USE.IVT = get(findobj('Tag','Use_IVT_Model_Checkbox'),'Value');
    if(MODEL_SETTINGS.USE.IVT ~= 0)
        model_count=model_count+1;
% Read parameters
        MODEL_SETTINGS.IVT.SACCADE_DETECTION_THRESHOLD = str2double( get(findobj('Tag','IVT_Saccade_Detection_Threshold'),'String') );
% Check parameters
        if( (isnan(MODEL_SETTINGS.IVT.SACCADE_DETECTION_THRESHOLD) || MODEL_SETTINGS.IVT.SACCADE_DETECTION_THRESHOLD < 1) && local_error == 0)
            errordlg('I-VT Saccade detection threshold value is incorrect. Please enter a correct one','Incorrect threshold value.');
            local_error = 1;
        end
    end
% ========== I-VT Model settings END ================

% ========== I-VVT Model settings START ================
    MODEL_SETTINGS.USE.IVVT = get(findobj('Tag','Use_IVVT_Model_Checkbox'),'Value');
    if(MODEL_SETTINGS.USE.IVVT ~= 0)
        model_count=model_count+1;
% Read parameters
        MODEL_SETTINGS.IVVT.SACCADE_DETECTION_THRESHOLD = str2double( get(findobj('Tag','IVT_Saccade_Detection_Threshold'),'String') );
        MODEL_SETTINGS.IVVT.FIXATION_DETECTION_THRESHOLD = str2double(get(findobj('Tag','IVVT_Fixation_Detection_Threshold'),'String') );
% Check parameters
        if( (isnan(MODEL_SETTINGS.IVVT.SACCADE_DETECTION_THRESHOLD) || MODEL_SETTINGS.IVVT.SACCADE_DETECTION_THRESHOLD < 1) && local_error == 0)
            errordlg('I-VVT Saccade detection threshold value is incorrect. Please enter a correct one','Incorrect threshold value.');
            local_error = 501;
        end
        if( (isnan(MODEL_SETTINGS.IVVT.FIXATION_DETECTION_THRESHOLD) || MODEL_SETTINGS.IVVT.FIXATION_DETECTION_THRESHOLD < 1) && local_error == 0)
            errordlg('I-VVT Fixation detection threshold value is incorrect. Please enter a correct one','Incorrect threshold value.');
            local_error = 502;
        end
        if( ~local_error && MODEL_SETTINGS.IVVT.FIXATION_DETECTION_THRESHOLD > MODEL_SETTINGS.IVVT.SACCADE_DETECTION_THRESHOLD )
            errordlg('I-VVT Fixation detection threshold is greater than I-VVT Saccade detection threshold. Please enter a correct values','Incorrect threshold value.');
            local_error = 503;
        end
    end
% ========== I-VVT Model settings END ================

% ========== User Model settings START ==========
% checking for user model settings - but only if corresponding checkbox is
% toggled on
    MODEL_SETTINGS.USE.PURSUITS = get(findobj('Tag','Use_USER_Model_Checkbox'),'Value');
    if(MODEL_SETTINGS.USE.PURSUITS ~= 0)
        model_count=model_count+1;
% Read parameters
%        MODEL_SETTINGS.PURSUITS.X1 = str2double( get(findobj('Tag','Field1'),'String') );
%        MODEL_SETTINGS.PURSUITS.X2 = str2double( get(findobj('Tag','Field2'),'String') );
% Check parameters
% Put your tests of input data here
    end  
% ========== User Model settings END ============

% ========== Reader settings START ========
    if (local_error == 0)
    % Read parameters
        MODEL_SETTINGS.READER.INPUT_DATA_NAME = get(findobj('Tag','Input_File_Name'),'String');
        MODEL_SETTINGS.READER.X_FIELD = ceil( str2double( get(findobj('Tag','X_Field'),'String') ) );
        MODEL_SETTINGS.READER.Y_FIELD = ceil( str2double( get(findobj('Tag','Y_Field'),'String') ) );
        MODEL_SETTINGS.READER.V_FIELD = ceil( str2double( get(findobj('Tag','V_Field'),'String') ) );
        MODEL_SETTINGS.READER.HEADER_COUNT = ceil(str2double( get(findobj('Tag','Header_Count'),'String') ) );
        MODEL_SETTINGS.READER.SAMPLE_RATE = ceil(str2double( get(findobj('Tag','Sample_Rate'),'String') ) );
        MODEL_SETTINGS.READER.FIELDS_COUNT = ceil(str2double( get(findobj('Tag','Fields_Count'),'String') ) );
        MODEL_SETTINGS.CONVERTER.USE = get(findobj('Tag','Convert_Data'),'Value');
    % Check parameters
        if((isnan(MODEL_SETTINGS.READER.SAMPLE_RATE) || MODEL_SETTINGS.READER.SAMPLE_RATE < 1)  && local_error == 0 )
            errordlg('Tracker sampling rate must be positive integer. Please correct input data.','Incorrect sampling rate.');
            local_error=24;
            MODEL_SETTINGS.READER.DELTA_T_SEC = nan;
        else
            MODEL_SETTINGS.READER.DELTA_T_SEC = 1/MODEL_SETTINGS.READER.SAMPLE_RATE;
        end
        if( (isnan(MODEL_SETTINGS.READER.HEADER_COUNT) || MODEL_SETTINGS.READER.HEADER_COUNT < 0) && local_error == 0)
            errordlg('Header lines count must be a non-negative integer. Please enter the correct value.','Incorrect header lines count.');
            local_error=25;
        end
        if( (isnan(MODEL_SETTINGS.READER.V_FIELD) || MODEL_SETTINGS.READER.V_FIELD < 0) && local_error == 0)
            errordlg('Incorrect validity field number. Please correct this error.','Incorrect validity field number.');
            local_error=26;
        end
        if( (isnan(MODEL_SETTINGS.READER.Y_FIELD) || MODEL_SETTINGS.READER.Y_FIELD <= 0) && local_error == 0)
            errordlg('Incorrect y coordinate field number. Please correct this error.','Incorrect y coordinate field number.');
            local_error=27;
        end
        if( (isnan(MODEL_SETTINGS.READER.X_FIELD) || MODEL_SETTINGS.READER.X_FIELD < 0) && local_error == 0)
            errordlg('Incorrect x coordinate field number. Please correct this error.','Incorrect x coordinate field number.');
            local_error=28;
        end
        if( (isnan(MODEL_SETTINGS.READER.FIELDS_COUNT) || MODEL_SETTINGS.READER.FIELDS_COUNT < 2) && local_error == 0)
            errordlg('Number of fields in input file is incorrect. At least 2 have to be present in input file.','Incorrect number of fields in input file.');
            local_error=60;
        end
        if( (~exist(MODEL_SETTINGS.READER.INPUT_DATA_NAME,'file') ) && local_error == 0)
            errordlg('Provided file is not found. Check file name.','File input error.');
            local_error=29;
        end
    end
% ========== Reader settings END ========

% ========== Converter settings START ========
    if( local_error == 0 && MODEL_SETTINGS.CONVERTER.USE ~= 0)
    % Read parameters
        MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_ETU = ceil( str2double( get(findobj('Tag','Image_Width_ETU'),'String') ) );
        MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_ETU = ceil( str2double( get(findobj('Tag','Image_Height_ETU'),'String') ) );
        MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_MM = ceil( str2double( get(findobj('Tag','Image_Width_MM'),'String') ) );
        MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_MM = ceil( str2double( get(findobj('Tag','Image_Height_MM'),'String') ) );
        MODEL_SETTINGS.CONVERTER.DISTANCE_FROM_SCREEN = ceil( str2double( get(findobj('Tag','Distance_From_Screen'),'String') ) );
        MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL = ceil( str2double( get(findobj('Tag','Distance_To_Eye_Level'),'String') ) );
        MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE = ceil( str2double( get(findobj('Tag','Distance_To_Lower_Screen_Edge'),'String') ) );
    % Check parameters
        if( (isnan(MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_ETU) || MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_ETU < 1) && local_error == 0)
            errordlg('Image width in ETU is incorrect. Please provide a correct value.','Incorrect ETU width.');
            local_error = 30;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_ETU) || MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_ETU < 1) && local_error == 0)
            errordlg('Image height in ETU is incorrect. Please provide a correct value.','Incorrect ETU height.');
            local_error = 31;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_MM) || MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_MM < 1) && local_error == 0)
            errordlg('Image width in mm is incorrect. Please provide a correct value.','Incorrect mm width.');
            local_error = 32;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_MM) || MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_MM < 1) && local_error == 0)
            errordlg('Image height in mm is incorrect. Please provide a correct value.','Incorrect mm height.');
            local_error = 33;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.DISTANCE_FROM_SCREEN) || MODEL_SETTINGS.CONVERTER.DISTANCE_FROM_SCREEN < 1) && local_error == 0)
            errordlg('Distance between screen and test subject is incorrect. Please provide a correct value.','Incorrect distance value.');
            local_error = 34;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL) || MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL <= 0) && local_error == 0)
            errordlg('Distance to eye level is incorrect. Please provide a correct value.','Incorrect distance to eye level.');
            local_error = 35;
        end
        if( (isnan(MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE) || MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE <= 0) && local_error == 0)
            errordlg('Distance to lower screen edge is incorrect. Please provide a correct value.','Incorrect distance to lower screen edge.');
            local_error = 36;
        end
        if( (MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL < MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE ) && local_error == 0)
            errordlg('Distance to lower screen edge is greater than distance to eye level. Please correct this.','Inconsistent distances of levels.');
            local_error = 70;
        end
    end
% ========== Converter settings END ==========

% =========== Filter settings START ==========
    MODEL_SETTINGS.FILTER.USE = get(findobj('Tag','Filtrate_Saccades'),'Value');
    if( MODEL_SETTINGS.FILTER.USE ~= 0)
    % Read parameters
        MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE = str2double( get(findobj('Tag','Minimal_Saccade_Amplitude'),'String') );
        MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE = str2double( get(findobj('Tag','Maximal_Saccade_Amplitude'),'String') );
        MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH = ceil( str2double( get(findobj('Tag','Minimal_Saccade_Length'),'String') ) );
    % Check parameters
        if( (isnan(MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE) || MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE < 0) && local_error == 0)
            errordlg('Minimal saccade amplitude is incorrect. Please provide a correct value.','Incorrect minimal saccade amplitude.');
            local_error = 37;
        end
        if( (isnan(MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE) || MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE < 0) && local_error == 0)
            errordlg('Maximal saccade amplitude is incorrect. Please provide a correct value.','Incorrect maximal saccade amplitude.');
            local_error = 38;
        end
        if( (isnan(MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH) || MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH < 1) && local_error == 0)
            errordlg('Minimal saccade length is incorrect. Please provide a correct value.','Incorrect minimal saccade length.');
            local_error = 39;
        end
    end
% =========== Filter settings END ==========

% ========== Output settings START =========
    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_FILENAME = get(findobj('Tag','Basename_Output_Filename'),'String');
    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_EXTENSION = get(findobj('Tag','Basename_Output_Extension'),'String');
    MODEL_SETTINGS.OUTPUT.DEBUG_MODE = get(findobj('Tag','Debug_Mode'),'Value');
    if( strcmp(MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_FILENAME,'') )
        errordlg('Output filename not entered. Enter a vaild output filename.','No output filename.');
        local_error = 40;
    end
% =========== Output settings END ==========

% ===== Data Processing settings START =====
    MODEL_SETTINGS.PROCESSING.PLOTS.USE = get(findobj('Tag','Enable_Plots'),'Value');
    if( MODEL_SETTINGS.PROCESSING.PLOTS.USE ~= 0)
        if( get(findobj('Tag','Plot_Mode_1'),'Value') ~= 0)
            MODEL_SETTINGS.PROCESSING.PLOTS.MODE = 1;
        end
        if( get(findobj('Tag','Plot_Mode_2'),'Value') ~= 0)
            MODEL_SETTINGS.PROCESSING.PLOTS.MODE = 2;
        end
        if( get(findobj('Tag','Plot_Mode_3'),'Value') ~= 0)
            MODEL_SETTINGS.PROCESSING.PLOTS.MODE = 3;
        end
        if( get(findobj('Tag','Plot_Mode_4'),'Value') ~= 0)
            MODEL_SETTINGS.PROCESSING.PLOTS.MODE = 4;
        end
    end
    MODEL_SETTINGS.PROCESSING.SCORES.USE = get(findobj('Tag','Enable_Scores_Calculations'),'Value');
% ===== Data Processing settings END =====

% ===== Merge Settings START =====
% Read parameters
    MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL = str2double( get(findobj('Tag','Merge_Time_Interval'),'String') );
    MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE = str2double( get(findobj('Tag','Merge_Distance'),'String') );
    % Check parameters
    if( (isnan(MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL) || MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL < 0) && local_error == 0)
        errordlg('Merge fixation time interval is incorrect. Please provide a correct value.','Incorrect merge fixation time interval.');
        local_error = 40;
    end
    if( (isnan(MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE) || MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE < 0) && local_error == 0)
        errordlg('Merge fixation distance is incorrect. Please provide a correct value.','Incorrect merge fixation distance.');
        local_error = 41;
    end

% ====== Merge Settings End ======

% ====== Data filtration settings BEGIN =====
     MODEL_SETTINGS.DEGREE_FILTER.BY_X = get(findobj('Tag','Filtrate_Input_Data_X'),'Value');
     MODEL_SETTINGS.DEGREE_FILTER.BY_Y = get(findobj('Tag','Filtrate_Input_Data_Y'),'Value');
     MODEL_SETTINGS.DEGREE_FILTER.MIN_X = str2double( get(findobj('Tag','Minimal_X_degree'),'String') );
     MODEL_SETTINGS.DEGREE_FILTER.MAX_X = str2double( get(findobj('Tag','Maximal_X_degree'),'String') );
     MODEL_SETTINGS.DEGREE_FILTER.MIN_Y = str2double( get(findobj('Tag','Minimal_Y_degree'),'String') );
     MODEL_SETTINGS.DEGREE_FILTER.MAX_Y = str2double( get(findobj('Tag','Maximal_Y_degree'),'String') );
     if( MODEL_SETTINGS.DEGREE_FILTER.BY_X ~= 0)
         if( isnan(MODEL_SETTINGS.DEGREE_FILTER.MIN_X) && local_error == 0)
            errordlg('Minimal allowed angle for X axis is incorrect. Please provide a correct value.','Incorrect minimal allowed X angle.');
            local_error = 42;
         end
         if( isnan(MODEL_SETTINGS.DEGREE_FILTER.MAX_X) && local_error == 0)
            errordlg('Maximal allowed angle for X axis is incorrect. Please provide a correct value.','Incorrect maximal allowed X angle.');
            local_error = 43;
         end
         if( MODEL_SETTINGS.DEGREE_FILTER.MIN_X>=MODEL_SETTINGS.DEGREE_FILTER.MAX_X && local_error == 0)
            errordlg('Allowed range of angles for X axis is incorrect. Please provide a correct value.','Incorrect allowed rangle of angles for X axis.');
            local_error = 44;
         end 
     end
     if( MODEL_SETTINGS.DEGREE_FILTER.BY_Y ~= 0)
         if( isnan(MODEL_SETTINGS.DEGREE_FILTER.MIN_Y) && local_error == 0)
            errordlg('Minimal allowed angle for Y axis is incorrect. Please provide a correct value.','Incorrect minimal allowed Y angle.');
            local_error = 45;
         end
         if( isnan(MODEL_SETTINGS.DEGREE_FILTER.MAX_Y) && local_error == 0)
            errordlg('Maximal allowed angle for Y axis is incorrect. Please provide a correct value.','Incorrect maximal allowed Y angle.');
            local_error = 46;
         end
         if( MODEL_SETTINGS.DEGREE_FILTER.MIN_Y>=MODEL_SETTINGS.DEGREE_FILTER.MAX_Y && local_error == 0)
            errordlg('Allowed range of angles for Y axis is incorrect. Please provide a correct value.','Incorrect allowed rangle of angles for Y axis.');
            local_error = 47;
         end 
     end
% ====== Data filtration settings END =======

% Checking if we are really doing something at all - at least one of five
% models are active and there was no errors at all
    if(model_count == 0 && local_error == 0)
        errordlg('You have not selected any model for classification. Please select at least one.','No models was selected');
        local_error = 10000;
    end

    if(local_error == 0)
        classificator = {8};
        method_str={8};
        used = zeros(8,1);
        data = cell(8,12);
        method_name = {'IVT'; 'IVVT'; 'pursuits'};
        if( MODEL_SETTINGS.USE.IVT ~= 0)
            classificator{1} = classificator_IVT_class;
            used(1) = 1;
            method_str{1} = '_ivt';
            classificator{1}.saccade_detection_threshold = MODEL_SETTINGS.IVT.SACCADE_DETECTION_THRESHOLD;
        end
        if( MODEL_SETTINGS.USE.IVVT ~= 0)
            classificator{2} = classificator_IVVT_class;
            used(2) = 1;
            method_str{2} = '_ivvt';
            classificator{2}.saccade_detection_threshold = MODEL_SETTINGS.IVVT.SACCADE_DETECTION_THRESHOLD;
            classificator{2}.fixation_detection_threshold = MODEL_SETTINGS.IVVT.FIXATION_DETECTION_THRESHOLD;
        end
        if( MODEL_SETTINGS.USE.PURSUITS ~= 0)
            classificator{3} = classificator_pursuits_class;
            used(3) = 1;
            method_str{3} = '_pursuits';
% Insert your fields here
%           classificator{3}.X1 = MODEL_SETTINGS.PURSUITS.X1;
%           classificator{3}.X2 = MODEL_SETTINGS.PURSUITS.X2;
%           .................................................
%
        end
    end
        
% ========== Real execution of classification models  START =================
% And now we can execute a real classifications methods according our
% selections
    
        
        for i=1:3
            data{ i,1 } = 'N/A';
            data{ i,2 } = 'N/A';
            data{ i,3 } = 'N/A';
            data{ i,4 } = 'N/A';
            data{ i,5 } = 'N/A';
            data{ i,6 } = 'N/A';
            data{ i,7 } = 'N/A';
            data{ i,8 } = 'N/A';
            data{ i,9 } = 'N/A';
            data{ i,10} = 'N/A';
            data{ i,11} = 'N/A';
            data{ i,12} = 'N/A';
            if( used(i) ~= 0 )
                classificator{i}.debug_mode =                   MODEL_SETTINGS.OUTPUT.DEBUG_MODE;
                classificator{i}.input_data_name =              MODEL_SETTINGS.READER.INPUT_DATA_NAME;
                classificator{i}.x_field =                      MODEL_SETTINGS.READER.X_FIELD;
                classificator{i}.y_field =                      MODEL_SETTINGS.READER.Y_FIELD;
                classificator{i}.v_field =                      MODEL_SETTINGS.READER.V_FIELD;
                classificator{i}.header_count =                 MODEL_SETTINGS.READER.HEADER_COUNT; 
                classificator{i}.delta_t_sec =                  MODEL_SETTINGS.READER.DELTA_T_SEC;
                classificator{i}.sample_rate =                  MODEL_SETTINGS.READER.SAMPLE_RATE;
                classificator{i}.fields_count =                 MODEL_SETTINGS.READER.FIELDS_COUNT;

                classificator{i}.use_degree_data_filtering_X =  MODEL_SETTINGS.DEGREE_FILTER.BY_X;
                classificator{i}.use_degree_data_filtering_Y =  MODEL_SETTINGS.DEGREE_FILTER.BY_Y;
                classificator{i}.minimal_allowed_X_degree =     MODEL_SETTINGS.DEGREE_FILTER.MIN_X;
                classificator{i}.maximal_allowed_X_degree =     MODEL_SETTINGS.DEGREE_FILTER.MAX_X;
                classificator{i}.minimal_allowed_Y_degree =     MODEL_SETTINGS.DEGREE_FILTER.MIN_Y;
                classificator{i}.maximal_allowed_Y_degree =     MODEL_SETTINGS.DEGREE_FILTER.MAX_Y;

                classificator{i}.read_data();
                if( classificator{i}.error_code == 0 )
                    if( MODEL_SETTINGS.CONVERTER.USE ~= 0)
                        classificator{i}.image_width_mm =                   MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_MM;
                        classificator{i}.image_height_mm =                  MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_MM;
                        classificator{i}.image_width_etu =                  MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_ETU;
                        classificator{i}.image_height_etu =                 MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_ETU;
                        classificator{i}.distance_from_screen =             MODEL_SETTINGS.CONVERTER.DISTANCE_FROM_SCREEN;
                        classificator{i}.distance_to_eye_position =         MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL;
                        classificator{i}.distance_to_lower_screen_edge =    MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE;
                        classificator{i}.convert_from_ETU_to_degrees();
                    end
                    classificator{i}.eye_tracker_data_filter_degree_range();
          
                    classificator{i}.classify();
                    classificator{i}.eye_tracker_data_filter_degree_range();
                    classificator{i}.merge_fixation_time_interval = MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL;
                    classificator{i}.merge_fixation_distance = MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE;
                    classificator{i}.merge_records();
                    if( MODEL_SETTINGS.FILTER.USE ~= 0)
                        classificator{i}.minimal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE;
                        classificator{i}.maximal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE;
                        classificator{i}.minimal_saccade_length =       MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH;
                        classificator{i}.unfiltered_saccade_records =   classificator{i}.saccade_records;
                        classificator{i}.saccade_filtering();
                        classificator{i}.saccade_records =              classificator{i}.filtered_saccade_records;
                    end
                    if( MODEL_SETTINGS.PROCESSING.PLOTS.USE ~= 0 || MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
% Hardcoded parameters for provided input files
                        scores_computator = scores_computation_class;
                        scores_computator.read_stimulus_data( MODEL_SETTINGS.READER.INPUT_DATA_NAME, 13, 14, 1, 14);
                        scores_computator.eye_records = classificator{i}.eye_records;
                        scores_computator.saccade_records = classificator{i}.saccade_records;
                        scores_computator.fixation_records = classificator{i}.fixation_records;
                        scores_computator.noise_records = classificator{i}.noise_records;
                        scores_computator.pursuit_records = classificator{i}.pursuit_records;
                        scores_computator.sample_rate = classificator{i}.sample_rate;
                        scores_computator.delta_t_sec = classificator{i}.delta_t_sec;

                        if( MODEL_SETTINGS.PROCESSING.PLOTS.USE ~= 0)
                            scores_computator.draw_graphics(MODEL_SETTINGS.PROCESSING.PLOTS.MODE,method_name{i});
                        end
                        if( MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
                            data{ i,1 } = scores_computator.SQnS;
                            data{ i,2 } = scores_computator.FQnS;
                            data{ i,3 } = scores_computator.PQnS;
                            data{ i,4 } = scores_computator.MisFix;
                            data{ i,5 } = scores_computator.FQlS;
                            data{ i,6 } = scores_computator.PQlS_P;
                            data{ i,7 } = scores_computator.PQlS_V;
                            data{ i,8 } = scores_computator.AFD;
                            data{ i,9 } = scores_computator.AFN;
                            data{ i,10} = scores_computator.ASA;
                            data{ i,11} = scores_computator.ANS;
                        end

                        % Attempting to gather all scores


                        clear scores_computator;
                    end
                    
                    classificator{i}.basename_output_filename =     strcat(MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_FILENAME,char(method_str{i}));
                    classificator{i}.basename_output_extension =    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_EXTENSION;
                    classificator{i}.setup_output_names();
                    classificator{i}.write_datafiles();
                else
                    errordlg(classificator{i}.error_message,'File reader error.');
                end
            end
        end
        set( findobj('Tag','Scores_Table'), 'Data', data );
    
% Switch Classify button back to on
set( findobj('Tag','Execute_Classification_Button'), 'Enable', 'On');


function [classificator, MODEL_SETTINGS] = Classifier_Setup(InputFile, classifier_index)
    clc;
    path(path,'classificator_1.5');
    path(path, 'Results');

    MODEL_SETTINGS.READER.INPUT_DATA_NAME = InputFile;
    MODEL_SETTINGS.READER.X_FIELD = 8;
    MODEL_SETTINGS.READER.Y_FIELD = 9;
    MODEL_SETTINGS.READER.V_FIELD = 11;
    MODEL_SETTINGS.READER.HEADER_COUNT = 1;
    MODEL_SETTINGS.READER.SAMPLE_RATE = 1000;
    MODEL_SETTINGS.READER.FIELDS_COUNT = 14;
    MODEL_SETTINGS.READER.DELTA_T_SEC = 1/1000;
    MODEL_SETTINGS.CONVERTER.USE = false;

    MODEL_SETTINGS.FILTER.USE = true;
    MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE = 4;
    MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE = 180;
    MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH = 4;

    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_FILENAME = 'classificator_1.5\output\s_001';
    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_EXTENSION = '.txt';
    MODEL_SETTINGS.OUTPUT.DEBUG_MODE = false;
    MODEL_SETTINGS.PROCESSING.PLOTS.USE = false;
    MODEL_SETTINGS.PROCESSING.SCORES.USE = true;

    MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL = 75;
    MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE = 0.5;

    MODEL_SETTINGS.DEGREE_FILTER.BY_X = false;
    MODEL_SETTINGS.DEGREE_FILTER.BY_Y = false;
    MODEL_SETTINGS.DEGREE_FILTER.MIN_X = 0;
    MODEL_SETTINGS.DEGREE_FILTER.MAX_X = 0;
    MODEL_SETTINGS.DEGREE_FILTER.MIN_Y = 0;
    MODEL_SETTINGS.DEGREE_FILTER.MAX_Y = 0;


    classificator = {8};
    method_str={8};
    %used = zeros(8,1);
    %data = cell(8,12);
    %method_name = {'IVT'; 'IVVT'; 'pursuits'};
    classificator{classifier_index} = classificator_pursuits_class;
    method_str{classifier_index} = '_pursuits';

    classificator{classifier_index}.debug_mode =                   MODEL_SETTINGS.OUTPUT.DEBUG_MODE;
    classificator{classifier_index}.input_data_name =              MODEL_SETTINGS.READER.INPUT_DATA_NAME;
    classificator{classifier_index}.x_field =                      MODEL_SETTINGS.READER.X_FIELD;
    classificator{classifier_index}.y_field =                      MODEL_SETTINGS.READER.Y_FIELD;
    classificator{classifier_index}.v_field =                      MODEL_SETTINGS.READER.V_FIELD;
    classificator{classifier_index}.header_count =                 MODEL_SETTINGS.READER.HEADER_COUNT; 
    classificator{classifier_index}.delta_t_sec =                  MODEL_SETTINGS.READER.DELTA_T_SEC;
    classificator{classifier_index}.sample_rate =                  MODEL_SETTINGS.READER.SAMPLE_RATE;
    classificator{classifier_index}.fields_count =                 MODEL_SETTINGS.READER.FIELDS_COUNT;

    classificator{classifier_index}.use_degree_data_filtering_X =  MODEL_SETTINGS.DEGREE_FILTER.BY_X;
    classificator{classifier_index}.use_degree_data_filtering_Y =  MODEL_SETTINGS.DEGREE_FILTER.BY_Y;
    classificator{classifier_index}.minimal_allowed_X_degree =     MODEL_SETTINGS.DEGREE_FILTER.MIN_X;
    classificator{classifier_index}.maximal_allowed_X_degree =     MODEL_SETTINGS.DEGREE_FILTER.MAX_X;
    classificator{classifier_index}.minimal_allowed_Y_degree =     MODEL_SETTINGS.DEGREE_FILTER.MIN_Y;
    classificator{classifier_index}.maximal_allowed_Y_degree =     MODEL_SETTINGS.DEGREE_FILTER.MAX_Y;

    classificator{classifier_index}.read_data();
    if( classificator{classifier_index}.error_code == 0 )
        if( MODEL_SETTINGS.CONVERTER.USE ~= 0)
            classificator{classifier_index}.image_width_mm =                   MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_MM;
            classificator{classifier_index}.image_height_mm =                  MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_MM;
            classificator{classifier_index}.image_width_etu =                  MODEL_SETTINGS.CONVERTER.IMAGE_WIDTH_ETU;
            classificator{classifier_index}.image_height_etu =                 MODEL_SETTINGS.CONVERTER.IMAGE_HEIGHT_ETU;
            classificator{classifier_index}.distance_from_screen =             MODEL_SETTINGS.CONVERTER.DISTANCE_FROM_SCREEN;
            classificator{classifier_index}.distance_to_eye_position =         MODEL_SETTINGS.CONVERTER.DISTANCE_TO_EYE_LEVEL;
            classificator{classifier_index}.distance_to_lower_screen_edge =    MODEL_SETTINGS.CONVERTER.DISTANCE_TO_LOWER_SCREEN_EDGE;
            classificator{classifier_index}.convert_from_ETU_to_degrees();
        end
        classificator{classifier_index}.eye_tracker_data_filter_degree_range();
        
        %classificator{classifier_index}.basename_output_filename =     strcat(MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_FILENAME,char(method_str{classifier_index}));
        %classificator{classifier_index}.basename_output_extension =    MODEL_SETTINGS.OUTPUT.BASENAME_OUTPUT_EXTENSION;
        %classificator{classifier_index}.setup_output_names();
        %classificator{classifier_index}.write_datafiles();   
    end

% ========== Real execution of classification models  END ===================
function Run_Thresholding_Classifier(hObject, InputFile, classifier_index, sample_rates)
        
        [classificator, MODEL_SETTINGS] = Classifier_Setup(InputFile, classifier_index);

        TestThresholds(classificator, MODEL_SETTINGS, classifier_index, sample_rates);
           
function Run_Saccade_Thresholding_Classifier(hObject, InputFile, classifier_index, sample_rates, saccade_threshold)
        [classificator, MODEL_SETTINGS] = Classifier_Setup(InputFile, classifier_index);

        TestSaccadeThresholds(classificator, MODEL_SETTINGS, classifier_index, sample_rates, saccade_threshold);

function TestSaccadeThresholds(classificator, MODEL_SETTINGS, classifier_index, sample_rates, saccade_threshold)
    disp('Testing thresholds...');
   
    [INPUT_DATA_FILE, INPUT_DATA_NAME] = GetDataFile(MODEL_SETTINGS);
    
    frequency_directory_name = "Results/FrequencyResults/";
    final_results_directory_name = "Results/FinalResults/";
    
    normal_rate = MODEL_SETTINGS.READER.SAMPLE_RATE;
    final_threshold_scores = [];
    scores_index = 1;
    
    for sample_index=1:length(sample_rates)
        frequency_threshold_scores = [];
        frequency_scores_index = 1;
        sample_rate = sample_rates(sample_index);
        subsample_ratio = normal_rate/sample_rate;
        
        classificator{classifier_index}.sample_rate = sample_rate;
        classificator{classifier_index}.delta_t_sec = 1/sample_rate;
        classificator{classifier_index}.input_data_name = INPUT_DATA_FILE + '_' + string(sample_rate) + '.txt';
        classificator{classifier_index}.header_count =                 MODEL_SETTINGS.READER.HEADER_COUNT; 
        classificator{classifier_index}.read_data();
        
        scores_computator = scores_computation_class;
        scores_computator.read_stimulus_data( classificator{classifier_index}.input_data_name, 13, 14, 1, 14);
        
        disp('Testing threshold scores for sampling frequency: ' + string(sample_rate));

        % Test Threshold: 150:155, 50:50, 150:150 
        % Partial Threshold Test: 75:5:175, 10:10:150, 100:10:200
        % Full threshold Test: 50:250, 1:500, 75:300
        disp('Testing saccade threshold: '+ string(saccade_threshold) + ' on frequency: ' + string(sample_rate));
        duration_threshold = 150;

        for dispersion_threshold=10:10:200
            %for duration_threshold=100:10:200

            AlgorithmStartTime = clock;
            classificator{classifier_index}.classify(true, saccade_threshold, double(dispersion_threshold/100), duration_threshold, subsample_ratio);
            AlgorithmEndTime = clock;
            classificator{classifier_index}.eye_tracker_data_filter_degree_range();
            classificator{classifier_index}.merge_fixation_time_interval = MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL;
            classificator{classifier_index}.merge_fixation_distance = MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE;
            classificator{classifier_index}.merge_records();
            if( MODEL_SETTINGS.FILTER.USE ~= 0)
                classificator{classifier_index}.minimal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE;
                classificator{classifier_index}.maximal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE;
                classificator{classifier_index}.minimal_saccade_length =       MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH;
                classificator{classifier_index}.unfiltered_saccade_records =   classificator{classifier_index}.saccade_records;
                classificator{classifier_index}.saccade_filtering();
                classificator{classifier_index}.saccade_records =              classificator{classifier_index}.filtered_saccade_records;
            end
            if( MODEL_SETTINGS.PROCESSING.PLOTS.USE ~= 0 || MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
% Hardcoded parameters for provided input files
                scores_computator = scores_computation_class;
                scores_computator.read_stimulus_data( classificator{classifier_index}.input_data_name, 13, 14, 1, 14);
                scores_computator.eye_records = classificator{classifier_index}.eye_records;
                scores_computator.saccade_records = classificator{classifier_index}.saccade_records;
                scores_computator.fixation_records = classificator{classifier_index}.fixation_records;
                scores_computator.noise_records = classificator{classifier_index}.noise_records;
                scores_computator.pursuit_records = classificator{classifier_index}.pursuit_records;
                scores_computator.sample_rate = sample_rate;
                scores_computator.delta_t_sec = 1/sample_rate;
            end
            if( MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
                ClassificationEndTime = clock;
                AlgorithmRunTime = AlgorithmEndTime - AlgorithmStartTime;
                AlgorithmRunTime = 60*AlgorithmRunTime(5) + AlgorithmRunTime(6);
                ClassificationRunTime = ClassificationEndTime - AlgorithmStartTime;
                ClassificationRunTime = 60*ClassificationRunTime(5) + ClassificationRunTime(6);

                frequency_threshold_scores(frequency_scores_index, :) = [double(sample_rate) double(AlgorithmRunTime) double(ClassificationRunTime) ...
                    double(saccade_threshold) double(dispersion_threshold/100) double(duration_threshold) ...
                    double(scores_computator.SQnS) double(scores_computator.FQnS) double(scores_computator.PQnS) ...
                    double(scores_computator.MisFix) double(scores_computator.FQlS) double(scores_computator.PQlS_P) double(scores_computator.PQlS_V)];
                final_threshold_scores(scores_index, :) = [double(sample_rate) double(AlgorithmRunTime) double(ClassificationRunTime) ...
                    double(saccade_threshold) double(dispersion_threshold/100) double(duration_threshold) ...
                    double(scores_computator.SQnS) double(scores_computator.FQnS) double(scores_computator.PQnS) ...
                    double(scores_computator.MisFix) double(scores_computator.FQlS) double(scores_computator.PQlS_P) double(scores_computator.PQlS_V)];

                scores_index = scores_index + 1;
                frequency_scores_index = frequency_scores_index + 1;
            end
        end
        
        
        disp('Saving threshold scores for sampling frequency: ' + string(sample_rate));

        resultTime = ResultsTime();
        %filename = frequency_directory_name + resultTime + '-f' + string(sample_rate) + '-' + INPUT_DATA_NAME + '.mat';
        filename = frequency_directory_name + "f" + string(sample_rate) + "-s-" + saccade_threshold + "-" + INPUT_DATA_NAME + ".mat";

        save(filename, 'frequency_threshold_scores');
        disp('Threshold scores for sampling frequency: ' + string(sample_rate) + ' saved.');
        
        % Calculate Ideal scores
        %disp('Calculating Ideal Thresholds for samling frequency: ' + string(sample_rate));
        %ideal_scores = IdealScores(scores_computator.stimulus_records, subsample_ratio);
        %CalculateIdealThresholds(ideal_scores, frequency_threshold_scores, INPUT_DATA_NAME, final_results_directory_name, sample_rate);
        %disp('Ideal Thresholds for sampling frequency: ' + string(sample_rate) + ' calculated and saved');

    end
        
        
        
function TestThresholds(classificator, MODEL_SETTINGS, classifier_index, sample_rates)
    disp('Testing thresholds...');
   
    [INPUT_DATA_FILE, INPUT_DATA_NAME] = GetDataFile(MODEL_SETTINGS);
    
    frequency_directory_name = "Results/FrequencyResults/";
    final_results_directory_name = "Results/FinalResults/";
    
    normal_rate = MODEL_SETTINGS.READER.SAMPLE_RATE;
    final_threshold_scores = [];
    scores_index = 1;
    
    for sample_index=1:length(sample_rates)
        frequency_threshold_scores = [];
        frequency_scores_index = 1;
        sample_rate = sample_rates(sample_index);
        subsample_ratio = normal_rate/sample_rate;
        
        classificator{classifier_index}.sample_rate = sample_rate;
        classificator{classifier_index}.delta_t_sec = 1/sample_rate;
        classificator{classifier_index}.input_data_name = INPUT_DATA_FILE + '_' + string(sample_rate) + '.txt';
        classificator{classifier_index}.header_count =                 MODEL_SETTINGS.READER.HEADER_COUNT; 
        classificator{classifier_index}.read_data();
        
        scores_computator = scores_computation_class;
        scores_computator.read_stimulus_data( classificator{classifier_index}.input_data_name, 13, 14, 1, 14);
        
        disp('Testing threshold scores for sampling frequency: ' + string(sample_rate));

        % Test Threshold: 150:155, 50:50, 150:150 
        % Partial Threshold Test: 75:5:175, 10:10:150, 100:10:200
        % Full threshold Test: 50:250, 1:500, 75:300
        duration_threshold = 150;
        for saccade_threshold=70:5:150
            disp('Testing saccade threshold: '+ string(saccade_threshold) + ' on frequency: ' + string(sample_rate));
            for dispersion_threshold=10:10:200
                %for duration_threshold=100:10:100

                AlgorithmStartTime = clock;
                classificator{classifier_index}.classify(true, saccade_threshold, double(dispersion_threshold/100), duration_threshold, subsample_ratio);
                AlgorithmEndTime = clock;
                classificator{classifier_index}.eye_tracker_data_filter_degree_range();
                classificator{classifier_index}.merge_fixation_time_interval = MODEL_SETTINGS.MERGE.MERGE_FIXATION_TIME_INTERVAL;
                classificator{classifier_index}.merge_fixation_distance = MODEL_SETTINGS.MERGE.MERGE_FIXATION_DISTANCE;
                classificator{classifier_index}.merge_records();
                if( MODEL_SETTINGS.FILTER.USE ~= 0)
                    classificator{classifier_index}.minimal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_AMPLITUDE;
                    classificator{classifier_index}.maximal_saccade_amplitude =    MODEL_SETTINGS.FILTER.MAXIMAL_SACCADE_AMPLITUDE;
                    classificator{classifier_index}.minimal_saccade_length =       MODEL_SETTINGS.FILTER.MINIMAL_SACCADE_LENGTH;
                    classificator{classifier_index}.unfiltered_saccade_records =   classificator{classifier_index}.saccade_records;
                    classificator{classifier_index}.saccade_filtering();
                    classificator{classifier_index}.saccade_records =              classificator{classifier_index}.filtered_saccade_records;
                end
                if( MODEL_SETTINGS.PROCESSING.PLOTS.USE ~= 0 || MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
% Hardcoded parameters for provided input files
                    scores_computator = scores_computation_class;
                    scores_computator.read_stimulus_data( classificator{classifier_index}.input_data_name, 13, 14, 1, 14);
                    scores_computator.eye_records = classificator{classifier_index}.eye_records;
                    scores_computator.saccade_records = classificator{classifier_index}.saccade_records;
                    scores_computator.fixation_records = classificator{classifier_index}.fixation_records;
                    scores_computator.noise_records = classificator{classifier_index}.noise_records;
                    scores_computator.pursuit_records = classificator{classifier_index}.pursuit_records;
                    scores_computator.sample_rate = sample_rate;
                    scores_computator.delta_t_sec = 1/sample_rate;
                end
                if( MODEL_SETTINGS.PROCESSING.SCORES.USE ~= 0)
                    ClassificationEndTime = clock;
                    AlgorithmRunTime = AlgorithmEndTime - AlgorithmStartTime;
                    AlgorithmRunTime = 60*AlgorithmRunTime(5) + AlgorithmRunTime(6);
                    ClassificationRunTime = ClassificationEndTime - AlgorithmStartTime;
                    ClassificationRunTime = 60*ClassificationRunTime(5) + ClassificationRunTime(6);

                    frequency_threshold_scores(frequency_scores_index, :) = [double(sample_rate) double(AlgorithmRunTime) double(ClassificationRunTime) ...
                        double(saccade_threshold) double(dispersion_threshold/100) double(duration_threshold) ...
                        double(scores_computator.SQnS) double(scores_computator.FQnS) double(scores_computator.PQnS) ...
                        double(scores_computator.MisFix) double(scores_computator.FQlS) double(scores_computator.PQlS_P) double(scores_computator.PQlS_V)];
                    final_threshold_scores(scores_index, :) = [double(sample_rate) double(AlgorithmRunTime) double(ClassificationRunTime) ...
                        double(saccade_threshold) double(dispersion_threshold/100) double(duration_threshold) ...
                        double(scores_computator.SQnS) double(scores_computator.FQnS) double(scores_computator.PQnS) ...
                        double(scores_computator.MisFix) double(scores_computator.FQlS) double(scores_computator.PQlS_P) double(scores_computator.PQlS_V)];

                    scores_index = scores_index + 1;
                    frequency_scores_index = frequency_scores_index + 1;
                end
                %end
            end
        end
        
        disp('Saving threshold scores for sampling frequency: ' + string(sample_rate));

        resultTime = ResultsTime();
        %filename = frequency_directory_name + resultTime + '-f' + string(sample_rate) + '-' + INPUT_DATA_NAME + '.mat';
        filename = frequency_directory_name + "f" + string(sample_rate) + "-" + INPUT_DATA_NAME + ".mat";

        save(filename, 'frequency_threshold_scores');
        disp('Threshold scores for sampling frequency: ' + string(sample_rate) + ' saved.');
        
        % Calculate Ideal scores
        %disp('Calculating Ideal Thresholds for samling frequency: ' + string(sample_rate));
        %ideal_scores = IdealScores(scores_computator.stimulus_records, subsample_ratio);
        %CalculateIdealThresholds(ideal_scores, frequency_threshold_scores, INPUT_DATA_NAME, final_results_directory_name, sample_rate);
        %disp('Ideal Thresholds for sampling frequency: ' + string(sample_rate) + ' calculated and saved');

    end
    disp('All thresholds tested.');
    
    disp('Saving threshold results to file...');
    resultTime = ResultsTime();
    filename = final_results_directory_name + INPUT_DATA_NAME + "-results.mat";
    
    % Write scores to file
    save(filename, 'final_threshold_scores');
    
    disp('Thresholds results saved to file.')
   
function [INPUT_DATA_FILE, INPUT_DATA_NAME] = GetDataFile(MODEL_SETTINGS)

    INPUT_DATA_FILE = MODEL_SETTINGS.READER.INPUT_DATA_NAME;
    INPUT_DATA_FILE = split(INPUT_DATA_FILE, '/');
    temp_INPUT_DATA_FILE = '';
    for dir_index=1:length(INPUT_DATA_FILE)
        if isempty(INPUT_DATA_FILE{dir_index})
            continue
        elseif string(INPUT_DATA_FILE{dir_index}) == 'input'
            temp_INPUT_DATA_FILE = temp_INPUT_DATA_FILE + '/' + INPUT_DATA_FILE{dir_index} + '/Subsamples';
        else
            temp_INPUT_DATA_FILE = string(temp_INPUT_DATA_FILE) + '/' + INPUT_DATA_FILE{dir_index};
        end
        
    end
    INPUT_DATA_FILE = temp_INPUT_DATA_FILE;
    INPUT_DATA_FILE = split(INPUT_DATA_FILE, '.');
    INPUT_DATA_FILE = string(INPUT_DATA_FILE(1)) + '.' + string(INPUT_DATA_FILE(2));
    
    INPUT_DATA_NAME = split(MODEL_SETTINGS.READER.INPUT_DATA_NAME, '/');
    INPUT_DATA_NAME = INPUT_DATA_NAME(length(INPUT_DATA_NAME));
    INPUT_DATA_NAME = split(INPUT_DATA_NAME, '.');
    INPUT_DATA_NAME = INPUT_DATA_NAME{1};
    
    
function Run_IdealThresholdCalculator(hObject, InputFile, sample_frequency, classifier_index, threshold_file, weighted) 
    disp('Running ideal threshold calculator');
    final_results_directory_name = 'Results/OptimalResults/';
    
    subsample_ratio = 1000/sample_frequency;

    threshold_scores = load(threshold_file);

    threshold_scores = threshold_scores.frequency_threshold_scores;
    
    [classificator, MODEL_SETTINGS] = Classifier_Setup(InputFile, classifier_index);
    
    % input_data = 's_007';
    [INPUT_DATA_FILE, INPUT_DATA_NAME] = GetDataFile(MODEL_SETTINGS);
    
    scores_computator = scores_computation_class;
    scores_computator.read_stimulus_data( classificator{classifier_index}.input_data_name, 13, 14, 1, 14);
    
    % Calculate Ideal scores
    %ideal_scores = IdealScores(scores_computator.stimulus_records, subsample_ratio);
    ideal_scores = [];
    CalculateIdealThresholds(ideal_scores, threshold_scores, INPUT_DATA_NAME, final_results_directory_name, sample_frequency, weighted);


function CalculateIdealThresholds(ideal_scores, threshold_scores, INPUT_DATA_NAME, final_results_directory_name, sample_rate, weighted)
    disp('Calculating Ideal Thresholds...');
    
    if weighted
        weight = 10;
    else
        weight = 1;
    end
    
    % Attempt to fetch ideal_scores
    try
        IDEAL_FQnS = ideal_scores(1,1);
        IDEAL_SQnS = ideal_scores(1,2);
        IDEAL_PQnS = ideal_scores(1,3);
        IDEAL_FQlS = ideal_scores(1,4);
        IDEAL_MisFix = ideal_scores(1,5);
        IDEAL_PQlS_P = ideal_scores(1,6);
        IDEAL_PQlS_V = ideal_scores(1,7);
    catch
        % Pulled from ternary classification paper
        IDEAL_PQnS = 52;
        IDEAL_FQnS = 83.9;
        IDEAL_SQnS = 100;
        IDEAL_MisFix = 7.1;
        IDEAL_FQlS = 0;
        IDEAL_PQlS_P = 0;
        IDEAL_PQlS_V = 0;
    end
    
    SACCADE_THRESHOLD_INDEX = 4;
    DISPERSION_INDEX = 5;
    DURATION_INDEX = 6;
    SQnS_INDEX = 7;
    FQnS_INDEX = 8;
    PQnS_INDEX = 9;
    MisFix_INDEX = 10;
    FQlS_INDEX = 11;
    PQlS_P_INDEX = 12;
    PQlS_V_INDEX = 13;
    
    best_saccade_threshold = 0;
    best_dispersion_threshold = 0;
    best_duration_threshold = 0;
    minimum_distance = 1000;
    
    best_PQnS = 0;
    best_FQnS = 0;
    best_SQnS = 0;
    best_MisFix = 0;
    best_FQlS = 0;
    best_PQlS_P = 0;
    best_PQlS_V = 0;
    
    for index=1:size(threshold_scores, 1)
        distance = sqrt( ...
            weight * abs(threshold_scores(index, PQnS_INDEX) - IDEAL_PQnS)^2 + ...
            weight * abs(threshold_scores(index, FQnS_INDEX) - IDEAL_FQnS)^2 + ...
            weight * abs(threshold_scores(index, SQnS_INDEX) - IDEAL_SQnS)^2 + ...
            weight * abs(threshold_scores(index, MisFix_INDEX) - IDEAL_MisFix)^2 + ...
            weight * abs(threshold_scores(index, FQlS_INDEX) - IDEAL_FQlS)^2 + ...
            abs(threshold_scores(index, PQlS_P_INDEX) - IDEAL_PQlS_P)^2 + ...
            abs(threshold_scores(index, PQlS_V_INDEX) - IDEAL_PQlS_V)^2);

        if distance < minimum_distance
            minimum_distance = distance;
            best_saccade_threshold = threshold_scores(index, SACCADE_THRESHOLD_INDEX);
            best_dispersion_threshold = threshold_scores(index, DISPERSION_INDEX);
            best_duration_threshold = threshold_scores(index, DURATION_INDEX);
            best_PQnS = threshold_scores(index, PQnS_INDEX);
            best_FQnS = threshold_scores(index, FQnS_INDEX);
            best_SQnS = threshold_scores(index, SQnS_INDEX);
            best_MisFix = threshold_scores(index, MisFix_INDEX);
            best_FQlS = threshold_scores(index, FQlS_INDEX);
            best_PQlS_P = threshold_scores(index, PQlS_P_INDEX);
            best_PQlS_V = threshold_scores(index, PQlS_V_INDEX);
        end
    end
    
    disp('Ideal Thresholds Computed.');
    
    disp('Saving ideal Thresholds to file...');
    % Now need to write best scores to file
    filename = final_results_directory_name + "f" + string(sample_rate) + '-' + INPUT_DATA_NAME + '-best.mat';
    save(filename, 'minimum_distance', 'best_saccade_threshold', 'best_dispersion_threshold', 'best_duration_threshold', ...
        'best_PQnS', 'best_FQnS', 'best_SQnS', 'best_MisFix', 'best_FQlS', 'best_PQlS_P', 'best_PQlS_V');
    
    disp('Ideal Thresholds saved.');

function [resultTime] = ResultsTime()
    time = clock;
    resultTime = string(time(1)) + '-' + string(time(2)) + '-' + string(time(3)) + '-' + string(time(4)) + '-' + string(time(5));
    
    
% --- Executes during object creation, after setting all properties.
function IVT_Saccade_Detection_Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IVT_Saccade_Detection_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% This function is GUI only. It can change GUI widgets state according
% desired.
% Here widgets_list is a list of GUI widget for state change - it have to
% be cell string array type
% tmp_enable_state is desired state for them - it have to be one of on, off
% or inctive state or else it wouldn't work as desired
function change_model_settings_state(widgets_list,tmp_enable_state)
    for i=1:length(widgets_list)
        set(findobj('Tag',char(widgets_list(i))),'Enable',tmp_enable_state);
    end

    clear i;

% --- Executes during object creation, after setting all properties.
function Field1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Field1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Field2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Field2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Image_Width_ETU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Width_ETU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Image_Height_ETU_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Height_ETU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Image_Width_MM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Width_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Image_Height_MM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Height_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Distance_From_Screen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Distance_From_Screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Input_File_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_File_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function X_Field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to X_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Y_Field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Y_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function V_Field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Header_Count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Header_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Sample_Rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Distance_To_Eye_Level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Distance_To_Eye_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Distance_To_Lower_Screen_Edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Distance_To_Lower_Screen_Edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Minimal_Saccade_Amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Minimal_Saccade_Amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Maximal_Saccade_Amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Maximal_Saccade_Amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Minimal_Saccade_Length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Minimal_Saccade_Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Basename_Output_Filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Basename_Output_Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Basename_Output_Extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Basename_Output_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Select_Input_File.
function Select_Input_File_Callback(hObject, eventdata, handles)
% hObject    handle to Select_Input_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function IVT_Saccade_Detection_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to IVT_Saccade_Detection_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IVT_Saccade_Detection_Threshold as text
%        str2double(get(hObject,'String')) returns contents of IVT_Saccade_Detection_Threshold as a double



function Field1_Callback(hObject, eventdata, handles)
% hObject    handle to Field1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Field1 as text
%        str2double(get(hObject,'String')) returns contents of Field1 as a double



function Field2_Callback(hObject, eventdata, handles)
% hObject    handle to Field2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Field2 as text
%        str2double(get(hObject,'String')) returns contents of Field2 as a double



function Minimal_Saccade_Amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to Minimal_Saccade_Amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Minimal_Saccade_Amplitude as text
%        str2double(get(hObject,'String')) returns contents of Minimal_Saccade_Amplitude as a double



function Maximal_Saccade_Amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to Maximal_Saccade_Amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Maximal_Saccade_Amplitude as text
%        str2double(get(hObject,'String')) returns contents of Maximal_Saccade_Amplitude as a double



function Minimal_Saccade_Length_Callback(hObject, eventdata, handles)
% hObject    handle to Minimal_Saccade_Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Minimal_Saccade_Length as text
%        str2double(get(hObject,'String')) returns contents of Minimal_Saccade_Length as a double



function Input_File_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Input_File_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_File_Name as text
%        str2double(get(hObject,'String')) returns contents of Input_File_Name as a double



function X_Field_Callback(hObject, eventdata, handles)
% hObject    handle to X_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of X_Field as text
%        str2double(get(hObject,'String')) returns contents of X_Field as a double



function Y_Field_Callback(hObject, eventdata, handles)
% hObject    handle to Y_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Y_Field as text
%        str2double(get(hObject,'String')) returns contents of Y_Field as a double



function V_Field_Callback(hObject, eventdata, handles)
% hObject    handle to V_Field (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V_Field as text
%        str2double(get(hObject,'String')) returns contents of V_Field as a double



function Header_Count_Callback(hObject, eventdata, handles)
% hObject    handle to Header_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Header_Count as text
%        str2double(get(hObject,'String')) returns contents of Header_Count as a double



function Sample_Rate_Callback(hObject, eventdata, handles)
% hObject    handle to Sample_Rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sample_Rate as text
%        str2double(get(hObject,'String')) returns contents of Sample_Rate as a double



function Image_Width_ETU_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Width_ETU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Width_ETU as text
%        str2double(get(hObject,'String')) returns contents of Image_Width_ETU as a double



function Image_Height_ETU_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Height_ETU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Height_ETU as text
%        str2double(get(hObject,'String')) returns contents of Image_Height_ETU as a double



function Image_Width_MM_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Width_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Width_MM as text
%        str2double(get(hObject,'String')) returns contents of Image_Width_MM as a double



function Image_Height_MM_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Height_MM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Height_MM as text
%        str2double(get(hObject,'String')) returns contents of Image_Height_MM as a double



function Distance_From_Screen_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_From_Screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Distance_From_Screen as text
%        str2double(get(hObject,'String')) returns contents of Distance_From_Screen as a double



function Distance_To_Eye_Level_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_To_Eye_Level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Distance_To_Eye_Level as text
%        str2double(get(hObject,'String')) returns contents of Distance_To_Eye_Level as a double



function Distance_To_Lower_Screen_Edge_Callback(hObject, eventdata, handles)
% hObject    handle to Distance_To_Lower_Screen_Edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Distance_To_Lower_Screen_Edge as text
%        str2double(get(hObject,'String')) returns contents of Distance_To_Lower_Screen_Edge as a double



function Basename_Output_Filename_Callback(hObject, eventdata, handles)
% hObject    handle to Basename_Output_Filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Basename_Output_Filename as text
%        str2double(get(hObject,'String')) returns contents of Basename_Output_Filename as a double



function Basename_Output_Extension_Callback(hObject, eventdata, handles)
% hObject    handle to Basename_Output_Extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Basename_Output_Extension as text
%        str2double(get(hObject,'String')) returns contents of Basename_Output_Extension as a double


% --- Executes on button press in Enable_Scores_Calculations.
function Enable_Scores_Calculations_Callback(hObject, eventdata, handles)
% hObject    handle to Enable_Scores_Calculations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Enable_Scores_Calculations



function Merge_Time_Interval_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_Time_Interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Merge_Time_Interval as text
%        str2double(get(hObject,'String')) returns contents of Merge_Time_Interval as a double


% --- Executes during object creation, after setting all properties.
function Merge_Time_Interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Merge_Time_Interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Merge_Distance_Callback(hObject, eventdata, handles)
% hObject    handle to Merge_Distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Merge_Distance as text
%        str2double(get(hObject,'String')) returns contents of Merge_Distance as a double


% --- Executes during object creation, after setting all properties.
function Merge_Distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Merge_Distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Fields_Count_Callback(hObject, eventdata, handles)
% hObject    handle to Fields_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fields_Count as text
%        str2double(get(hObject,'String')) returns contents of Fields_Count as a double


% --- Executes during object creation, after setting all properties.
function Fields_Count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fields_Count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Debug_Mode.
function Debug_Mode_Callback(hObject, eventdata, handles)
% hObject    handle to Debug_Mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Debug_Mode


% --- Executes on button press in Filtrate_Input_Data_X.
function Filtrate_Input_Data_X_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrate_Input_Data_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Create array of all GUI widgets that belongs to I-HMM Model
    tmp_widgets = {'Minimal_X_degree';'Maximal_X_degree'};
% Get state of checkbox
    if(get(hObject,'Value') > 0)
        tmp_enable_state='on';
    else
        tmp_enable_state='off';
    end
    change_model_settings_state(tmp_widgets,tmp_enable_state);


function Minimal_X_degree_Callback(hObject, eventdata, handles)
% hObject    handle to Minimal_X_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Minimal_X_degree as text
%        str2double(get(hObject,'String')) returns contents of Minimal_X_degree as a double


% --- Executes during object creation, after setting all properties.
function Minimal_X_degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Minimal_X_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Maximal_X_degree_Callback(hObject, eventdata, handles)
% hObject    handle to Maximal_X_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Maximal_X_degree as text
%        str2double(get(hObject,'String')) returns contents of Maximal_X_degree as a double


% --- Executes during object creation, after setting all properties.
function Maximal_X_degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Maximal_X_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Minimal_Y_degree_Callback(hObject, eventdata, handles)
% hObject    handle to Minimal_Y_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Minimal_Y_degree as text
%        str2double(get(hObject,'String')) returns contents of Minimal_Y_degree as a double


% --- Executes during object creation, after setting all properties.
function Minimal_Y_degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Minimal_Y_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Maximal_Y_degree_Callback(hObject, eventdata, handles)
% hObject    handle to Maximal_Y_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Maximal_Y_degree as text
%        str2double(get(hObject,'String')) returns contents of Maximal_Y_degree as a double


% --- Executes during object creation, after setting all properties.
function Maximal_Y_degree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Maximal_Y_degree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Filtrate_Input_Data_Y.
function Filtrate_Input_Data_Y_Callback(hObject, eventdata, handles)
% hObject    handle to Filtrate_Input_Data_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Create array of all GUI widgets that belongs to I-VT Model
    tmp_widgets = {'Minimal_Y_degree';'Maximal_Y_degree'};
% Get state of checkbox
    if(get(hObject,'Value') > 0), tmp_enable_state='on'; else tmp_enable_state='off'; end
    change_model_settings_state(tmp_widgets,tmp_enable_state);


% --- Executes on button press in Use_IVVT_Model_Checkbox.
function Use_IVVT_Model_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Use_IVVT_Model_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_IVVT_Model_Checkbox

% Create array of all GUI widgets that belongs to I-VT Model
    tmp_widgets = {'IVT_Saccade_Detection_Threshold'};
    invoke_state_change = false;
% Get state of checkbox
    if(get(hObject,'Value') > 0), tmp_enable_state='on'; invoke_state_change = true;
    elseif( ~get( findobj('Tag', 'Use_IVT_Model_Checkbox'), 'Value') )
        tmp_enable_state='off';
        invoke_state_change = true;
    end
    if( invoke_state_change ), change_model_settings_state(tmp_widgets,tmp_enable_state); end

    % Create array of all GUI widgets that belongs to I-VVT Model
    tmp_widgets = {'IVVT_Fixation_Detection_Threshold'};
% Get state of checkbox
    if(get(hObject,'Value') > 0), tmp_enable_state='on'; else tmp_enable_state='off'; end
    change_model_settings_state(tmp_widgets,tmp_enable_state);

function IVVT_Fixation_Detection_Threshold_Callback(hObject, eventdata, handles)
% hObject    handle to IVVT_Fixation_Detection_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IVVT_Fixation_Detection_Threshold as text
%        str2double(get(hObject,'String')) returns contents of IVVT_Fixation_Detection_Threshold as a double


% --- Executes during object creation, after setting all properties.
function IVVT_Fixation_Detection_Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IVVT_Fixation_Detection_Threshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Scores_Table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Scores_Table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Use_USER_Model_Checkbox.
function Use_User_Model_Checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to Use_USER_Model_Checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Use_USER_Model_Checkbox
