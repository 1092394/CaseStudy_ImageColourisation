function f = objectiveFcnScale(orImg, comb, greyImg, mask, para, delta, KernelFcn, roundScheme)
    sigma1 = para(1);
    sigma2 = para(2);
    p = para(3);

    rev = imgScaleRecBuildin(comb, greyImg, mask, sigma1, sigma2, p, delta, KernelFcn, roundScheme);
    
    sz = size(mask);
    
    m = sz(1) * sz(2);
  
    f = sqrt(sum(sum(sum((orImg - rev) .^ 2))));

    f = f / (3 * m);

end