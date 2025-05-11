function KD = genEdgeKD(mask, greyImg, L, sigma1, sigma2, sigma3, p)
    Dset = find(mask);
    [Dsetr, Dsetc] = ind2sub(size(mask), Dset);

    tempGreyImg = greyImg(:, :, 1); 
    DgreyImg = tempGreyImg(Dset);
    KD = edgeReKernel([Dsetr, Dsetc], [Dsetr, Dsetc], DgreyImg, DgreyImg, ...
        L, sigma1, sigma2, sigma3, p);
    % KD = myClusterAwareKernel( [Dsetr, Dsetc], [Dsetr, Dsetc], DgreyImg, DgreyImg, L, sigma1, sigma2, sigma3, p);
    
end