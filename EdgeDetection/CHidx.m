function ch = CHidx(L, C, greyImgSlice)
    % Calinski-Harabasz index
    [k, ~] = size(C);
    [m, n] = size(L);

    Wk = 0;
    for i = 1: k
        Wk = Wk + sum((C(i, 1) - greyImgSlice(find(L == i))).^2);
    end

    Bk = 0;
    x_bar = sum(sum(greyImgSlice)) / (m*n);
    for i = 1:k
        Bk = Bk + length(find(L==i)) * sum((x_bar - C(i, 1)).^2);
    end

    ch = Bk / Wk * ((m*n - k) / (k -1));


end