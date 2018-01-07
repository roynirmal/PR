function [pp] = projection_features(im)

% horizontal projection
% vertical projection

for i=1:size(im,1)
    vp(i,1)=size(im,1)-sum(im(i,:)==0);
    hp(i,1)=size(im,1)-sum(im(:,i)==0);
end

% pp is the projection profile, obtained by stacking the vertical and
% horizontal projections

pp=[vp;hp];
% % % % % % % % % % % % geometrical features % % % % % % % % % % % % % %
% corners
% C is the M by 2 matrix of corner coordinates
% C=corner(im,10);

