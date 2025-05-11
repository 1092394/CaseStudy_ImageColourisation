projectRoot = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp';
addpath(fullfile(projectRoot,'lib'));
addpath(fullfile(projectRoot,'KernelFcns'));
addpath(fullfile(projectRoot,'ImgRecoveryAlg'));

imgFile = fullfile(projectRoot,'Pics','peppers.png');
orig    = imread(imgFile);
grey3ch = genGreyImg(imgFile); 
grey    = grey3ch(:,:,1);
figure('Name','Original and Grayscale','NumberTitle','off');
tl = tiledlayout(1,2, ...
    'TileSpacing','none', ...
    'Padding','none');

ax1 = nexttile;
imshow(orig, 'Parent', ax1);
title(ax1, 'Original');
axis(ax1,'off');

ax2 = nexttile;
imshow(grey, [], 'Parent', ax2);

title(ax2, 'Grayscale');
axis(ax2,'off');
