% use plot_data_structure 
% **** The ize of the plot axis nees to always be the same  but the scaling can
% ****  change
% this is purely to crearte the mesh
% needs a figure for the equispaced external points and a figure for the
% mesh itself
% ----------------------------
% the required data
% ----------------------------
% for an circular cross sections
% inner_dia 
% thickness 
% no_points  -  common
% ----------------------------
% for the arbitary shape  
% ----------------------------
% external_points_file_name
% raw_data_
% height 
% width 
% no_points  -  common
% ------------------------------------------
% processed data as input to mesh generation 
% ------------------------------------------
% nodes_
% edge_  -  only  necesary if there are voids in the cross section
% data.hmax                      =     nom_el_size     ;
% ops.output                     =     false           ;
% ------------------------------------------
% [equispaced_points_mm, nom_el_size_mm]     =  get_outside_edge( data , 158.75 , 139.7 , 50 , 1); 
% nom_el_size                                =  0.5*nom_el_size_mm * 1E-3;
% nd_                                        =  [real(equispaced_points_mm )'*1E-3,imag(equispaced_points_mm )'*1E-3];
% for external voids syntax is as follows::
% [mesh.nd.pos, mesh.el.nds, mesh.el.fcs] = mesh2d(nodes_, edge_,hdata, ops);
% nom_el_size = rad/8;
% triangular_element_type = 2;
% --------------------------------------------------------------------------

% load('4-01-0A IM RAIL MODEL 56 E 1 (H 158_75 W 139_70).mat')
% load('5-01-0A IM RAIL MODEL 60 E 1 (H 172 W 150).mat')
% [equispaced_points_mm, nom_el_size_mm]     =  get_outside_edge( data , 172 , 150 , 100 , 1);
% [equispaced_points_mm, nom_el_size_mm]     =  get_outside_edge( data , 158.75 , 139.7 , 50 , 1); 

% nom_el_size = 0.5*nom_el_size_mm * 1E-3;
% nd_ = [real(equispaced_points_mm )'*1E-3,imag(equispaced_points_mm )'*1E-3];
%  Data for Circular Cross section
%  [nodes_,edge_]  =  create_arb_pipe(438.5 , 9.525 , 150);
%  inner_dia , thickness , no_points
%  Data for arbitary Cross section



function [] =   create_mesh(default_settings_file_number)
% check whether boundary data can be calculated - if so calculate it
mesh_input_settings  =  get_mesh_input_settings(nargin);
boundary_points      = calculate_boundary_points(mesh_input_settings);

fig_handle = figure('units','normalized','outerposition',[0.05 0.05 0.5 0.9],'DeleteFcn',@DeleteFcn_callback ,'UserData',struct('mesh_input_settings',mesh_input_settings,'boundary_points',boundary_points));
% plot_data_structure                         = calculate_boundary_points(plot_data_structure);
plot_data_structure                         = get(fig_handle,'UserData')           ;
plot_data_structure.fig_handle              = fig_handle                           ;
plot_data_structure                         = set_UIcontrols(plot_data_structure)  ;
plot_data_structure                         = fig_setup(plot_data_structure)       ;                           
set(fig_handle,'UserData',plot_data_structure)                                                                     ;
end %function [] =   create_mesh(initial_settings_data)


function DeleteFcn_callback(object_handle,~)
plot_data_structure = get(object_handle,'UserData');
end  % function Deletes any animation timer object that may exist at the time of closing the figure


function boundary_points    = calculate_boundary_points(mesh_input_settings);
%two posibilities
switch(mesh_input_settings.shape_type)
   
     case(1)

   if  ~isnan(mesh_input_settings.inner_dia) && ~isnan(mesh_input_settings.thickness) && ~isnan(mesh_input_settings.no_points)
[boundary_points.nodes_ , boundary_points.edge_] = create_arb_pipe(mesh_input_settings.inner_dia , mesh_input_settings.thickness , mesh_input_settings.no_points , 0 ) ;       
   else
