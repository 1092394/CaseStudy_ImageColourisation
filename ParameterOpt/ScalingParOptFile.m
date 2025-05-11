clear all
clc

addpath('..\KernelFcns\')
addpath('..\ImgRecoveryAlg\')
addpath('..\lib\')

percentage = 0.5;

delta = 2e-4;

KernelFcn = "Gaussian";
roundScheme = "MinMax";
samplingScheme = "Uniform";
filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\peppers.png';

img = imread(filename);

mask = genMask(img, percentage, samplingScheme);
greyImg = genGreyImg(filename);
comb = combineMaskedImg(img, greyImg, mask);


% sigma1 = 0.0001; sigma2 = 0.01; p = 1/2;
% img = imgScaleRecBuildin(comb, greyImg, mask, sigma1, sigma2, p, delta, KernelFcn, roundScheme);
% imshow(img)


f = @(par) objectiveFcnScale(img, comb, greyImg, mask, par, delta, KernelFcn, roundScheme);
par0 = [0.0001, 0.0001, 1/2];

options = optimset('MaxIter', 20, 'Display','iter','PlotFcns',@optimplotfval);

[x1,fval1,exitflag1,output1] = fminsearch(f, par0, options)
% "Gaussian", "MinMax", "Uniform", 0.5%
% x1 = 0.000282916666667   0.000011244855967   0.004012345679014
% fval1 =
%    0.015578065633280

% "Gaussian", "MinMax", "Uniform", 1%
% x1 =
%    0.000282916666667   0.000011244855967   0.004012345679014
% fval1 =
%    0.013809270606867

% "Gaussian", "MinMax", "Uniform", 2%
% x1 =
%    0.000282916666667   0.000011244855967   0.004012345679014
% fval1 =
%    0.011725448334521



%%
filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\cartoon.jpg';

img = imread(filename);

mask = genMask(img, percentage, samplingScheme);
greyImg = genGreyImg(filename);
comb = combineMaskedImg(img, greyImg, mask);


% sigma1 = 0.0001; sigma2 = 0.01; p = 1/2;
% img = imgScaleRecBuildin(comb, greyImg, mask, sigma1, sigma2, p, delta, KernelFcn, roundScheme);
% imshow(img)


f = @(par) objectiveFcnScale(img, comb, greyImg, mask, par, delta, KernelFcn, roundScheme);
par0 = [0.0001, 0.0001, 1/2];

options = optimset('MaxIter', 20, 'Display','iter','PlotFcns',@optimplotfval);

[x2,fval2,exitflag2,output2] = fminsearch(f, par0, options)
% "Gaussian", "MinMax", "Uniform", 0.5%
% x2 = 0.000282916666667   0.000011244855967   0.004012345679014
% fval2 =
% 
%    0.014498825427294

% "Gaussian", "MinMax", "Uniform", 1%
% x2 =
%    0.000282916666667   0.000011244855967   0.004012345679014
% fval2 =
%    0.013718171782582

% "Gaussian", "MinMax", "Uniform", 2%
% x2 =
%    0.000282916666667   0.000011244855967   0.004012345679014
% fval2 =
% 
%    0.012910379967861s