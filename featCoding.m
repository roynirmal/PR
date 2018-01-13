function pr_ds_features = featCoding(a, resizeSize, feature, thresholding)

if(feature)

for k = 1 : size(a,1)
    
c = reshape(+a(k,:), [resizeSize+2 resizeSize+2])' ;


%write code for hog
            feat_hog(k,:) = hog_features(c, 4);
            

%write code for proj
level = graythresh(c);
binarized = imbinarize(c,level);
            feat_proj(k,:) = projection_features(binarized);
            %feat_select = [feat_select feat_proj];


%write code for chain
            B=bwboundaries(binarized,8,'noholes');
            C=chaincode(B{1,1});
            feat_chain(k,:)=hist(C.code,8);
%             feat_select = [feat_select feat_chain];
end
feat_select = [feat_hog feat_proj feat_chain];
v= ['digit_0';
    'digit_1';
    'digit_2';
    'digit_3';
    'digit_4';
    'digit_5';
    'digit_6';
    'digit_7';
    'digit_8';
    'digit_9'
];
% v = [ 1,2,3,4,5,6,7,8,9,10];
label = genlab([size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10 size(a,1)/10   ],v);
feat_select = prdataset(double(feat_select), label);
features = im_features(a, a, 'all');
features1 = [features feat_select];
pr_ds_features=prdataset(features1);

else
if (thresholding)
    a=im_threshold(a,'otsu');
end

          pr_ds_features=prdataset(a);
          
end
end 
