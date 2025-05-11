addpath('..\lib');
addpath('..\KernelFcns');
addpath('..\ImgRecoveryAlg');

origCartoon = imread('Pics/cartoon.jpg');
origPeppers = imread('Pics/peppers.png');
greyCartoon = genGreyImg('Pics/cartoon.jpg');
greyPeppers = genGreyImg('Pics/peppers.png');

maskCartoon = genMask(greyCartoon, 0.09, 'Uniform');
maskPeppers = genMask(greyPeppers, 0.09, 'Uniform');
combCartoon = combineMaskedImg(origCartoon, greyCartoon, maskCartoon);
combPeppers = combineMaskedImg(origPeppers, greyPeppers, maskPeppers);

rounds   = ["MinMax", "Rescale"];
roundsLabel   = ["Clipping", "Rescale"];
imgNames = {'Cartoon','Peppers'};

figure('Name','round 方法对比','NumberTitle','off');
tl = tiledlayout(2, 2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

numCols = 2; 

for iImg = 1:2
    for k = 1:2
        idx = (iImg-1)*numCols + k;  
        ax = nexttile(idx);

        if iImg == 1
            comb = combCartoon; 
            grey = greyCartoon; 
            mask = maskCartoon;
        else
            comb = combPeppers; 
            grey = greyPeppers; 
            mask = maskPeppers;
        end

        res = imgRecBuildin(comb, grey, mask,   100, 100, 0.5, 2e-4, "Gaussian",  rounds(k));
        
        imshow(res, 'Parent', ax);
        if iImg == 1
            title(ax, roundsLabel(k));
        end
        if k == 1
            ylabel(ax, imgNames{iImg});
        end
    end
end