boundary_points.nodes_ = NaN;
boundary_points.edge_  = NaN;
   end %   if  ~isnan(mesh_input_settings.inner_dia) && ~isnan(mesh_input_settings.thickness) && ~isnan(mesh_input_settings.no_points)         
  
     case(2)
disp('to be written')

end %switch(plot_data_structure.mesh_input_settings.shape_type)

end %function plot_data_structure                         = calculate_boundary_points(plot_data_structure);

function plot_data_structure =  set_UIcontrols(plot_data_structure) 
button_handles.shape_choice_popup_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.95 0.2 0.03],'String','Select Shape Choice','HorizontalAlignment', 'left',  'visible', 'on');
button_handles.shape_choice_popup_handle =  uicontrol('Style', 'popup','units','normalized','String', {'circular','arbitary'} ,'Position'  , [0.25 0.95 0.2 0.03] ,'Value',plot_data_structure.mesh_input_settings.shape_type,'HorizontalAlignment', 'left', 'Callback' , @shape_choice_input);
button_handles.number_points_text =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.9 0.2 0.03],'String','#Points (min 10)','HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{1});
button_handles.number_points_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.9 0.05 0.03],'String',num2str(plot_data_structure.mesh_input_settings.no_points),'HorizontalAlignment', 'right',  'visible', plot_data_structure.mesh_input_settings.visible_handles{2}, 'Callback' , @select_number_points);
button_handles.Inner_Diameter_text =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.85 0.2 0.03],'String','Inner Diameter (mm)','HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{3});
button_handles.Inner_Diameter_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.85 0.05 0.03],'String',num2str(plot_data_structure.mesh_input_settings.inner_dia*1000),'HorizontalAlignment', 'right',  'visible', plot_data_structure.mesh_input_settings.visible_handles{4}, 'Callback' , @set_Inner_Diameter);
button_handles.Thickness_text      =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.8 0.2 0.03],'String','Thickness (mm)','HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{5});
button_handles.Thickness_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.8 0.05 0.03],'String',num2str(plot_data_structure.mesh_input_settings.thickness*1000),'HorizontalAlignment', 'right',  'visible', plot_data_structure.mesh_input_settings.visible_handles{6}, 'Callback' , @set_Thickness);

button_handles.height_text              =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.85 0.2 0.03],'String','Height (mm)','HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{7});
button_handles.height_edit_text_handle  =  uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.85 0.05 0.03],'String',num2str(plot_data_structure.mesh_input_settings.height*1000),'HorizontalAlignment', 'right',  'visible', plot_data_structure.mesh_input_settings.visible_handles{8}, 'Callback' , @set_height);
button_handles.width_text      =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.8 0.2 0.03],'String','Width (mm)','HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{9});

button_handles.width_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.8 0.05 0.03],'String',num2str(plot_data_structure.mesh_input_settings.width*1000),'HorizontalAlignment', 'right',  'visible', plot_data_structure.mesh_input_settings.visible_handles{10}, 'Callback' , @set_width);


button_handles.select_profile_file_button_handle = uicontrol('Style','pushbutton','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.01,0.7 0.18 0.05],'String','Select File','HorizontalAlignment', 'left',  'visible', 'on', 'visible', plot_data_structure.mesh_input_settings.visible_handles{11},'Callback',@select_profile_file);     
button_handles.profile_file_text      =  uicontrol('Style','text','units','normalized','FontSize',8,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.21 0.7 0.32 0.02],'String',plot_data_structure.mesh_input_settings.external_points_file_name  ,'HorizontalAlignment', 'left',  'visible', plot_data_structure.mesh_input_settings.visible_handles{12});

