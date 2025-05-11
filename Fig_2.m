addpath('..\lib');
addpath('..\KernelFcns');
addpath('..\ImgRecoveryAlg');

origCartoon = imread('Pics/cartoon.jpg');
origPeppers = imread('Pics/peppers.png');
greyCartoon = genGreyImg('Pics/cartoon.jpg');
greyPeppers = genGreyImg('Pics/peppers.png');

maskCartoon = genMask(greyCartoon, 0.2, 'Uniform');
maskPeppers = genMask(greyPeppers, 0.2, 'Uniform');
combCartoon = combineMaskedImg(origCartoon, greyCartoon, maskCartoon);
combPeppers = combineMaskedImg(origPeppers, greyPeppers, maskPeppers);

kernels = ["Gaussian", "CSRBF"];
imgNames = {'Cartoon','Peppers'};

figure('Name','核函数对比','NumberTitle','off');
tl = tiledlayout(2, 2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

for iImg = 1:2
    for k = 1:2
        ax = nexttile((iImg-1)*2 + k);
        if iImg == 1
            comb = combCartoon; grey = greyCartoon; mask = maskCartoon;
        else
            comb = combPeppers; grey = greyPeppers; mask = maskPeppers;
        end

        res = imgRecBuildin(comb, grey, mask, 100, 100, 0.5, 2e-4, kernels(k), "MinMax" );
        
        imshow(res, 'Parent', ax);
        if iImg == 1
            title(ax, kernels(k));
        end
        if k == 1
            ylabel(ax, imgNames{iImg});
        end
    end
end
