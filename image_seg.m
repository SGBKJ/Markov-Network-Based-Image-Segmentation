function [label,energy,miu,sigma] = image_seg(img,k,beta,adj_idx_tab)
%% Initialization Phase
%Represent the image in one demensional array
[m,n] = size(img);
px_n = m*n;
img_one_dim = reshape(img,1,px_n);
%Initialize the label randomly
label = zeros(k,px_n);
label = init_label(img_one_dim,label,k);

Nk = sum(label,2);%number of pixels per segment
%Calculate the initial miu and sigma
miu = label*img_one_dim'./Nk;
sigma = zeros(1,k);
for i=1:k
    sigma(i) = sqrt(1/Nk(i)*sum(label(i,:).*(img_one_dim-miu(i)).^2));
end
%Calculate the energy from two parts
Er = log_gauss(img_one_dim,miu,sigma,k);
Ef = adj_like(label,adj_idx_tab,k,beta);


%% EM algorithm
epsl = 1;
Es_new = Er + Ef; %New energy function
err = 1e10;
em_count=0;
while err>epsl||(em_count<5) %allow for the decreasing energy function at beginning
    em_count=em_count+1;
    %% M step
    [~,label_idx] = min(Es_new);
    label = zeros(k,px_n);
    for i=1:k
        label(i,label_idx==i) = 1;
    end
    %% E step
    Nk = sum(label,2);%number of pixels per segment
    for i=1:k
        if Nk(i) ~= 0
            %em_count = 0;%allow energy reduction for re-assigning clusters.
            miu(i) = label(i,:)*img_one_dim'./Nk(i);
            sigma(i) = sqrt(1/Nk(i)*sum(label(i,:).*(img_one_dim-miu(i)).^2));
        else
            miu(i) = mean(miu);
            sigma(i) = mean(sigma);
        end
    end
    Es_old = Es_new;
    %Update the new energy function
    Er = log_gauss(img_one_dim,miu,sigma,k);
    Ef = adj_like(label,adj_idx_tab,k,beta);
    Es_new = Er + Ef;
    err = (Es_old - Es_new).*label;
    err = sum(err(:));
    %display(err);
end
energy=sum(sum(Es_new.*label));
display(energy);
end