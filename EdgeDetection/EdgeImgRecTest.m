addpath('..\lib')
addpath('..\KernelFcns\')
addpath('..\ImgRecoveryAlg\')

clear all
clc
close all

sigma1 = 50;
sigma2 = 100;
sigma3 = 0.00003;
p = 1/2;
delta = 2e-4;
roundScheme = "MinMax";

filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\peppers.png';

orImg = imread(filename); % orImg = orImg(100:200, 100:200, :);
greyImg = genGreyImg(filename); % greyImg = greyImg(100:200, 100:200, :);
mask = genUnif(orImg, 0.2);
comb = combineMaskedImg(orImg, greyImg, mask);

[L, C] = imsegkmeans(greyImg, 3);
% L = mjorityFilter(L, 5);
L = removeSmallClusters(L, 20);
B = labeloverlay(greyImg, L);
imshow(B)

revImgedge = edgeImgRecBuildin(comb, greyImg, mask, L, sigma1, sigma2, sigma3, p, delta, roundScheme);
% revImgedge = newEdgeImgRecBuildin(comb, greyImg, mask, L, sigma1, sigma2, sigma3, p, delta, roundScheme);

revImg = imgRecBuildin(comb, greyImg, mask, sigma1, sigma2, p, delta, "Gaussian", roundScheme);
% subplot(2, 1, 1)
imshowpair(revImg, revImgedge, "montage")
% subplot(2, 1, 2)
% imshowpair(revImgedge, labeloverlay(greyImg,L))