projectRoot = 'D:\MyDesktop\MMSC Materials\Case Study _ SC\Project_Image_Colourisation\ImageColourisationApp';
addpath(fullfile(projectRoot,'lib'));
addpath(fullfile(projectRoot,'KernelFcns'));
addpath(fullfile(projectRoot,'ImgRecoveryAlg'));
addpath(fullfile(projectRoot,'EdgeProcessing'));  

imgFile  = fullfile(projectRoot,'Pics','cartoon.jpg');
orig     = imread(imgFile);
grey3ch  = genGreyImg(imgFile);
grey     = grey3ch(:,:,1);

[h,w]    = size(grey);

features = double(grey(:));
KList    = 3:20;
ev       = evalclusters(features,'kmeans','DaviesBouldin','KList',KList);
DB       = ev.CriterionValues;
Kopt     = ev.OptimalK;

L_tilde   = imsegkmeans(grey, Kopt);                
L_nosmall = removeSmallClusters(L_tilde, 20);
L_final   = reassignSmallRegion(L_nosmall, grey3ch);


mask       = genUnif(orig, 2);       
comb       = combineMaskedImg(orig, grey3ch, mask);

sigma1     = 50;
sigma2     = 100;
p          = 0.5;
delta      = 2e-4;
roundScheme= "MinMax";
revBasic   = imgRecBuildin(...
               comb, grey3ch, mask, ...
               sigma1, sigma2, p, delta, "Gaussian", roundScheme);

sigma3     = 0.00003;
revEdge    = edgeImgRecBuildin(...
               comb, grey3ch, mask, L_final, ...
               sigma1, sigma2, sigma3, p, delta, roundScheme);

figure('Name','Segmentation & Reconstruction','NumberTitle','off');
tl = tiledlayout(2,4, ...
    'TileSpacing','compact', ...
    'Padding','compact');

ax1 = nexttile(1,[1 4]);
plot(KList,DB,'-o','LineWidth',1.2); hold(ax1,'on');
plot(Kopt,DB(KList==Kopt),'ro','MarkerSize',4,'LineWidth',1.2);
grid(ax1,'on');
xlabel(ax1,'Number of clusters K');
ylabel(ax1,'Davies–Bouldin Index');
title(ax1,'DB Index vs K');
legend(ax1,{'DB Index','Optimal K'},'Location','best');
axis(ax1,'tight');

ax2 = nexttile(5);
imshow(orig,'Parent',ax2);
title(ax2,'Original');
axis(ax2,'off');

ax3 = nexttile(6);
overlayPost = labeloverlay(grey3ch, L_final);
imshow(overlayPost,'Parent',ax3);
title(ax3,'Post-merge Segmentation');
axis(ax3,'off');

ax4 = nexttile(7);
imshow(revBasic,'Parent',ax4);
title(ax4,'Standard Colourisation');
axis(ax4,'off');

ax5 = nexttile(8);
imshow(revEdge,'Parent',ax5);
title(ax5,'Cluster-Based Kernel');
axis(ax5,'off');
