function K = genEdgeKOmega(mask, greyImg, L, sigma1, sigma2, sigma3, p)
    sz = size(mask);
    rOmega = sz(1);
    cOmega = sz(2);

    Dset = find(mask);
    [Dsetr, Dsetc] = ind2sub(sz, Dset);
    DLoc = [Dsetr, Dsetc];
    
    nTotal = length(Dset);
    K = zeros(rOmega, nTotal, cOmega);

    tempGreyImg = greyImg(:, :, 1); 
    DgreyImg = tempGreyImg(Dset);

    WaitMessage = parfor_wait(cOmega, 'Waitbar', true);


        parfor i = 1:cOmega
            WaitMessage.Send;
            xLoc = [(1:rOmega)', i*ones(rOmega, 1)];

            K(:, :, i) = edgeReKernel(xLoc, DLoc, tempGreyImg(:, i), DgreyImg, L, sigma1, sigma2, sigma3, p)';
            % K(:, :, i) = myClusterAwareKernel(xLoc, DLoc, tempGreyImg(:, i), DgreyImg, L, sigma1, sigma2, sigma3, p)';

        end  

    
    WaitMessage.Destroy

end