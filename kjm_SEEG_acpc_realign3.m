function varargout = kjm_SEEG_acpc_realign3(varargin)
% KJM_SEEG_ACPC_REALIGN3 MATLAB code for kjm_SEEG_acpc_realign3.fig
%      KJM_SEEG_ACPC_REALIGN3, by itself, creates a new KJM_SEEG_ACPC_REALIGN3 or raises the existing
%      singleton*.
%
%      H = KJM_SEEG_ACPC_REALIGN3 returns the handle to a new KJM_SEEG_ACPC_REALIGN3 or the handle to
%      the existing singleton*.
%
%      KJM_SEEG_ACPC_REALIGN3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KJM_SEEG_ACPC_REALIGN3.M with the given input arguments.
%
%      KJM_SEEG_ACPC_REALIGN3('Property','Value',...) creates a new KJM_SEEG_ACPC_REALIGN3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kjm_SEEG_acpc_realign3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kjm_SEEG_acpc_realign3_OpeningFcn via varargin.
% 
% Part of the "Hippotaxy" tool.
%     This is a program for loading brain imaging data, and placing it into
%     Hippocampal stereotactic space, as described by the manuscript:
%     "Hippocampal stereotaxy: A novel mesial temporal stereotactic
%     coordinate system", by Kai Miller and colleagues, and is currently in
%     submission. Please cite this manuscript in any setting (manuscripts,
%     talks) where this program was used. MATLAB's GUIDE tool was used to
%     create this GUI.
%     
%     Copyright (C) 2015, Kai J Miller, Stanford Neurosurgery
%     kai.miller@stanford.edu, kjmiller@gmail.com
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

% Last Modified by GUIDE v2.5 14-Aug-2020 22:45:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kjm_SEEG_acpc_realign3_OpeningFcn, ...
                   'gui_OutputFcn',  @kjm_SEEG_acpc_realign3_OutputFcn, ...
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


% --- Executes just before kjm_SEEG_acpc_realign3 is made visible.
function kjm_SEEG_acpc_realign3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kjm_SEEG_acpc_realign3 (see VARARGIN)

% Choose default command line output for kjm_SEEG_acpc_realign3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kjm_SEEG_acpc_realign3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kjm_SEEG_acpc_realign3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PUT ALL OF CREATEFCN STUFF HERE %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function SagSlider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function CorSlider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function AxSlider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function SaveName_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function AdHocLabel_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    
    
function AxSliceEditBox_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    

function SagSliceEditBox_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    

function CorSliceEditBox_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end   
    
function CLimLow_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CLimHigh_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
function ZoomFactor_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end    

function ZoomSlider_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% EDITABLE CONTENT STARTS HERE %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DATA INPUT AND OUTPUT

function ImportMRI_Callback(hObject, eventdata, handles) % --- Executes on button press in ImportMRI.
    % start over
    clear handles.data;

    %% use spm_select to get MRI
    [tmp]=spm_select(1,'image','select structural mri to import');
    handles.data.brain_info=spm_vol(tmp); [brain_vol]=spm_read_vols(handles.data.brain_info);
    
    % save some original parameters
    handles.data.O_info.mat=handles.data.brain_info.mat;
    handles.data.O_info.dim=handles.data.brain_info.dim;
    
    handles.mat0=handles.data.brain_info.mat;
    
    [handles.data.brain_info.mat,brain_vol]=matfix(handles.mat0,brain_vol);
    
    % scale MR intensity 0-1
    %brain_vol=brain_vol/(max(reshape(brain_vol,1,[])));
    brain_vol=brain_vol/prctile(brain_vol(:), 99);
    handles.clims=[0 1];
    
    % threshold and clip sides of brain image based on hard threshold
    %brain_vol(brain_vol<.05)=0;

    % assign brain image
    handles.data.brain_vol=brain_vol;
    
    
    
    %%
    % set starting and max cross-sections
    handles.currentXYZ=round(size(handles.data.brain_vol)/2);
    handles.MaxXYZ=size(handles.data.brain_vol);
    
    % set ridealong
    handles.data.ridealong=[];
    
    % set ad-hoc pts
    handles.data.adhoc=[];
    
    %%
    guidata(hObject,handles);imageInitiate(hObject, eventdata, handles)


