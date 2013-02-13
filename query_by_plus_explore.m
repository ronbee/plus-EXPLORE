function query_inx = query_by_plus_explore(labels, W, base_alg,  c_param)
% function query_inx = query_by_plus_explore(labels, W, base_alg,  c_param)
%   labels: (m+u) x 1 vector
%   W : similarity matrix; W_{ij} denotes the similarity of data(i,:) and data(j,:) 
%   base_alg : learner component function name (e.g., 'cm_predict')  
%   c_param : hyper-parameter for base_alg
%
% Example:
%  >>  inx = query_by_plus_explore (fl, W,'cm_predict',  0.1)
%
% Note: you will have to "addpath common"

training_set_indicator = (labels~=0);
full_lbls = eval( sprintf('%s(W, labels, training_set_indicator, c_param)', base_alg) );

query_inx = try_exploration_norm(W, W, labels); %(*)

if (query_inx > 0)
    disp('Perform Exploration'); % already performed at (*) above
else    
    query_inx = query_by_most_uncertain(full_lbls, training_set_indicator); % (**) ...
end

