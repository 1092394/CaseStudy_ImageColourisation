function L_filt = mjorityFilter(L, windowSize)

    if mod(windowSize, 2) == 0
        error('windowSize must be odd.');
    end

    [H, W] = size(L);
    halfWin = floor(windowSize / 2);
    L_pad = padarray(L, [halfWin, halfWin], 'replicate', 'both');

    L_filt = zeros(size(L), 'like', L);

    for r = 1 : H
        for c = 1 : W
            rrStart = r;
            rrEnd   = r + 2*halfWin;
            ccStart = c;
            ccEnd   = c + 2*halfWin;

            localPatch = L_pad(rrStart:rrEnd, ccStart:ccEnd);
            newLabel = mode(localPatch(:));

            L_filt(r,c) = newLabel;
        end
    end
end