function ImportRideAlong_Callback(hObject, eventdata, handles) % --- Executes on button press in ImportRideAlong.
    % here take "ride-along" image (CT with electrodes or MR with burn), and rotate/translate into MRI and reslice
    
    %% use spm_select to get MRI
    [tmp]=spm_select(1,'image','select ride along image, must be same as original');
    tmp2=spm_vol(tmp); [ridealong_vol]=spm_read_vols(tmp2);
    
    [tmp,ridealong_vol]=matfix(handles.mat0,ridealong_vol);
    
    % NOTE - THIS IS WHERE HAVE TO FIX OFFSET OF ONE VS ANOTHER FOR RIDEALONGS and positions...
    
    ridealong_vol=ridealong_vol(handles.bx,handles.by,handles.bz);
    
%     a=tmp2.fname; b=find(a=='/');a(1:b(end))=[];
    
    %% assign ride along image -- CONTINUE HERE!!!
    k=length(handles.data.ridealong)+1;

    handles.data.ridealong(k).vol=ridealong_vol;
    handles.data.ridealong(k).name=tmp2.fname;

    guidata(hObject,handles);imageInitiate(hObject, eventdata, handles)
    

function SaveMRI_Callback(hObject, eventdata, handles) % --- Executes on button press in SaveMRI.
    data=handles.data; 
    uisave({'data'})
    
function LoadMRIMarks_Callback(hObject, eventdata, handles) % --- Executes on button press in LoadMRIMarks.
    uiopen('.mat')
    handles.data=data;
    handles.currentXYZ=round(size(handles.data.brain_vol)/2);
    handles.MaxXYZ=size(handles.data.brain_vol);
    handles.clims=[0 1];
    guidata(hObject,handles);imageInitiate(hObject, eventdata, handles)

    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Export Shank (Hippotaxy repurpose) reslice    
function LaunchHippotaxy_Callback(hObject, eventdata, handles) % --- Executes on button press in LaunchHippotaxy.

acpc_reslice(handles.data);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Navigating MRIs

    % Sliders
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    % Edit Boxes - to display number of current mr slice and jump to others
    % Hints: get(hObject,'String') returns contents of CorSliceEditBox as text
    %        str2double(get(hObject,'String')) returns contents of CorSliceEditBox as a double


function SagSlider_Callback(hObject, eventdata, handles) % --- Executes on slider movement.
    handles.currentXYZ(1)=round(get(hObject,'Value'));
    imageUpdate(hObject, eventdata, handles);
    
function CorSlider_Callback(hObject, eventdata, handles) % --- Executes on slider movement.
    handles.currentXYZ(2)=round(get(hObject,'Value'));
    imageUpdate(hObject, eventdata, handles);

function AxSlider_Callback(hObject, eventdata, handles) % --- Executes on slider movement.
    handles.currentXYZ(3)=round(get(hObject,'Value'));
    imageUpdate(hObject, eventdata, handles);
    
% Edit boxes to jump to designated spot
function SagSliceEditBox_Callback(hObject, eventdata, handles)
    tmp=round(str2double(get(hObject,'String')));
    if and(tmp>0,tmp<=handles.MaxXYZ(1)), handles.currentXYZ(1)=tmp; end
    imageUpdate(hObject, eventdata, handles);
    
function CorSliceEditBox_Callback(hObject, eventdata, handles)
    tmp=round(str2double(get(hObject,'String')));
    if and(tmp>0,tmp<=handles.MaxXYZ(2)), handles.currentXYZ(2)=tmp; end
    imageUpdate(hObject, eventdata, handles);
    
function AxSliceEditBox_Callback(hObject, eventdata, handles)
    tmp=round(str2double(get(hObject,'String')));
    if and(tmp>0,tmp<=handles.MaxXYZ(3)), handles.currentXYZ(3)=tmp; end
    imageUpdate(hObject, eventdata, handles);

% --- Executes on mouse press over axes background.
function AxAxes_ButtonDownFcn(hObject, eventdata, handles)
    a=get(hObject); pt=round(a.Parent.CurrentPoint(1,1:2));
    handles.currentXYZ(1)=pt(1); handles.currentXYZ(2)=pt(2);
    imageUpdate(hObject, eventdata, handles);

