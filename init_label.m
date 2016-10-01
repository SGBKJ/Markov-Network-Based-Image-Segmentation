function label = init_label(image,label,k,m,n)
label_idx = kmeans(image',k); % Initialize the label using k-means
for i=1:k
    label(i,label_idx==i) = 1;
end
end