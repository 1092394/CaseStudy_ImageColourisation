clear all
clc

percentage = 2;

delta = 2e-4;

KernelFcn = "CSRBF";
roundScheme = "Rescale";
samplingScheme = "Uniform";
filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\cartoon.jpg';

img = imread(filename);

mask = genMask(img, percentage, samplingScheme);
greyImg = genGreyImg(filename);
comb = combineMaskedImg(img, greyImg, mask);

f = @(par) objectiveFcn(img, comb, greyImg, mask, par, delta, KernelFcn, roundScheme);
par0 = [log(100), log(100), log(1/2)];

options = optimset('MaxIter', 30, 'Display','iter','PlotFcns',@optimplotfval);

[ln_x,fval,exitflag,output] = fminsearch(f, par0, options)
x = exp(ln_x)