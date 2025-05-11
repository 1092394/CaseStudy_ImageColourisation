addpath('..\lib')
addpath('..\KernelFcns\')
addpath('..\ImgRecoveryAlg\')

clear all
clc

filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\peppers.png';

img = imread(filename);
greyImg = genGreyImg(filename);

eg = edge(greyImg(:, :, 1), 'canny', .7);

imshowpair(greyImg, eg, 'montage')

C_num_list = 1:30;

% [L, C] = imsegkmeans(greyImg, C_num);
% B = labeloverlay(greyImg,L);

% imshow(B)
% idx = cell(1, C_num);
greyImgSlice = greyImg(:, :, 1);
sz = size(greyImgSlice);

e = [];
CHlist = [];

% for C_num = C_num_list
%     C_num
%     [L, C] = imsegkmeans(greyImg, C_num);
% 
%     CHlist = [CHlist, CHidx(L, C, greyImgSlice)];
% 
%     temp_e = 0;
%     for i = 1:C_num
%         c_gamma = C(i, 1); 
%         temp_e = temp_e + sum((greyImgSlice(find(L == i)) - c_gamma).^2);
%     end
%     temp_e = temp_e / (sz(1) *  sz(2));
%     e = [e, temp_e];
% end
% plot(e)
% plot(diff(e))
% 
% rate_e = [];
% for i = 1:length(e) - 1
%     rate_e = [rate_e, e(i+1) / e(i)];
% end

temp = reshape(greyImgSlice, [], 1);
evaluation = evalclusters(double(temp),"kmeans","DaviesBouldin","KList",1:30)
plot(evaluation.CriterionValues)
xlim([1, 30])