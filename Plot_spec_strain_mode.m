function [] =  Plot_spec_strain_mode(all_strain_per,reshaped_proc_data,specific_output_mode_number)

fig_1 = figure;
hold on
fig_2 = figure;
hold on

title(['Mode number = ',num2str(specific_output_mode_number)])
leg_text = '';

cc=hsv(size(all_strain_per  ,2));

for index = 1:size(all_strain_per  ,2)
 figure(fig_1)
plot(reshaped_proc_data(index).data.freq(:,specific_output_mode_number),reshaped_proc_data(index).data.ph_vel(:,specific_output_mode_number),'-x','color',cc(index,:))    
figure(fig_2)
plot(reshaped_proc_data(index).data.freq(:,specific_output_mode_number),reshaped_proc_data(index).data.ph_vel(:,specific_output_mode_number)./reshaped_proc_data(1).data.ph_vel(:,specific_output_mode_number),'-x','color',cc(index,:)) 

if index == size(all_strain_per  ,2)
comma_insert = '';
else
comma_insert = ',';
end
leg_text            = [leg_text,'''','Strain = ',num2str(all_strain_per(index)),'''', comma_insert]; 

end
figure(fig_1)
disp(['legend(',leg_text,')'])
eval(['legend(',leg_text,')'])
figure(fig_2)
eval(['legend(',leg_text,')'])
%axis([0, 20000, 0,500 ]);    
%axis([0, 2000, 0,1200 ]);
figure(fig_1)
axis([0, 200, 0,500 ]);
figure(fig_2)
axis([0, 200, 0,2.5 ]);

end