function CorAxes_ButtonDownFcn(hObject, eventdata, handles)
    a=get(hObject); pt=round(a.Parent.CurrentPoint(1,1:2));
    handles.currentXYZ(1)=pt(1); handles.currentXYZ(3)=pt(2);
    imageUpdate(hObject, eventdata, handles);   

function SagAxes_ButtonDownFcn(hObject, eventdata, handles)
    a=get(hObject); pt=round(a.Parent.CurrentPoint(1,1:2));
    handles.currentXYZ(2)=pt(1); handles.currentXYZ(3)=pt(2);
    imageUpdate(hObject, eventdata, handles);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% saving points in landmarks and ad hoc

% Landmarks
function Lmark1_Callback(hObject, eventdata, handles) % --- Executes on button press in Lmark1.
    set(handles.Lmark1,'String',['LandMark 1 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(1,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToLMark1_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.LMark(1,:); imageUpdate(hObject, eventdata, handles);
        
function Lmark2_Callback(hObject, eventdata, handles) % --- Executes on button press in Lmark2.
    set(handles.Lmark2,'String',['LandMark 2 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(2,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);    
function GoToLMark2_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.LMark(2,:);  imageUpdate(hObject, eventdata, handles);    
    
function Lmark3_Callback(hObject, eventdata, handles) % --- Executes on button press in Lmark3.
    set(handles.Lmark3,'String',['LandMark 3 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(3,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles); 
function GoToLMark3_Callback(hObject, eventdata, handles)    
    handles.currentXYZ=handles.data.LMark(3,:);  imageUpdate(hObject, eventdata, handles);        
    
function Lmark4_Callback(hObject, eventdata, handles) % --- Executes on button press in Lmark4.
    set(handles.Lmark4,'String',['LandMark 4 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(4,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles); 
function GoToLMark4_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.LMark(4,:);  imageUpdate(hObject, eventdata, handles); 
    
function Shank1_Callback(hObject, eventdata, handles)
    set(handles.Lmark5,'String',['LandMark 5 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(5,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToShank1_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.LMark(5,:);  imageUpdate(hObject, eventdata, handles); 

function Shank2_Callback(hObject, eventdata, handles)
    set(handles.Lmark6,'String',['LandMark 6 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.LMark(6,:)=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);

function GoToShank2_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.LMark(6,:);  imageUpdate(hObject, eventdata, handles);   
    
% ad hoc point saving, with label to be determined
function AdHocPoint_Callback(hObject, eventdata, handles) % --- Executes on button press in AdHocPoint.
    if isfield(handles, 'tmpadhocname'),
        % save stuff here.
            k=length(handles.data.adhoc)+1;
            handles.data.adhoc(k).pt=handles.currentXYZ;
            handles.data.adhoc(k).name=handles.tmpadhocname;
    else handles.Warning='Need to define name of ad hoc save point first'; end
    imageUpdate(hObject, eventdata, handles);

function AdHocLabel_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of AdHocLabel as text
    handles.tmpadhocname=get(hObject,'String');
    guidata(hObject,handles);
    
% AC / PC / midline
function SetAC_Callback(hObject, eventdata, handles) % --- Executes on button press in SetAC.
    set(handles.SetAC,'String',['AC - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.AC=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToAC_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.AC; imageUpdate(hObject, eventdata, handles);

function SetPC_Callback(hObject, eventdata, handles) % --- Executes on button press in SetPC.
    set(handles.SetPC,'String',['PC - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.PC=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToPC_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.PC; imageUpdate(hObject, eventdata, handles);
    
function SetML1_Callback(hObject, eventdata, handles) % --- Executes on button press in SetML1.
    set(handles.SetML1,'String',['Midline 1 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.ML1=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToML1_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.ML1; imageUpdate(hObject, eventdata, handles);

function SetML2_Callback(hObject, eventdata, handles) % --- Executes on button press in SetML2.
    set(handles.SetML2,'String',['Midline 2 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.ML2=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToML2_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.ML2; imageUpdate(hObject, eventdata, handles);
    
function SetML3_Callback(hObject, eventdata, handles) % --- Executes on button press in SetML3.
    set(handles.SetML3,'String',['Midline 3 - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.ML3=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToML3_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.ML3; imageUpdate(hObject, eventdata, handles);


% Uncal Recess     
function SetUncRec_Callback(hObject, eventdata, handles) % --- Executes on button press in SetUncRec.
    set(handles.SetUncRec,'String',['Uncal Recess - ' int2str(handles.currentXYZ(1)) ' ' int2str(handles.currentXYZ(2)) ' ' int2str(handles.currentXYZ(3))]);
    handles.data.UncRec=handles.currentXYZ; 
    imageUpdate(hObject, eventdata, handles);
function GoToUncRec_Callback(hObject, eventdata, handles)
    handles.currentXYZ=handles.data.UncRec; imageUpdate(hObject, eventdata, handles);

%% Changing intensity range, zooming, etc

% MRI intensity range
function CLimLow_Callback(hObject, eventdata, handles)
    tmp=str2double(get(hObject,'String'));
    if and(tmp>=0,tmp<handles.clims(2)), handles.clims(1)=tmp; end
    imageUpdate(hObject, eventdata, handles);
    
function CLimHigh_Callback(hObject, eventdata, handles)
    tmp=str2double(get(hObject,'String'));
    if and(tmp<=1,tmp>handles.clims(1)), handles.clims(2)=tmp; end
    imageUpdate(hObject, eventdata, handles);

% scaling zoom factor
function ZoomFactor_Callback(hObject, eventdata, handles)
    tmp=str2double(get(hObject,'String'));
    if and(tmp>=1,tmp<6), handles.zoom=tmp; 
    else handles.Warning='Zoom Between 1-6 Only'; end
    imageUpdate(hObject, eventdata, handles);

function ZoomSlider_Callback(hObject, eventdata, handles)
    handles.zoom=get(hObject,'Value');
    imageUpdate(hObject, eventdata, handles);        
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMAGE STUFF HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function imageUpdate(hObject, eventdata, handles)
% this function fully updates the image 
    
    guidata(hObject,handles);
    
    % update edit boxes
    set(handles.SagSliceEditBox,'String',int2str(handles.currentXYZ(1)));
    set(handles.CorSliceEditBox,'String',int2str(handles.currentXYZ(2)));
    set(handles.AxSliceEditBox, 'String',int2str(handles.currentXYZ(3)));
    
    % update warning text
    set(handles.WarningText,'String',handles.Warning); 
    handles.Warning='No Warning';
 
    guidata(hObject,handles);

    % update sliders
    set(handles.SagSlider,'Value',handles.currentXYZ(1));
    set(handles.CorSlider,'Value',handles.currentXYZ(2));
    set(handles.AxSlider, 'Value',handles.currentXYZ(3));
    set(handles.ZoomSlider,'Value',handles.zoom);

    % update MRI intensity ranges
    set(handles.CLimLow,'String',num2str(handles.clims(1)));
    set(handles.CLimHigh,'String',num2str(handles.clims(2)));
    
    % update Zoom
    set(handles.ZoomFactor,'String',num2str(handles.zoom));
    
    %% determine axes for zooming
    zoomWinSize=floor(handles.MaxXYZ/handles.zoom);
    
    xtmp=handles.currentXYZ(1)+floor([-1 1]*zoomWinSize(1)/2);
    if xtmp(1)<1, xrange=[1 zoomWinSize(1)]; 
    elseif xtmp(2)>handles.MaxXYZ(1), xrange=[-zoomWinSize(1)+1 0]+handles.MaxXYZ(1); 
    else xrange=xtmp; end, clear xtmp
    
    ytmp=handles.currentXYZ(2)+floor([-1 1]*zoomWinSize(2)/2);
    if ytmp(1)<1, yrange=[1 zoomWinSize(2)]; 
    elseif ytmp(2)>handles.MaxXYZ(2), yrange=[-zoomWinSize(2)+1 0]+handles.MaxXYZ(2); 
    else yrange=ytmp; end, clear ytmp

    ztmp=handles.currentXYZ(3)+floor([-1 1]*zoomWinSize(3)/2);
    if ztmp(1)<1, zrange=[1 zoomWinSize(3)]; 
    elseif ztmp(2)>handles.MaxXYZ(3), zrange=[-zoomWinSize(3)+1 0]+handles.MaxXYZ(3); 
    else zrange=ztmp; end, clear ztmp    
    
    %% update cross-sectional images
    
%             % Voxel aspect anisotropy - note, this approach has been deferred, as all images should be isotropic 1,1,1mm prior 
%             yVox=sum(handles.PreOpSag.Struct.mat(1:3,2).^2).^.5;
%             zVox=sum(handles.PreOpSag.Struct.mat(1:3,3).^2).^.5;
%         % plot desired slice 
%             cla(handles.PreOpSagAxes)
%             imagesc(squeeze(handles.PreOpSag.Data(handles.PreOpSag.slice,:,:)).','Parent',handles.PreOpSagAxes); %annoying, but have to transpose
%             colormap('gray'),
            
    % x - sag
    axes(handles.SagAxes)
    tmp=imagesc(squeeze(handles.data.brain_vol(handles.currentXYZ(1),:,:)).',handles.clims);
    hold on, plot(handles.currentXYZ(2),handles.currentXYZ(3),'r.')
    axis equal, axis off,colormap(gray), set(gca,'YDir','normal')
    set(gca,'xlim',yrange,'ylim',zrange) %zoom
%     set(gca,'xlim',sort(handles.MaxXYZ(2)-yrange),'ylim',sort(handles.MaxXYZ(3)-zrange)) %zoom    
    set(tmp,'ButtonDownFcn', {@SagAxes_ButtonDownFcn,handles},'HitTest', 'on');

    % y - cor
    axes(handles.CorAxes),
    tmp=imagesc(squeeze(handles.data.brain_vol(:,handles.currentXYZ(2),:)).',handles.clims);
    hold on, plot(handles.currentXYZ(1),handles.currentXYZ(3),'r.')
    axis equal, axis off,colormap(gray), set(gca,'YDir','normal')
    set(gca,'xlim',xrange,'ylim',zrange) %zoom
    set(tmp,'ButtonDownFcn', {@CorAxes_ButtonDownFcn, handles},'HitTest', 'on');
    
    % z - ax
    axes(handles.AxAxes)
    tmp=imagesc(squeeze(handles.data.brain_vol(:,:,handles.currentXYZ(3))).',handles.clims);
    hold on, plot(handles.currentXYZ(1),handles.currentXYZ(2),'r.')
    axis equal, axis off,colormap(gray), set(gca,'YDir','normal')
    set(gca,'xlim',xrange,'ylim',yrange) %zoom
    set(tmp,'ButtonDownFcn', {@AxAxes_ButtonDownFcn, handles},'HitTest', 'on');
       
    
hold off


function imageInitiate(hObject, eventdata, handles)

    guidata(hObject,handles);
    
    % initiate sliders - images
    set(handles.SagSlider,'Min',1,'Max',handles.MaxXYZ(1),'Value',handles.currentXYZ(1),'SliderStep',[1 1]/handles.MaxXYZ(1));
    set(handles.CorSlider,'Min',1,'Max',handles.MaxXYZ(2),'Value',handles.currentXYZ(2),'SliderStep',[1 1]/handles.MaxXYZ(2));
    set(handles.AxSlider, 'Min',1,'Max',handles.MaxXYZ(3),'Value',handles.currentXYZ(3),'SliderStep',[1 1]/handles.MaxXYZ(3));
    
    % initiate slider - Zoom
    set(handles.ZoomSlider, 'Min',1,'Max',6,'Value',1,'SliderStep',[.1 .1]);

    % initiate total slice numbers
    set(handles.SagSliceTotal,'String',['/' num2str(handles.MaxXYZ(1)) ' Sagittal'])
    set(handles.CorSliceTotal,'String',['/' num2str(handles.MaxXYZ(2)) ' Coronal'])
    set(handles.AxSliceTotal,'String',['/' num2str(handles.MaxXYZ(3)) ' Axial'])
    
    % set zoom factor to 1
    handles.zoom=1;
    
    % Warning flag stuff
    handles.Warning='No Warning';
    
    
    imageUpdate(hObject, eventdata, handles);
