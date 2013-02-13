function index_in_K = compute_query_in_cluster(K_unnorm, cluster_set)
%%
%
%%

ind = 1:size(K_unnorm,1);
K_unnorm(setdiff(ind, cluster_set),:) = 0;
degrees = sum(K_unnorm);
[val index_in_cluster] = max(degrees(cluster_set)); 
index_in_K = cluster_set(index_in_cluster(1));