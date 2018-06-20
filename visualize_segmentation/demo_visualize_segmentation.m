% demo for the multi-modal segmentation visualizing
% testing 3D volumes
im1 = zeros(100,100,100);
im2 = im1;
im1(26:75,26:75,26:75) = 1;
% first binary segmentation
seg1 = im1==1;
im1(1:60,31:60,41:90) = 2;
% second binary segmentation
seg2 = im1==2;
im2(im1==1) = 2;
im2(im1==2) = 1;
% concatenating volumes into 4D
im = cat(4,im1,im2);
% defining roi, if not defined, the whole image is used
roi = true(size(im1));
% visualization
eval = visualize_segmentation(im,seg1,seg2,roi)
% evaluation without visualization
[Jaccard,Dice,Tanimoto,Accuracy,tpr,tnr,fpr,fnr]=evalSegmentation(seg1,seg2,roi)

% visualization of a single slice only
im2D = cat(4,im1(:,:,50),im2(:,:,50));
seg2D1 = seg1(:,:,50);
seg2D2 = seg2(:,:,50);
roi2D = roi(:,:,50);
eval2D = visualize_segmentation(im2D,seg2D1,seg2D2,roi2D)