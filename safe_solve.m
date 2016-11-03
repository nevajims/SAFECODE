%  create a program that takes a mesh and solves 
%  find a mesh and conditions that solve reasonably quickly

do_plot = 1 ;

% --------------------------------------------------------------------------------
% Mesh file to load
% --------------------------------------------------------------------------------
cd('meshes')
load('MESH_ROD_D1_mm_1.mat')
cd('..')
element_details = get_element_details(mesh);

% --------------------------------------------------------------------------------
% Material Properties
% --------------------------------------------------------------------------------
matl_name      = 'aluminium';
youngs_modulus = 70e9;
poissons_ratio = 1/3;
density        = 2700;
% --------------------------------------------------------------------------------
% Solver parameters
% --------------------------------------------------------------------------------
indep_var               = 'waveno';
pts                     = 40      ;
max_freq                = 500     ;
safe_opts.use_sparse    = 1       ;
triangular_element_type = 2       ;

% Two options
%(1):
nom_el_size      =  mesh_input_settings.nom_el_size(mesh_input_settings.shape_type) ; %  size used to set the mesh

%(2):
%nom_el_size     =   element_details.mean_edge_length;
% --------------------------------------------------------------------------------
% Loading and boundary conditions
% --------------------------------------------------------------------------------
% Tension
% Foundation conditions
% --------------------------------------------------------------------------------
% Pre prosessing setup parameters
% --------------------------------------------------------------------------------
mesh.matl{1}.name              =   matl_name;
mesh.matl{1}.stiffness_matrix  =   fn_iso_stiffness_matrix(youngs_modulus, poissons_ratio);
mesh.matl{1}.density           =   density;
[long_vel, shear_vel]          =   fn_velocities_from_stiffness_and_density(youngs_modulus, poissons_ratio, density);
hdata.hmax                     =   nom_el_size;
mesh.el.matl                   =   ones(size(mesh.el.nds, 1), 1)                           ;
mesh.el.type                   =   ones(size(mesh.el.nds, 1), 1) * triangular_element_type ;
mesh.nd.dof                    =   ones(size(mesh.nd.pos, 1), 3)                           ;
% --------------------------------------------------------------------------------
% solver
% --------------------------------------------------------------------------------
switch indep_var
    case 'waveno'
        var = linspace(0, 2 * pi * max_freq / shear_vel, pts);
        unsorted_results = fn_SAFE_modal_solver(mesh, var, indep_var, safe_opts);
        
    case 'freq'
        var = linspace(0, max_freq, pts);
        unsorted_results = fn_SAFE_modal_solver(mesh, var, indep_var, safe_opts);
end;

%save unsorted_results unsorted_results
[data_wn] = create_fenel_format_data (unsorted_results);
[reshaped_proc_data,sorted_lookup,data_wn_matrix] =  proc_data_into_modes_safe(data_wn);
reshaped_proc_data.mesh = mesh ;

% --------------------------------------------------------------------------------
% plot
% --------------------------------------------------------------------------------

if do_plot ==1
figure;
subplot(2,1,1)
fv.Vertices = mesh.nd.pos;
fv.Faces = mesh.el.nds;
patch(fv, 'FaceColor', 'c');
axis equal;
axis off;

subplot(2,1,2)
plot(unsorted_results.freq , 2 * pi * unsorted_results.freq ./ unsorted_results.waveno , 'r.');
xlabel('Frequency')
ylabel('Vph')
axis([0, max_freq, 0, 2*long_vel]);

%axis([0, 50E3, 0, 10E3]);
end %if do_plot ==1




