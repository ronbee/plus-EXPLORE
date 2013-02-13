function [index] = try_exploration_norm(G, G_unnorm, labels)
%%
% index = try_exploration(G)
%
% index of next sample OR -1 of do not need exploration
%%

G_labels = G;
% (1) mark label knowledge
labelled_inx = find(labels~=0);

[grid1, grid2] = meshgrid(labelled_inx, labelled_inx);
for i=1:(size(grid1,1)*size(grid1,2))
    ind1 = grid1(i);
    ind2 = grid2(i);
    if ind1 >= ind2
        continue;
    end
    if labels(ind1)==labels(ind2) & G_labels(ind1,ind2)==0,
        G_labels(ind1,ind2) = ( min(G_labels(ind1,:))+min(G_labels(ind2,:)) ) / 2.0;
    else 
        if labels(ind1)~=labels(ind2) %& G_labels(ind1,ind2)~=0,
            G_labels(ind1,ind2) = 0;%( min(G_labels(ind1,:))+min(G_labels(ind2,:)) ) / 2.0;
        end 
    end                       
%    G_labels(ind1,ind2) =  double(labels(ind1) == labels(ind2));        
    G_labels(ind2,ind1) = G_labels(ind1,ind2);
end

% compute normalized Laplacian of the graph
s = sum(G_labels);
min_s = min(s(s~=0));        % ..
s(s==0) = min_s(1)/10; % ..
sqrt_1_D = diag(1./s); % prevent division by zero
L = sqrt_1_D * G_labels * sqrt_1_D;

%[Nclusters K] = computeKernel(G_labels);
%cluster_sets = online_kmeans(K, Nclusters, 'compute_KL', 10, 0);

[cluster_sets,Quality,D,W] = segment_image(L,[],1:15,'qq','RT1');
pack;

Nclusters = length(cluster_sets);
fprintf(1,'cluster sizes=[ ');
for i = 1:Nclusters 
    fprintf(1,'%d ', size(cluster_sets{i},2));
end
disp(' ]');

candidate_cluster_inx = -1;
candidate_cluster_size = 0;
for i=1:Nclusters
    disp(sprintf('cluster %d: size=%d, instersection with labeled=%d',i, length(cluster_sets{i}), ...
        length(intersect(labelled_inx, cluster_sets{i}))));
    if isempty( intersect(labelled_inx, cluster_sets{i}) ),
        if length(cluster_sets{i}) > candidate_cluster_size,
            candidate_cluster_inx = i;
            candidate_cluster_size = length(cluster_sets{i});            
        end
    end
end

if 0==candidate_cluster_size,
    index = -1;
else
    index = compute_query_in_cluster(G_unnorm, cluster_sets{candidate_cluster_inx});
end