button_handles.plot_button_handle = uicontrol('Style','togglebutton','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.01,0.6 0.18 0.05],'String','Plot boundary points','HorizontalAlignment', 'left',  'visible', 'on','Callback' , @plot_points);     


% create a button for plotting the outline-  should be greyd out unless certail criterial are met
plot_data_structure.button_handles = button_handles;
end %function plot_data_structure =  set_UIcontrols(plot_data_structure) 

function mesh_input_settings =  get_mesh_input_settings(value_)
if (value_ == 0) ; 
default_settings_file_name = ['default_settings_file_0.mat'];
else
default_settings_file_name = ['default_settings_file_',num2str(default_settings_file_number),'.mat'];
end %if (nargin == 0) ; 

if   exist(default_settings_file_name) ==2
load(default_settings_file_name) 
else     
mesh_input_settings.shape_choices                = {'circular','arbitary'}          ;
mesh_input_settings.shape_type                   = 1                                ;    % can be either   {'circular','arbitary'}
mesh_input_settings.visible_handles              = {'on','on','on','on','on','on','off','off','off','off','off','off'}  ;        
% mesh_input_settings.visible_handles            ={'on','on','off','off','off','off','on','on','on','on','on','on'}  ;    

mesh_input_settings.inner_dia                    = 0                                             ;    % 
mesh_input_settings.thickness                    = 0.5e-3                                        ;    % 5 mm solid rod is original default 
mesh_input_settings.external_points_file_name    = 'profile_RAIL_56 E 1 (H 158_75 W 139_70).mat' ;    % if file dosen't  exist then make void
mesh_input_settings.raw_data_                    = NaN                                           ;
mesh_input_settings.height                       = 158.75e-3                                     ;
mesh_input_settings.width                        = 139.7e-3                                      ; 
mesh_input_settings.no_points                    = 40                                            ;    % number of equispaced points round the outside
mesh_input_settings.nom_el_size                  = mesh_input_settings.thickness/8               ;
mesh_input_settings.display_boundary_points      = 0                                             ;

end %if   exist('default_settings_file_name') ==2    

end %function mesh_input_settings =  get_mesh_input_settings(value_);


function plot_data_structure = fig_setup(plot_data_structure )
%(fig_handle,button_handles)
% put in axis labels and figure titles here
plot_data_structure.outside_points_axis     = subplot(2,2,2)             ;
axis equal
plot_data_structure.mesh_axis               = subplot(2,2,4)             ;
axis equal
set(plot_data_structure.outside_points_axis,'UserData',1)                ;
set(plot_data_structure.mesh_axis          ,'UserData',2)                ;    
end  % set the figure up with axis and plot data if it exists


function set_visable_handles(plot_data_structure)
set(plot_data_structure.button_handles.number_points_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{1});
set(plot_data_structure.button_handles.number_points_edit_text_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{2}); 
set(plot_data_structure.button_handles.Inner_Diameter_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{3}); 
set(plot_data_structure.button_handles.Inner_Diameter_edit_text_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{4}); 
set(plot_data_structure.button_handles.Thickness_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{5});   
set(plot_data_structure.button_handles.Thickness_edit_text_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{6}); 


set(plot_data_structure.button_handles.height_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{7}); 
set(plot_data_structure.button_handles.height_edit_text_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{8}); 
set(plot_data_structure.button_handles.width_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{9});   
set(plot_data_structure.button_handles.width_edit_text_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{10}); 
set(plot_data_structure.button_handles.profile_file_text, 'visible', plot_data_structure.mesh_input_settings.visible_handles{11});   
set(plot_data_structure.button_handles.select_profile_file_button_handle, 'visible', plot_data_structure.mesh_input_settings.visible_handles{12}); 


end %function set_visable_handles(plot_data_structure)

%%%% CallBack Functions

function select_profile_file (hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
but_val = get(hObject,'Value');
disp(num2str(but_val));

cd('profiles')
files_ = dir('profile*.mat');
files_str = {files_.name};
[selection_,ok_] = listdlg('PromptString','Select a file:','SelectionMode','single', 'ListString',files_str);

if(ok_)
plot_data_structure.mesh_input_settings.external_points_file_name = files_str{selection_};
set(plot_data_structure.button_handles.profile_file_text, 'String',plot_data_structure.mesh_input_settings.external_points_file_name)
set_visable_handles(plot_data_structure);
end %if(ok_)
%[modes_to_plot,ok] = listdlg('PromptString','Select modes to display:','SelectionMode','single','ListString',arrayfun(@num2str,(1:size(plot_data_structure.reshaped_proc_data.freq,2)  ),'unif',0));
cd('..')

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end



function shape_choice_input(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
% this should just display one of the two options for display of inputs
plot_data_structure.mesh_input_settings.shape_type  =  get(hObject,'Value');

%disp(plot_data_structure.mesh_input_settings.shape_type)

switch(plot_data_structure.mesh_input_settings.shape_type )
    case(1)
plot_data_structure.mesh_input_settings.visible_handles              = {'on','on','on','on','on','on','off','off','off','off','off','off'}  ;        
    case(2)        
plot_data_structure.mesh_input_settings.visible_handles              = {'on','on','off','off','off','off','on','on','on','on','on','on'}  ;    
end %switch(plot_data_structure.mesh_input_settings.shape_type )

set_visable_handles(plot_data_structure);


set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function shape_choice_input(hObject, ~)


function select_number_points(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
num_val = str2num(get(hObject,'String'));

if isempty(num_val)
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.no_points));
else
rounded_num_val = floor(num_val);
if num_val > 10  
set(hObject,'String',num2str(rounded_num_val));
plot_data_structure.mesh_input_settings.no_points = rounded_num_val;
else    
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.no_points));    
end %if num_val > 10    
end %if isempty(num_val)

