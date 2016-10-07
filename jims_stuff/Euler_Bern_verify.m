%  Euler_Bern_verify.m
%  make this a function where you set the range of  Frequencies * Thickness  
%  Frequency thickness range in plot is 0.1 - 100  (Hz * m) 
%  -------------------------------------------------------------------------
%  Apply the euler_B equation for the first flexural mode of a circular
%  rod.
%  Variables:
%  -------------------------------------------------------------------------
%  -------------------------------------------------------------------------
%  -------------------------------------------------------------------------
%  define material(s)
%  matl_name = 'aluminium';
%  youngs_modulus = 70e9;
%  poissons_ratio = 1/3;
%  density = 2700;
%  -------------------------------------------------------------------------
%  Variable name  
%  rod_radius                                       (m)       
%  V_ph                    (Phase Velocity)         (m/s)
%  omega                   (Frequency -radians/sec) (s-1)
%  E_                      (Young's Modulus)        (N/m^2) = (kg m-1 s-2) 
%  density_                                         (kg / m3)    
%  I_                      (Second moment of area)  (m^4)
%  strain_abs              (abs strain)             (no units) 
%  strain_per              (strain_abs * 100)       (%)  
%  tension_                (tension_)               (N)     = (kg m s-2)
%  mass_per_unit_length                             (kg/m)
%  Equations
%  I =  (pi/4)*r^4           
% -------------------------------------------------------------------------
% V_ph = omega*(sqrt((2*E_*I_)/(sqrt(tension_^2 + 4 * mass_per_unit_length*E*I*omega^2)-tension_))); 
% -------------------------------------------------------------------------

function [] =   Euler_Bern_verify (FT_high , FT_low , rod_radius_m)
% matl_name = 'aluminium' ;
all_strain_per            = [0 0.1 0.2 0.3 0.4]                                     ;  % strain sets to solve for
shear_velocity            = 3100                                        ;  % m/s   
number_steps              = 100                                         ;  % number of steps in the frequency calculation  
FT_step                   = (FT_high-FT_low)/number_steps               ;  %

FT_ALL                    = [FT_low :FT_step: FT_high]                  ;  %
E_                        = 70e9                                        ;  % kg m-1 s-2    
poissons_ratio            = 1/3                                         ;  % 
density_                  = 2700                                        ;  % kg/m3
CSA                       = pi * rod_radius_m^2                         ;  % m^2
all_strain_abs            = all_strain_per/100                          ;  % no units

ALL_Frequencies           = FT_ALL / rod_radius_m                       ;   %
I_                        = (pi/4)  * rod_radius_m^4                    ;   %
all_stress                = all_strain_abs * E_                         ;   %
mass_per_unit_length      = density_   * CSA                            ;   % kg/m
all_tensions              = all_stress    * CSA                         ;   %

for tension_index = 1 : length(all_tensions)  
for freq_index   = 1:  length(ALL_Frequencies)
V_ph_all(tension_index,freq_index)  =    calc_V_ph(ALL_Frequencies(freq_index) , E_ , I_ , all_tensions(tension_index)  , mass_per_unit_length);    
end % for freq_index   = 1:  length(ALL_Frequencies)
end % for all_tensionsindex = 1 : length(all_tensions)  

% now plot all the cases out on a single plot 
%(X) is frequency thickness and (Y) is phase_velocity/shear_velocity
% y is 

figure (2)
hold on
leg_text            = '';

for tension_index   = 1 : length(all_tensions)  
    
%plot(log(FT_ALL), log(V_ph_all(tension_index,:)/shear_velocity));   
loglog(FT_ALL, V_ph_all(tension_index,:)/shear_velocity);   
%plot(FT_ALL, V_ph_all(tension_index,:)/shear_velocity);   

if tension_index   == length(all_tensions)  
comma_insert = ''  ;
else
comma_insert = ',' ;
end %if tension_index   == length(all_tensions)  
leg_text            = [leg_text,'''','Strain = ',num2str(all_strain_per(tension_index)),'''', comma_insert]; 
end
disp(leg_text)
eval(['legend(',leg_text,')'])
% create a legend for all the different strain cases
xlabel(['Frequency x Thickness '])
ylabel('Phase velocity / shear / velocity')
end %function [] =   Euler_Bern_verify(FT_high, FT_low , rod_radius)

function [V_ph] = calc_V_ph(omega_ , E_ , I_ , tension_ , mass_per_unit_length  )
V_ph = omega_*(sqrt((2*E_*I_)/(sqrt(tension_^2 + 4 * mass_per_unit_length*E_*I_*omega_^2)-tension_))) ; 
end  % function [V_ph] = calc_V_ph()













