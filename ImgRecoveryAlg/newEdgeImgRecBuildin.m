function img = newEdgeImgRecBuildin(comb, greyImg, mask, L, sigma1, sigma2, sigma3, p, delta, roundScheme)
    img = zeros(size(comb));
    K = unique(L);
    D_idx = find(mask);
    sz = size(mask);

    cluster_rev = cell(1, length(K));

    for i = 1: length(K)
        cluster_idx = find(L == K(i));
        [cluster_r, cluster_c] = ind2sub(sz, cluster_idx);
        
        D_idx_in_ith_cluster = D_idx(ismember(D_idx, cluster_idx));
        if ~isempty(D_idx_in_ith_cluster)
            tempMask = zeros(sz);
            tempMask(D_idx_in_ith_cluster) = 1;
            tempComb = greyImg;
            [D_r_i, D_c_i] = ind2sub(sz, D_idx_in_ith_cluster);
            tempComb(D_r_i, D_c_i, :) = comb(D_r_i, D_c_i, :);
            tempSigma = sigma3;
        else
            tempMask = mask;
            tempComb = comb;
            tempSigma = sigma1;
        end
        
        tempImg = imgRecBuildin(tempComb, greyImg, tempMask, tempSigma, sigma2, p, delta, "Gaussian", roundScheme);
        % Cut for pixels within ith clustering
        ttt = tempImg([1, 2], [1, 2], :);
        cluster_rev(i) = tempImg(cluster_r', cluster_c', :);
        
        %img(cluster_c, cluster_r, :) = tempImg(cluster_c, cluster_r, :);
    end

    for i = 1:length(K)
        cluster_idx = find(L == K(i));
        [cluster_r, cluster_c] = ind2sub(sz, cluster_idx);
        img(cluster_c', cluster_r', :) = cluster_rev(i);
    end
    


end