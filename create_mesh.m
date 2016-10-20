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


% have a file called   mesh_default_settings_X .mat    where X is a number
if (nargin == 0) ; 
default_settings_file_name = ['default_settings_file_0.mat'];
else
default_settings_file_name = ['default_settings_file_',num2str(default_settings_file_number),'.mat'];
end %if (nargin == 0) ; 

if   exist(default_settings_file_name) ==2
load(default_settings_file_name) 
else     
mesh_input_settings.shape_choices                = {'circular','arbitary'}          ;
mesh_input_settings.shape_type                   = 1                                ;    % can be either   {'circular','arbitary'}
%mesh_input_settings.visible_handles              = {'on','on','on','on','on','on'}  ;
mesh_input_settings.visible_handles              = {'on','on','off','off','off','off'}  ;

mesh_input_settings.inner_dia                    = 0                                ;    % 
mesh_input_settings.thickness                    = 0.5e-3                           ;    % 5 mm solid rod is original default 
mesh_input_settings.external_points_file_name    = NaN                              ;    % if file dosen't  exist then make void
mesh_input_settings.raw_data_                    = NaN                              ;
mesh_input_settings.height                       = NaN                              ;
mesh_input_settings.width                        = NaN                              ; 
mesh_input_settings.no_points                    = 40                               ;    % number of equispaced points round the outside
mesh_input_settings.nom_el_size                  = mesh_input_settings.thickness/8  ;
end %if   exist('default_settings_file_name') ==2    

fig_handle = figure('units','normalized','outerposition',[0.05 0.05 0.5 0.9],'DeleteFcn',@DeleteFcn_callback ,'UserData',struct('mesh_input_settings',mesh_input_settings));

shape_choice_popup_txt = uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.95 0.2 0.03],'String','Select Shape Choice','HorizontalAlignment', 'left',  'visible', 'on');
shape_choice_popup_handle =  uicontrol('Style', 'popup','units','normalized','String', {'circular','arbitary'} ,'Position'  , [0.25 0.95 0.2 0.03] ,'Value',mesh_input_settings.shape_type,'HorizontalAlignment', 'left', 'Callback' , @shape_choice_input);

number_points_text =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.9 0.2 0.03],'String','Number of Points','HorizontalAlignment', 'left',  'visible', mesh_input_settings.visible_handles{1});
number_points_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.9 0.05 0.03],'String',num2str(mesh_input_settings.no_points),'HorizontalAlignment', 'right',  'visible', mesh_input_settings.visible_handles{2});

Inner_Diameter_text =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.85 0.2 0.03],'String','Inner Diameter (mm)','HorizontalAlignment', 'left',  'visible', mesh_input_settings.visible_handles{3});
Inner_Diameter_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.85 0.05 0.03],'String',num2str(mesh_input_settings.inner_dia*1000),'HorizontalAlignment', 'right',  'visible', mesh_input_settings.visible_handles{4});

Thickness_text      =  uicontrol('Style','text','units','normalized','FontSize',12,'BackgroundColor',[0.8,0.8,0.8], 'Position',[0.01 0.8 0.2 0.03],'String','Thickness (mm)','HorizontalAlignment', 'left',  'visible', mesh_input_settings.visible_handles{5});
Thickness_edit_text_handle = uicontrol('Style','edit','units','normalized','BackgroundColor',[0.85,0.85,0.85], 'Position',[0.25 0.8 0.05 0.03],'String',num2str(mesh_input_settings.thickness*1000),'HorizontalAlignment', 'right',  'visible', mesh_input_settings.visible_handles{6});





% inner_dia 
% thickness 
% Input box for the 
%
%
%


button_handles.shape_choice_popup_handle  =  shape_choice_popup_handle ;
fig_setup(fig_handle , button_handles );                           

end %function [] =   create_mesh(initial_settings_data)

function DeleteFcn_callback(object_handle,~)
plot_data_structure = get(object_handle,'UserData');

end  % function Deletes any animation timer object that may exist at the time of closing the figure


function fig_setup(fig_handle,button_handles)

% this is an 'autocallback'
plot_data_structure                         = get(fig_handle,'UserData')   ;
plot_data_structure.fig_handle              = fig_handle                   ;
plot_data_structure.button_handles          = button_handles               ;

% Put the button handles in here
% some will not be visible

plot_data_structure.outside_points_axis     = subplot(2,2,2)             ;
axis equal
plot_data_structure.mesh_axis               = subplot(2,2,4)             ;
axis equal

set(plot_data_structure.outside_points_axis,'UserData',1)                ;
set(plot_data_structure.mesh_axis          ,'UserData',2)                ;    


% if isstruct(plot_data_structure.reshaped_proc_data)
% plot_data_structure              =     plot_external_points(plot_data_structure);
% plot_data_structure              =     plot_mesh(plot_data_structure);
% end %if isstruct(plot_data_structure.reshaped_proc_data)

set(fig_handle,'UserData',plot_data_structure)                                                                     ;
end  % set the figure up with axis and plot data if it exists




%%%% CallBack Functions

function shape_choice_input(hObject, ~)
plot_data_structure  =  get(get(hObject,'Parent'),'UserData');
% this should just display one of the two options for display of inputs
plot_data_structure.mesh_input_settings.shape_type  =  get(hObject,'Value');
set(get(hObject,'Parent'),'UserData',plot_data_structure);
end % function shape_choice_input(hObject, ~)



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









