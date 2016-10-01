function EF = adj_like(label,adj_idx_tab,k,beta)
    EF=label*adj_idx_tab;%for different segment, how many different kind of neighbor you have
    neighbor_N=sum(EF); % compute the number of numbers per node
    EF = -2*EF+repmat(neighbor_N,k,1);
    EF = beta*EF;%./repmat(neighbor_N,k,1);
end