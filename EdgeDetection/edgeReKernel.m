function K = edgeReKernel(x, y, gamma_x, gamma_y, L, sigma1, sigma2, sigma3, p)
    gamma_x = double(gamma_x);
    gamma_y = double(gamma_y);

    clusters = unique(L);
    k = max(clusters);

    sz = size(L);

    x_idx = sub2ind(sz, x(:, 1), x(:, 2));
    y_idx = sub2ind(sz, y(:, 1), y(:, 2));

    distMat = pdist2(y, x);

    gammaDiff = abs(gamma_x' - gamma_y);

    greyInfo = exp(- (gammaDiff .^ p ./ sigma2) .^2);

    weightMat = ones(size(distMat)) .* sigma1;

    for i = clusters'
        idx = find(L == i); % idx in i-th cluster
        % find idx of x and y in cluster i
        x_in_whitelist = pdist2(x_idx, idx);
        y_in_whitelist = pdist2(y_idx, idx);

        [x_idx_loop, ~] = ind2sub(size(x_in_whitelist), find(x_in_whitelist==0));
        x_idx_loop = unique(x_idx_loop);
        [y_idx_loop, ~] = ind2sub(size(y_in_whitelist), find(y_in_whitelist==0));
        y_idx_loop = unique(y_idx_loop);
            
        % length(x_idx)

        if isempty(x_idx_loop) || isempty(y_idx_loop)
            % If x or y no overlap with i-th cluster, then do nothing

        else % else, reset the sigma1 to sigma3 for points in this cluster
            weightMat(y_idx_loop, x_idx_loop) = sigma3 * length(idx) + sigma1;        
        end
        
    end

    distMat = distMat ./ weightMat;

    distInfo = exp(- (distMat) .^2);

    K = distInfo .* greyInfo;


end