plot_data_structure.boundary_points    = calculate_boundary_points(plot_data_structure.mesh_input_settings);
if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)
cla
plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
axis equal
end %if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1


set(get(hObject,'Parent'),'UserData',plot_data_structure);

end %function select_number_points(hObject, ~)


function set_Inner_Diameter(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
num_val = str2num(get(hObject,'String'));
%plot_data_structure.mesh_input_settings.inner_dia*1000

if isempty(num_val)
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.inner_dia*1000));
else
if num_val >=  0
set(hObject,'String',num2str(num_val));
plot_data_structure.mesh_input_settings.inner_dia = num_val/1000;
else    
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.inner_dia*1000));    
end %if num_val >=  0
end %if isempty(num_val)

plot_data_structure.boundary_points    = calculate_boundary_points(plot_data_structure.mesh_input_settings);
if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)
cla
plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
axis equal
end %if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1

set(get(hObject,'Parent'),'UserData',plot_data_structure);
end


function set_Thickness(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
num_val = str2num(get(hObject,'String'));
if isempty(num_val)
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.thickness*1000));
else
if num_val >=  0.01
set(hObject,'String',num2str(num_val));
plot_data_structure.mesh_input_settings.thickness = num_val/1000;
else    
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.thickness*1000));    
end %if num_val >=  0
end %if isempty(num_val)
% now recalc boundary and clear figure if necessary

plot_data_structure.boundary_points    = calculate_boundary_points(plot_data_structure.mesh_input_settings);
if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)
cla
plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
axis equal
end %if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
set(get(hObject,'Parent'),'UserData',plot_data_structure);
end

function set_width(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
num_val = str2num(get(hObject,'String'));
if isempty(num_val)
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.width*1000));
else
if num_val >=  0.01
set(hObject,'String',num2str(num_val));
plot_data_structure.mesh_input_settings.width = num_val/1000;
else    
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.width*1000));    

end %if num_val >=  0
end %if isempty(num_val)
% now recalc boundary and clear figure if necessary


