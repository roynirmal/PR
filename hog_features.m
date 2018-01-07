% extracting hog 
function hog =hog_features(im, size)
% [Gmag,Gdir]=imgradient(im);
% t=hist(Gdir(:),18);
[hog] = extractHOGFeatures(im,'CellSize',[size size]);
end