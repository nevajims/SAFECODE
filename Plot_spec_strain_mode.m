function [] =  Plot_spec_strain_mode(reshaped_proc_data)
% Plot the first two modes- fist mode should be horizontal lateral and second should be vertical latera;
% plot the wave number and the phase velocity for the first two modes


all_strain_per = reshaped_proc_data(1).data.all_strain_per;
%specific_output_mode_number 

fig_1 = figure;
suptitle ('Phase Velocity')
subplot_1 = subplot(2,1,1);
title('Mode 1')
subplot_2 = subplot(2,1,2);
title('Mode 2')

fig_2 = figure;
suptitle ('Phase Velocity Sensitivity')
subplot_3 = subplot(2,1,1);
title('Mode 1')
subplot_4 = subplot(2,1,2);
title('Mode 2')

fig_3 = figure;
suptitle ('Wavenumber')
subplot_5 = subplot(2,1,1);
title('Mode 1')
subplot_6 = subplot(2,1,2);
title('Mode 2')

fig_4 = figure;
suptitle ('Wavenumber Sensitivity')
subplot_7 = subplot(2,1,1);
title('Mode 1')
subplot_8 = subplot(2,1,2);
title('Mode 2')

leg_text = '';


cc=hsv(size(all_strain_per  ,2));




for index = 1:size(all_strain_per  ,2)
    
figure(fig_1)
subplot(subplot_1)
plot(reshaped_proc_data(index).data.freq(:,1),reshaped_proc_data(index).data.ph_vel(:,1),'-x','color',cc(index,:))    
title('Mode 1')
hold on

subplot(subplot_2)
plot(reshaped_proc_data(index).data.freq(:,2),reshaped_proc_data(index).data.ph_vel(:,2),'-x','color',cc(index,:))    
title('Mode 2')
hold on


figure(fig_3)
subplot(subplot_5)
plot(reshaped_proc_data(index).data.freq(:,1),reshaped_proc_data(index).data.waveno(:,1),'-x','color',cc(index,:))    
title('Mode 1')
hold on

subplot(subplot_6)
plot(reshaped_proc_data(index).data.freq(:,2),reshaped_proc_data(index).data.waveno(:,2),'-x','color',cc(index,:))    
title('Mode 2')
hold on

if index == size(all_strain_per  ,2)
comma_insert = '';
else
comma_insert = ',';
end
leg_text            = [leg_text,'''','Strain = ',num2str(all_strain_per(index)),'''', comma_insert]; 

end
figure(fig_1)
eval(['legend(',leg_text,')'])
xlabel('Freq')

subplot(subplot_1)
ylabel('Phase Velocity ')
xlabel('Freq')
grid on

subplot(subplot_2)
ylabel('Phase Velocity ')
xlabel('Freq')
grid on

figure(fig_3)
eval(['legend(',leg_text,')'])
subplot(subplot_5)
xlabel('Freq')
ylabel('Wave Number')
grid on

subplot(subplot_6)
xlabel('Freq')
ylabel('Wave Number')
grid on

%axis([0, 2000, 0,1200 ]);
%axis([0, 200, 0,500 ]);


end

%{
%length(reshaped_proc_data)
%a = {1:100:10]
%a = [1:100:10]
%a = [1:10/100:10]
%a = [0:10/100:10]
%size(a)
%a = [0:10/99):10]
a = [0:10/99:10]
size(a)
reshaped_proc_data(1).data.freq(:,1)
a = [1:50]
a = [1:50]'
reshaped_proc_data(1).data.freq(:,1)
interp(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),a)
a
interp(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),a)
reshaped_proc_data(1).data.waveno(:,1)
size(reshaped_proc_data(1).data.waveno(:,1))
size(reshaped_proc_data(1).data.freq(:,1))
interp(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),23)
interp1(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),23)
interp1(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),a)
b = interp1(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),a)
plot(b,a)
figure
plot(b,a)
hold on
plot(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),'x')
plot(a,b)
figure
plot(a,b)
hold on
plot(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),'x')
plot(reshaped_proc_data(1).data.freq(:,1),reshaped_proc_data(1).data.waveno(:,1),'rx')
plot(a,b)
plot(a,b,'o')
%-- 15/12/2016 05:48 --%

%}