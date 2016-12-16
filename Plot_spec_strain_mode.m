function [] =  Plot_spec_strain_mode(reshaped_proc_data)
% Plot the first two modes- fist mode should be horizontal lateral and second should be vertical latera;
% plot the wave number and the phase velocity for the first two modes


% select the modes to look at
xlim_max = 200;
modes_to_plot = [1 2 3 4];   % make this an input to the function
number_freq_points = 100;
% length(modes_to_plot)
% modes_to_plot(1)
% modes_to_plot(2)

all_strain_per = reshaped_proc_data(1).data.all_strain_per;
 
leg_text = '';
cc=hsv(size(all_strain_per  ,2));


fig_title = { 'Phase Velocity','Phase Velocity Sensitivity','Wavenumber' ,'Wavenumber Sensitivity' };
y_label =   { 'Ph Vel','Sence (%)','WN' ,'Sence (%)' };
for fig_index = 1:4
fig_(fig_index)= figure;
suptitle (fig_title{fig_index})
for sub_index = 1:length(modes_to_plot)
sub_(fig_index,sub_index)  = subplot(length(modes_to_plot),1,sub_index);   
hold on
title(['Mode', num2str(modes_to_plot(sub_index))])
xlabel('Freq')
ylabel(y_label{fig_index})
end %for sub_index = 1:length(modes_to_plot)
end %for fig_index = 1:4



freq_min =zeros(1,length(modes_to_plot));
for index_mode = 1:length(modes_to_plot)
freq_min(index_mode) = max(reshaped_proc_data(1).data.freq(:,modes_to_plot(index_mode))) ;
for index_strain = 2:length(all_strain_per)
       
if freq_min(index_mode) > max(reshaped_proc_data(index_strain).data.freq(:,modes_to_plot(index_mode)))
C = max(reshaped_proc_data(index_strain).data.freq(:,modes_to_plot(index_mode)));
end %if freq_min(index_mode)> max(reshaped_proc_data(index_strain).data.freq(:,modes_to_plot(index_mode)))          

end %for index_1 = 1:length(all_strain_per)  
end % for index_mode = 1:length(modes_to_plot)

%for each mode create a set of frequencies to inerpolate from
% number_freq_points 

% go through each mode and create the Freq, WN and PH_vel values for  each
% strain value -  these can then be used for all plots

for mode_index = 1:length(modes_to_plot)

freq_vals(mode_index,:) = [0:freq_min(mode_index)/(number_freq_points-1):freq_min(mode_index)];
    
for strain_index  = 1:length(all_strain_per)
% here  is the interpolation part

ph_vel_vals(mode_index,strain_index,:  ) = interp1(reshaped_proc_data(strain_index).data.freq(:,mode_index ),reshaped_proc_data(strain_index).data.ph_vel(:,mode_index ),freq_vals(mode_index,:));                                
WN_vals    (mode_index,strain_index,:  ) = interp1(reshaped_proc_data(strain_index).data.freq(:,mode_index ),reshaped_proc_data(strain_index).data.waveno(:,mode_index ),freq_vals(mode_index,:));
end %for strain_index  = 1:length(all_strain_per) 
end %for mode_index = 1:length(modes_to_plot)


for strain_index = 1:size(all_strain_per  ,2)
    
figure(fig_(1))
for mode_index = 1:length(modes_to_plot)
subplot(sub_(1,mode_index))
plot(freq_vals(mode_index,:),squeeze(ph_vel_vals(mode_index,strain_index,:  )),'-x','color',cc(strain_index,:))    

end % for mode_index = 1:length(modes_to_plot)

figure(fig_(2))
for mode_index = 1:length(modes_to_plot)
subplot(sub_(2,mode_index))
plot(freq_vals(mode_index,:), 100*  ( squeeze(ph_vel_vals(mode_index,strain_index,:)) - squeeze(ph_vel_vals(mode_index,1,:)))./ squeeze(ph_vel_vals(mode_index,1,:)),'-x','color',cc(strain_index,:))    
ylim([0 100])
end % for mode_index = 1:length(modes_to_plot)

figure(fig_(3))
for mode_index = 1:length(modes_to_plot)
subplot(sub_(3,mode_index))
plot(freq_vals(mode_index,:), squeeze(WN_vals(mode_index,strain_index,:  )),'-x','color',cc(strain_index,:))    

end % for mode_index = 1:length(modes_to_plot)

figure(fig_(4))
for mode_index = 1:length(modes_to_plot)
subplot(sub_(4,mode_index))
plot(freq_vals(mode_index,:), 100*  ( squeeze(WN_vals (mode_index,1,:))-squeeze(WN_vals (mode_index,strain_index,:) ))./ squeeze(WN_vals (mode_index,1,:)),'-x','color',cc(strain_index,:))    
 ylim([0 100])
end % for mode_index = 1:length(modes_to_plot)


if strain_index == size(all_strain_per  ,2)
comma_insert = '';
else
comma_insert = ',';
end
leg_text            = [leg_text,'''','Strain = ',num2str(all_strain_per(strain_index)),'''', comma_insert]; 

end


for fig_index = 1:4
figure(fig_(fig_index))    
eval(['legend(',leg_text,')'])   
 
for mode_index = 1:length(modes_to_plot)  
subplot(sub_(fig_index,mode_index))
xlim([0 xlim_max])
grid on
end %for mode_index = 1:length(modes_to_plot)


end %for fig_index = 1:4


end

