function f = objectiveFcn(orImg, comb, greyImg, mask, para, delta, KernelFcn, roundScheme)
    %% Assume param in: ln(sigma), ln(p)
    sigma1 = exp(para(1));
    sigma2 = exp(para(2));
    p = exp(para(3));

    rev = imgRecBuildin(comb, greyImg, mask, sigma1, sigma2, p, delta, KernelFcn, roundScheme);
    
    sz = size(mask);
    
    m = sz(1) * sz(2);
        
    f = sqrt(sum(sum(sum((orImg - rev) .^ 2))));

    f = f / (3 * m);

end