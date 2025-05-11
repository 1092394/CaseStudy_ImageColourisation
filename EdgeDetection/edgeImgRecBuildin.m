function img = edgeImgRecBuildin(comb, greyImg, mask, L, sigma1, sigma2, sigma3, p, delta, roundScheme)
    sz = size(mask);
    KD = genKD(mask, greyImg, sigma1, sigma2, p, "Gaussian");
    % KD = genEdgeKD(mask, greyImg, L, sigma1, sigma2, sigma3, p);

    K = genEdgeKOmega(mask, greyImg, L, sigma1, sigma2, sigma3, p);

    Ksz = size(K);

    fr = genfs(comb, mask, 1);
    fg = genfs(comb, mask, 2);
    fb = genfs(comb, mask, 3);

    ar = genAs(KD, delta, fr);
    ag = genAs(KD, delta, fg);
    ab = genAs(KD, delta, fb);

    rlayer = zeros(sz);
    glayer = zeros(sz);
    blayer = zeros(sz);

    WaitMessage = parfor_wait(Ksz(3), 'Waitbar', true);
    
    parfor i = 1:Ksz(3)
        WaitMessage.Send;
        rlayer(:, i) =  K(:, :, i) * ar;
        glayer(:, i) =  K(:, :, i) * ag;
        blayer(:, i) =  K(:, :, i) * ab;
    end
    
    switch roundScheme
        case "Rescale"     
            rlayer = recaleRound(rlayer, [0, 255, min(rlayer, [], "all"), max(rlayer, [], "all")]);
            glayer = recaleRound(glayer, [0, 255, min(glayer, [], "all"), max(glayer, [], "all")]);
            blayer = recaleRound(blayer, [0, 255, min(blayer, [], "all"), max(blayer, [], "all")]);
        case "MinMax"
            rlayer = minmaxRound(rlayer, [0, 255, min(rlayer, [], "all"), max(rlayer, [], "all")]);
            glayer = minmaxRound(glayer, [0, 255, min(glayer, [], "all"), max(glayer, [], "all")]);
            blayer = minmaxRound(blayer, [0, 255, min(blayer, [], "all"), max(blayer, [], "all")]);
        otherwise
            error("ERROR IN ROUND SCHEME!")
    end

    img(:, :, 1) = uint8(rlayer);
    img(:, :, 2) = uint8(glayer);
    img(:, :, 3) = uint8(blayer);

    WaitMessage.Destroy

end