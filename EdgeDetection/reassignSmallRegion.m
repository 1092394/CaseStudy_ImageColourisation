function L_clean = reassignSmallRegion(L_clean, compPixels)
    % 把 compPixels 那些位置的标签改成邻居标签中出现最多的
    % 实现可多种方式, 这里仅给示例

    [H, W] = size(L_clean);
    [rr, cc] = ind2sub([H, W], compPixels);

    % 找到这片区域的外边界(可以做morphological dilation再diff等)
    % 这里简单做个±1邻居(可能不够精确)
    neighborLabels = [];
    for k = 1:length(compPixels)
        r = rr(k);
        c = cc(k);
        for dr = -1:1
            for dc = -1:1
                if dr==0 && dc==0, continue; end
                nr = r+dr; nc = c+dc;
                if nr>=1 && nr<=H && nc>=1 && nc<=W
                    % 不属于该连通域 => 视作邻居
                    if L_clean(nr,nc) ~= L_clean(r,c)
                        neighborLabels(end+1) = L_clean(nr,nc); %#ok<AGROW>
                    end
                end
            end
        end
    end

    if isempty(neighborLabels)
        return; % 周围全是同一标签, 无法合并
    end

    % 多数投票 -> reassign label
    newLabel = mode(neighborLabels);
    for k = 1:length(compPixels)
        L_clean(compPixels(k)) = newLabel;
    end
end