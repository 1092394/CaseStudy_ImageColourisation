function L_clean = removeSmallClusters(L, minSize)
    L_clean = L;
    clusters = unique(L_clean);
    for clab = clusters'
        bw = (L_clean == clab);
        cc = bwconncomp(bw);
        for iComp = 1 : cc.NumObjects
            compPixels = cc.PixelIdxList{iComp};
            if numel(compPixels) < minSize
                L_clean = reassignSmallRegion(L_clean, compPixels);
            end
        end
    end
end