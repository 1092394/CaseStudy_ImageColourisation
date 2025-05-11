addpath('..\lib');
addpath('..\KernelFcns');
addpath('..\ImgRecoveryAlg');

origCartoon  = imread('Pics/cartoon.jpg');
origPeppers  = imread('Pics/peppers.png');
greyCartoon  = genGreyImg('Pics/cartoon.jpg');
greyPeppers  = genGreyImg('Pics/peppers.png');

roi = 0.02;
maskC = genMask(greyCartoon, roi, 'Uniform');
maskP = genMask(greyPeppers, roi, 'Uniform');
combC = combineMaskedImg(origCartoon, greyCartoon, maskC);
combP = combineMaskedImg(origPeppers, greyPeppers, maskP);

sigma2_fixed = 100;
p_fixed      = 0.5;
delta        = 2e-4;
kernel       = "Gaussian";
roundMethod  = "MinMax";

imgNames = {'Cartoon','Peppers'};
origs    = {origCartoon, origPeppers};
combs    = {combC, combP};
greys    = {greyCartoon, greyPeppers};
masks    = {maskC, maskP};

sigma1s = [50, 100, 150];
figure('Name','σ_1','NumberTitle','off');
tl1 = tiledlayout(2, 4, 'TileSpacing','compact','Padding','compact');
for iImg = 1:2
  for col = 1:4
    ax = nexttile((iImg-1)*4 + col);
    if col == 1
      imshow(origs{iImg}, 'Parent', ax);
      title(ax, 'Original');
    else
      s1 = sigma1s(col-1);
      res = imgRecBuildin(...
        combs{iImg}, greys{iImg}, masks{iImg}, ...
        s1, sigma2_fixed, p_fixed, delta, ...
        kernel, roundMethod);
      imshow(res, 'Parent', ax);
      title(ax, sprintf('σ₁ = %d', s1));
    end
    if col == 1
      ylabel(ax, imgNames{iImg});
    end
  end
end

sigma2s = [50, 100, 150];
figure('Name','σ_2','NumberTitle','off');
tl2 = tiledlayout(2, 4, 'TileSpacing','compact','Padding','compact');
for iImg = 1:2
  for col = 1:4
    ax = nexttile((iImg-1)*4 + col);
    if col == 1
      imshow(origs{iImg}, 'Parent', ax);
      title(ax, 'Original');
    else
      s2 = sigma2s(col-1);
      res = imgRecBuildin(...
        combs{iImg}, greys{iImg}, masks{iImg}, ...
        sigma1s(2), s2, p_fixed, delta, ...
        kernel, roundMethod);
      imshow(res, 'Parent', ax);
      title(ax, sprintf('σ₂ = %d', s2));
    end
    if col == 1
      ylabel(ax, imgNames{iImg});
    end
  end
end

ps = [0.25, 0.50, 0.75];
figure('Name','p','NumberTitle','off');
tl3 = tiledlayout(2, 4, 'TileSpacing','compact','Padding','compact');
for iImg = 1:2
  for col = 1:4
    ax = nexttile((iImg-1)*4 + col);
    if col == 1
      imshow(origs{iImg}, 'Parent', ax);
      title(ax, 'Original');
    else
      pval = ps(col-1);
      res = imgRecBuildin(...
        combs{iImg}, greys{iImg}, masks{iImg}, ...
        sigma1s(2), sigma2_fixed, pval, delta, ...
        kernel, roundMethod);
      imshow(res, 'Parent', ax);
      title(ax, sprintf('p = %.2f', pval));
    end
    if col == 1
      ylabel(ax, imgNames{iImg});
    end
  end
end
