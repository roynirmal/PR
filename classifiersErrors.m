% PR assignment 
function errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features, nrFeat,featselect,pca)
%preprocessing : resizing all images to same square dimensions
a = prnist([0:9],[1:100:1000]);
if (resizing)
    preproc = im_box([],0,1)*im_resize([],[resizeSize resizeSize],resizeMethod)*im_box([],1,0); %resize method needs tuning
    a = a*preproc;
end

if (thresholding)
    a=im_threshold(a,'otsu');
end


if (not(features))
    pr_ds=prdataset(a);
%Training with several classifiers
%Splitting data - 80% train and 20 % test
[trn,tst] = gendat(pr_ds,nrTrObjectsPerClass/1000);
w1 = svc(trn);
e1=testc(tst, w1);

w2 = qdc(trn);
e2=testc(tst,w2);

w3 = parzenc(trn);
e3=testc(tst, w3);

w4 = bpxnc(trn, [10 10 10]); 
e4=testc(tst,w4);

w5 = loglc(trn); 
e5=testc(tst, w5);

w6 = knnc(trn);
e6=testc(tst,w6);
 
else 
% % using features
% %this part to be used when we have our feautures
% %automatic feature select


%        feat_select = [];
%        if (ismember("hog", featcombi))
%            %write code for hog
%            feat_hog=[ 1 2 3];
%             feat_select = [feat_select feat_hog];
%        end
%        if (ismember("proj", featcombi))
%            %write code for proj
%            feat_proh= [ 5 6 7];
%             feat_select = [feat_select feat_proj];
%        end
%        if (ismember("chain", featcombi))
%            %write code for chain
%            feat_chain = [8 9];
%             feat_select = [feat_select feat_chain];
%        end
%        [trn,tst] = gendat(feat_select,0.8);
%         w1 = svc(trn);
%         e1=testc(tst, w1);
% 
%         w2 = qdc(trn);
%         e2=testc(tst,w2);
% 
%         w3 = parzenc(trn);
%         e3=testc(tst, w3);
% 
%         w4 = loglc(trn); %neural networks package was not working on my laptop so I changed it. sorry!Barbara
%         e4=testc(tst,w4);
% 
%         w5 = loglc(trn); 
%         e5=testc(tst, w5);
% 
%         w6 = knnc(trn);
%         e6=testc(tst,w6);
%        
%        
       
% % manual feature select which uses featureSelect functio    
% pr_ds_feat = featureSelect(true, true, true);
% [trn,tst] = gendat(pr_ds_feat,0.8);
% w1 = svc(trn);
% e1=testc(tst, w1);
% 
% w2 = qdc(trn);
% e2=testc(tst,w2);
% 
% w3 = parzenc(trn);
% e3=testc(tst, w3);
% 
% w4 = bp(trn); %neural networks package was not working on my laptop so i changed it. sorry!Barbara
% e4=testc(tst,w4);
% 
% w5 = loglc(trn); 
% e5=testc(tst, w5);
% 
% w6 = knnc(trn);
% e6=testc(tst,w6);


for k = 1 : nrTrObjectsPerClass*10
    
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
label = genlab([nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass nrTrObjectsPerClass],v);
feat_select = prdataset(double(feat_select), label);
features = im_features(a, a, 'all');
features1 = [features feat_select];
pr_ds_features=prdataset(features1);


if (featselect =="featselp")
    [sel,r] = featselp(pr_ds_features,'maha-s',nrFeat);
    [trn,tst] = gendat(pr_ds_features*sel,nrTrObjectsPerClass/1000);
elseif (featselect == "featselo")
    [sel,r] =featselo(pr_ds_features,'maha-s',nrFeat);
    [trn,tst] = gendat(pr_ds_features*sel,nrTrObjectsPerClass/1000);
else   
[trn,tst] = gendat(pr_ds_features,nrTrObjectsPerClass/1000);
end

if (pca ~= false)
  sel=scalem([],'variance')*pcam([],pca);
  pcaTrained=trn*sel;
  trn = trn*pcaTrained;
  tst = tst*pcaTrained;
end

w1 = svc(trn); 
e1=testc(tst, w1);

w2 = qdc(trn);
e2=testc(tst,w2);

w3 = parzenc(trn);
e3=testc(tst, w3);

w4 = bpxnc(trn, [10 10 10]); 
e4=testc(tst,w4);

w5 = loglc(trn); 
e5=testc(tst, w5);

w6 = knnc(trn);
e6=testc(tst,w6);
end

%Producing output error table
errorTable=cell(7,2);
class =["svc" "qdc" "parzen" "bpxnc" "loglc" "knnc"];
errors = [strcat( " nrTrObjectsPerClass:",string(nrTrObjectsPerClass)," resizing:",string(resizing)," resizeSize:",string(resizeSize)," resizeMethod:",string(resizeMethod)," thresholding:",string(thresholding)," nrFeatures",string(nrFeat)," featSelect",string(featselect)," pca",string(pca)) e1 e2 e3 e4 e5 e6];
for i=1:7
    errorTable{i,2}=errors(i);
    if i>1
       errorTable{i,1}=class(i-1); 
    end
end
end