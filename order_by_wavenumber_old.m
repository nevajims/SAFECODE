function [data_wn,data_wn_mat] = order_by_wavenumber_old(data,do_plot);

% need to reshape so that


node_ = 1 ;
mode_ = 1 ;

% legacy from 'Fenel' processing --  beacuse of file ordering in directory  -----  not necessary for 'SAFE' data

no_points       = size(data.ms_x,2);
no_nodes        = size(data.ms_x,1);
points_per_mode = data.no_files;
no_mode_shapes  = round(no_points/points_per_mode);

lambda = data.ph_vel(1:no_mode_shapes:no_points,1) ./ data.freq(1:no_mode_shapes:no_points,1);
[ordered_lambda , block_lookup] = sort(lambda);


block_lookup   =  flipud(block_lookup)    ; %reverse it   because k = 2pi/lambda

for count=1 : points_per_mode
initial_lookup((count-1)*no_mode_shapes + 1 : count*no_mode_shapes)    =   (block_lookup(count)-1) * no_mode_shapes + 1  :   block_lookup(count)*no_mode_shapes;
end;



% find the first mode shape and compare it to the original mode shape
data_wn.no_files = data.no_files;  
data_wn.freq     = data.freq(initial_lookup(:)); 
data_wn.ph_vel   = data.ph_vel(initial_lookup(:));
data_wn.ms_x     = data.ms_x(:,initial_lookup(:));
data_wn.ms_y     = data.ms_y(:,initial_lookup(:));
data_wn.ms_z     = data.ms_z(:,initial_lookup(:));

data_wn_mat.freq       =  reshape(data_wn.freq,no_mode_shapes,points_per_mode)         ;
data_wn_mat.ph_vel     =  reshape(data_wn.ph_vel,no_mode_shapes,points_per_mode)       ;


for index = 1:no_nodes 
temp_x = data_wn.ms_x(index,:);
temp_y = data_wn.ms_y(index,:);
temp_z = data_wn.ms_z(index,:);

reshape_temp_x  = reshape(temp_x, no_mode_shapes,points_per_mode);   
reshape_temp_y  = reshape(temp_y, no_mode_shapes,points_per_mode);   
reshape_temp_z  = reshape(temp_z, no_mode_shapes,points_per_mode);   

data_wn_mat.ms_x(index,:,:) = reshape_temp_x;      
data_wn_mat.ms_y(index,:,:) = reshape_temp_y;            
data_wn_mat.ms_z(index,:,:) = reshape_temp_z;            

end %for index = 1:no_points

% plot the first mode from vector and reshaped to make sure the are the same

if do_plot ==1
figure(1)
subplot (2,1,1)    
plot(2*pi*data.freq./data.ph_vel,'.')
subplot (2,1,2)    
plot(2*pi*data_wn.freq./data_wn.ph_vel,'.')

    figure(2)
subplot (3,1,1)    
temp__ = squeeze(data_wn_mat.ms_x(node_,mode_,:));

plot(real(temp__) , 'rx')
hold on
plot( real(data_wn.ms_x(node_,(mode_-1)*points_per_mode+1  : mode_*points_per_mode) ),'bo')
subplot (3,1,2)
temp__ = squeeze(data_wn_mat.ms_y(node_,mode_,:));

plot(real(temp__) , 'rx')
hold on
plot( real(data_wn.ms_y(node_,(mode_-1)*points_per_mode+1  : mode_*points_per_mode) ),'bo')
subplot (3,1,3)
temp__ = squeeze(data_wn_mat.ms_z(node_,mode_,:));

plot(real(temp__) , 'rx')
hold on
plot( real(data_wn.ms_z(node_,(mode_-1)*points_per_mode+1  : mode_*points_per_mode) ),'bo')
end %if do_plot == 1

end % function
