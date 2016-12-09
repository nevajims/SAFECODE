% power_norm_show
% Show the power mormalisation
% For a chosen node and a particular mode-   give the amplitude against frequency for various tensions
% Use my old program to get the nodes of interest
% Node at the top of the rail : 143 -   look at the up and dow (y movement here)   for up and down mode(  )
% Node on the side of the head  258  and   32   look at x and y movement here for lateral mode (1)
% Nodes in the middle of the web 185 and 106   look at x and y movement here for lateral mode (1) 
% Look at the data to work out 
% Plot the x y and z  against strain
abs_or_not = 1 ;

selected_mode  =  10;
%selected_node  =  258;  % side of head
freq_points    =  10;

selected_node  =  138 ; % middle of web
%selected_node  =  143 ; % top of rail   
all_strain_per  = reshaped_proc_data(1).data.all_strain_per;
leg_text = '';
cc=hsv(size(all_strain_per  ,2));

if abs_or_not ==1
    
fig_1  = figure;
hold on
suptitle(['ACTUAL VALUES(ABS)   Mode number = ',num2str(selected_mode),' ,Node number = ',num2str(selected_node)])

sub_plot_1 = subplot(3,1,1);    
title('X Direction')
hold on

sub_plot_2 = subplot(3,1,2);    
title('Y Direction')
hold on

sub_plot_3 = subplot(3,1,3);
title('Z Direction')
hold on


fig_2  = figure;
hold on
suptitle(['SENSITIVITY   Mode number = ',num2str(selected_mode),' ,Node number = ',num2str(selected_node)])

sub_plot_4 = subplot(3,1,1);    
title('X Direction')
hold on

sub_plot_5 = subplot(3,1,2);    
title('Y Direction')
hold on

sub_plot_6 = subplot(3,1,3);
title('Z Direction')
hold on
else
fig_1  = figure;
hold on
suptitle(['ACTUAL VALUES(no ABS)   Mode number = ',num2str(selected_mode),' ,Node number = ',num2str(selected_node)])

sub_plot_1 = subplot(3,1,1);    
title('X Direction')
hold on

sub_plot_2 = subplot(3,1,2);    
title('Y Direction')
hold on

sub_plot_3 = subplot(3,1,3);
title('Z Direction')
hold on  
    
end




for index = 1:length (all_strain_per)
    
    
    if abs_or_not ==1
    
    
    figure(fig_1)
subplot(sub_plot_1)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(index).data.ms_x(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 
%plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , reshaped_proc_data(index).data.ms_x(selected_node,1:freq_points,selected_mode),'-x','color',cc(index,:)) 
subplot(sub_plot_2)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(index).data.ms_y(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 
subplot(sub_plot_3)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(index).data.ms_z(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 


figure(fig_2)
subplot(sub_plot_4)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(1).data.ms_x(selected_node,1:freq_points,selected_mode))./abs(reshaped_proc_data(index).data.ms_x(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 

subplot(sub_plot_5)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(1).data.ms_y(selected_node,1:freq_points,selected_mode))./abs(reshaped_proc_data(index).data.ms_y(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 

subplot(sub_plot_6)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , abs(reshaped_proc_data(1).data.ms_z(selected_node,1:freq_points,selected_mode))./abs(reshaped_proc_data(index).data.ms_z(selected_node,1:freq_points,selected_mode)),'-x','color',cc(index,:)) 

    else
subplot(sub_plot_1)

plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , reshaped_proc_data(index).data.ms_x(selected_node,1:freq_points,selected_mode),'-x','color',cc(index,:)) 
subplot(sub_plot_2)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , reshaped_proc_data(index).data.ms_y(selected_node,1:freq_points,selected_mode),'-x','color',cc(index,:)) 
subplot(sub_plot_3)
plot(reshaped_proc_data(1).data.freq(1:freq_points,selected_mode) , reshaped_proc_data(index).data.ms_z(selected_node,1:freq_points,selected_mode),'-x','color',cc(index,:)) 
      
        
    end

if index == size(all_strain_per  ,2)
comma_insert = '';
else
comma_insert = ',';
end
leg_text            = [leg_text,'''','Strain = ',num2str(all_strain_per(index)),'''', comma_insert]; 

end %for index = 1:length (all_strain_per)


disp(['legend(',leg_text,')'])


if abs_or_not ==1
figure(fig_1)
eval(['legend(',leg_text,')'])

figure(fig_2)
eval(['legend(',leg_text,')'])
else
figure(fig_1)
eval(['legend(',leg_text,')'])
end



