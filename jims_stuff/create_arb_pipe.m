function [nodes_,edge_] = create_arb_pipe(inner_dia , thickness , no_points)

% do the outer first, then the inner and then do the connectivity: edge_
angle_ = linspace(0, 2 * pi, no_points);
angle_  = angle_(1:end - 1)';
inner_nodes  = [cos(angle_), sin(angle_)] * inner_dia/2               ;
outer_nodes  = [cos(angle_), sin(angle_)] * (inner_dia/2+thickness)   ;

nodes_ =  [ inner_nodes ; outer_nodes ];

n_inner_nodes = size(inner_nodes,1);
n_outer_nodes = size(outer_nodes,1);
c_inner_nodes = [(1:n_inner_nodes-1)', (2:n_inner_nodes)'; n_inner_nodes, 1] ;
c_outer_nodes = [(1:n_outer_nodes-1)', (2:n_outer_nodes)'; n_outer_nodes, 1] ;
edge_ = [c_inner_nodes ; c_outer_nodes + n_inner_nodes ] ;

end 

% 18 inch pipe:     ID =  438.5mm \ inner rad = 219.2         ,        t = 9.525mm
% create_arb_pipe(438.5,9.525,300)