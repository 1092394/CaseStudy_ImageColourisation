addpath('..\lib')
addpath('..\KernelFcns\')
addpath('..\ImgRecoveryAlg\')

clear; clc;

greyThreshold = 8;

filename = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp\Pics\peppers.png';
I = genGreyImg(filename); 

mask = genUnif(I, 0.2);
[x, y] = ind2sub(size(mask), find(mask));

numSuperpixels = 2000;  
[L, ~] = superpixels(I, numSuperpixels);
L_before = L;

selectedMask = false(size(L));
for i = 1:length(x)
    row = round(x(i));
    col = round(y(i));
    spLabel = L(row, col); 
    selectedMask(L == spLabel) = true;
end

N = max(L(:));
stats = regionprops(L, I(:, :, 1), 'MeanIntensity');
meanIntensity = zeros(N, 1);
for k = 1:N
    meanIntensity(k) = stats(k).MeanIntensity;
end


selectedLabels = unique(L(selectedMask));

se = strel('square',3);

total_superpixel_change = inf;
current_superpixel_num = length(unique(L));

dict = containers.Map('KeyType','char','ValueType','any');
for i = selectedLabels' 
    dict(num2str(i)) = i;
end

while total_superpixel_change ~= 0
    for i = selectedLabels'
        currentRegion = ismember(L, i);
        dilated = imdilate(currentRegion, se);
        candidateMask = dilated & ~currentRegion;
        candidateLabels = unique(L(candidateMask));
        candidateLabels = candidateLabels(~(ismember(candidateLabels, selectedLabels)));    
        dict(num2str(i)) = [dict(num2str(i)), candidateLabels'];
    end

    for i = selectedLabels' % find neighbours of selected superpixels
        current_neighbour = dict(num2str(i));
        others = selectedLabels(selectedLabels ~= i);
        for j = others' % assign overlap superpixels
            overlap = current_neighbour(ismember(current_neighbour, dict(num2str(j))));
            if isempty(overlap) % no overlap
                % pass
            else
                for k = overlap % assign overlap according to greyscale image
                    if abs(meanIntensity(k) - meanIntensity(i)) <= abs(meanIntensity(k) - meanIntensity(j))
                        % remove k from j's neighbour
                        temp = dict(num2str(j));
                        temp(temp == k) = [];
                    else % remove k from i's neighbour
                        temp = dict(num2str(i)); 
                        temp(temp == k) = [];
                    end
                end
            end
        end
        current_neighbour = dict(num2str(i));
        for j = current_neighbour
            if abs(meanIntensity(j) - meanIntensity(i)) <= greyThreshold
                L(L == j) = i;
            end
        end
    end

    total_superpixel_change = current_superpixel_num - length(unique(L));
    current_superpixel_num = length(unique(L));
end

[~, ~, ic] = unique(L, 'sorted');
L = reshape(ic, size(L));

N = max(L(:));  
stats = regionprops(L, I(:, :, 1), 'MeanIntensity');
meanIntensity = zeros(N, 1);
for k = 1:N
    meanIntensity(k) = stats(k).MeanIntensity;
end


prev_superpixel_num = length(unique(L));  

while true
    N = max(L(:));

    stats = regionprops(L, I(:, :, 1), 'MeanIntensity');
    meanIntensity = zeros(N, 1);
    for k = 1:N
        meanIntensity(k) = stats(k).MeanIntensity;
    end

    merge_count = 0;

    for i = 1:N
        currentRegion = (L == i);
        dilated = imdilate(currentRegion, se);
        candidateMask = dilated & ~currentRegion;
        
        candidateLabels = unique(L(candidateMask));
        for j = candidateLabels'
            if abs(meanIntensity(i) - meanIntensity(j)) <= greyThreshold
                L(L == j) = i;
                merge_count = merge_count + 1;
            end
        end
    end

    [~, ~, ic] = unique(L, 'sorted');
    L = reshape(ic, size(L));

    curr_superpixel_num = length(unique(L));
    if curr_superpixel_num == prev_superpixel_num
        break;
    else
        prev_superpixel_num = curr_superpixel_num; 
    end
end



sigma1 = 70;
sigma2 = 100;
sigma3 = 0.00005;
p = 1/2;
delta = 2e-4;
roundScheme = "MinMax";
orImg = imread(filename);
comb = combineMaskedImg(orImg, I, mask);
revImgedge = edgeImgRecBuildin(comb, I, mask, L, sigma1, sigma2, sigma3, p, delta, roundScheme);

revImg = imgRecBuildin(comb, I, mask, sigma1, sigma2, p, delta, "Gaussian", roundScheme);
% subplot(2, 1, 1)
% imshowpair(revImg, revImgedge, "montage")

figure;


subplot(2,2,1);
BW_before = boundarymask(L_before);  
overlay_before = imoverlay(I, BW_before, 'cyan');
overlay_before = imoverlay(overlay_before, selectedMask, [1 0 0]);
imshow(overlay_before);
title('Superpixels via SLIC');

subplot(2,2,2);
BW_after = boundarymask(L);
overlay_after = imoverlay(I, BW_after, 'cyan');
imshow(overlay_after);
title('Merged Superpixels');

subplot(2,2,3);
imshow(revImg);
title('Recovered Image.A');

subplot(2,2,4);
imshow(revImgedge);
title('Recovered Image.B');
