addpath('..\lib');
addpath('..\KernelFcns');
addpath('..\ImgRecoveryAlg');

origCartoon = imread('Pics/cartoon.jpg');
origPeppers = imread('Pics/peppers.png');
greyCartoon = genGreyImg('Pics/cartoon.jpg');
greyPeppers = genGreyImg('Pics/peppers.png');

origs = {origCartoon, origPeppers};
greys = {greyCartoon, greyPeppers};
names = {'Cartoon','Peppers'};
rois = [0.03,0.07,0.15];

figure('Name','ROI 比例对比','NumberTitle','off');
tl = tiledlayout(2,3, ...
    'TileSpacing','compact', ...  
    'Padding','compact');          

for iImg = 1:2
    for k = 1:3
        ax = nexttile((iImg-1)*3 + k);
        orig = origs{iImg};
        grey = greys{iImg};
        mask = genMask(grey, rois(k), 'Uniform');
        comb = combineMaskedImg(orig, grey, mask);
        res  = imgRecBuildin(comb, grey, mask, 100,100,0.5,2e-4, "Gaussian","MinMax");
        imshow(res, 'Parent', ax);
        
        if iImg==1
            title(ax, sprintf('ROI = %d%%', rois(k)*1));
        end
        if k==1
            ylabel(ax, names{iImg});
        end
    end
end

