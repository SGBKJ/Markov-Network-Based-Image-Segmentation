clear
clc
img = imread('Image01.png');
img = im2double(img);
[m,n] = size(img);
px_n = m*n;
%Generate the adacency matrix to speed up the running speed
adj_idx_tab = sparse(zeros(1));
adj_idx_tab(px_n,px_n) = 0;
img_idx_mat = zeros(m,n);
for i=1:n
    img_idx_mat(:,i) = (i-1)*m+1:i*m;
end
img_one_dim = reshape(img,1,px_n);
for i=1:n
    tmp_adj_tab_vec = zeros(m,px_n);
    nd_pos = img_idx_mat(1,i);
    for j = 1:m
        %left
        if i>1
            neighbor = img_idx_mat(j,i-1);
            tmp_adj_tab_vec(j,neighbor) = 1;
        end
        %right
        if i<n
            neighbor = img_idx_mat(j,i+1);
            tmp_adj_tab_vec(j,neighbor) = 1;
        end
        %down
        if j<m
            neighbor = img_idx_mat(j+1,i);
            tmp_adj_tab_vec(j,neighbor) = 1;
        end
        %up
        if j>1
            neighbor = img_idx_mat(j-1,i);
            tmp_adj_tab_vec(j,neighbor) = 1;
        end
    end
    adj_idx_tab(nd_pos:nd_pos+m-1,:) = tmp_adj_tab_vec;
    display(i);
end

k=4;
beta = 2;
label_display = zeros(1,px_n);
energy_display = 1e10;
%select the segmentation with the minimum energy
for i=1:10
    [label,energy,miu,sigma] = image_seg(img,k,beta,adj_idx_tab);
    if energy<energy_display
        label_display = label;
        energy_display = energy;
    end
end
%Calculate mu and sigma
miu = 255*miu;
sigma = 255*sigma;
m_img = miu'*label;
s_img = sigma*label;
%Calculate the label
label = (1:k)*label_display;
label = reshape(label,m,n);
%reshape the image from one dimenesional to 2D
m_img = reshape(m_img,m,n);
s_img = reshape(s_img,m,n);
m_img = uint8(m_img);
s_img = uint8(s_img);
figure(1)
imshow(m_img);
title('Mean Representation of image');
figure(2)
imshow(s_img);
title('Sigma Representation of image');