%plot_data_structure.boundary_points    = calculate_boundary_points(plot_data_structure.mesh_input_settings);
%if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
%set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)
%cla
%plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
%axis equal
%end %if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
%set(get(hObject,'Parent'),'UserData',plot_data_structure);
%end
end

function set_height(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
num_val = str2num(get(hObject,'String'));
if isempty(num_val)
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.height*1000));
else
if num_val >=  0.01
set(hObject,'String',num2str(num_val));
plot_data_structure.mesh_input_settings.height = num_val/1000;
else    
set(hObject,'String',num2str(plot_data_structure.mesh_input_settings.height*1000));    

end %if num_val >=  0
end %if isempty(num_val)
% now recalc boundary and clear figure if necessary


%plot_data_structure.boundary_points    = calculate_boundary_points(plot_data_structure.mesh_input_settings);
%if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
%set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)
%cla
%plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
%axis equal
%end %if  get(plot_data_structure.button_handles.plot_button_handle,'Value') ==1
%set(get(hObject,'Parent'),'UserData',plot_data_structure);
%end

end


function plot_points(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
but_val = get(hObject,'Value');
disp(num2str(but_val));
set(plot_data_structure.fig_handle,'CurrentAxes',plot_data_structure.outside_points_axis)

if but_val == 1
if ~isnan(plot_data_structure.boundary_points.nodes_)    
cla
plot(plot_data_structure.boundary_points.nodes_(:,1)*1000,plot_data_structure.boundary_points.nodes_(:,2)*1000,'.')
axis equal
else    
cla    
set(hObject,'Value',0);        

end %if ~isnan(boundary_points.nodes_)    
else
cla
end %if but_val == 1
set(get(hObject,'Parent'),'UserData',plot_data_structure);
end %function plot_points(hObject, ~)


%%%% Functions
function [nodes_,edge_] = create_arb_pipe(inner_dia , thickness , no_points , do_plot)
if inner_dia ~=0  
internal_rad = inner_dia/2           ;
external_rad = inner_dia/2+thickness ;
circumfence_ratio = external_rad/internal_rad;
divisor_ = circumfence_ratio + 1;
number_external_nodes =  floor(circumfence_ratio*no_points/divisor_)   +1  ;
number_internal_nodes =  ceil(no_points/divisor_) +1;
angle_external = linspace(0, 2 * pi, number_external_nodes);
angle_external  = angle_external(1:end - 1)';
angle_internal = linspace(0, 2 * pi, number_internal_nodes);
angle_internal  = angle_internal(1:end - 1)';
outer_nodes  = [cos(angle_external), sin(angle_external)] * external_rad;    
inner_nodes  = [cos(angle_internal), sin(angle_internal)] * internal_rad;    
nodes_ =  [ inner_nodes ; outer_nodes ];
n_inner_nodes = size(inner_nodes,1);
n_outer_nodes = size(outer_nodes,1);
c_inner_nodes = [(1:n_inner_nodes-1)', (2:n_inner_nodes)'; n_inner_nodes, 1];
c_outer_nodes = [(1:n_outer_nodes-1)', (2:n_outer_nodes)'; n_outer_nodes, 1];
edge_ = [c_inner_nodes ; c_outer_nodes + n_inner_nodes ] ;
else    
angle_ = linspace(0, 2 * pi, no_points+1);    
angle_  = angle_(1:end - 1)';
nodes_  = [cos(angle_), sin(angle_)] * thickness;     
n_nodes = size(nodes_,1);
c_nodes = [(1:n_nodes-1)', (2:n_nodes)'; n_nodes, 1] ;
edge_ = [c_nodes] ;
end %if inner_dia ~=0  

if do_plot ==1
plot(nodes_(:,1),nodes_(:,2),'.')
axis equal
end % if do_plot ==1
%size(nodes_)
end  % function [nodes_,edge_] = create_arb_pipe(inner_dia , thickness , no_points , do_plot)








