% PR assignment 
function [errorTable] = classifiersErrorsFeaturesp2(resizeSize, resizeMethod, pr_ds_features, trn, tst, nrTrObjectsPerClass,thresholding,features, nrFeat,featselect,pca)
%preprocessing : resizing all images to same square dimensions


if (not(features))

%Training with several classifiers
%Splitting data - 80% train and 20 % test
%[trn,tst] = gendat(pr_ds,nrTrObjectsPerClass/1000);

% if (featselect =="featselp")
%     [sel,r] = featselp(pr_ds,'maha-s',nrFeat);
%     [trn,tst] = gendat(pr_ds*sel,nrTrObjectsPerClass/1000);
% elseif (featselect == "featselo")
%     [sel,r] =featselo(pr_ds,'maha-s',nrFeat);
%     [trn,tst] = gendat(pr_ds*sel,nrTrObjectsPerClass/1000);
% else   
% [trn,tst] = gendat(pr_ds,nrTrObjectsPerClass/1000);
% end

if (pca ~= false)
  sel=scalem([],'variance')*pcam([],pca);
  pcaTrained=trn*sel;
  trn = trn*pcaTrained;
  tst = tst*pcaTrained;
end

    w1 = svc(trn);  
   	e1 = testc(tst, w1);

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

    w7 = fisherc(trn);
    e7 = testc(tst, w7);
%     w7 = treec(trn);
%     e7 = testc(tst, w7);
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





if (pca ~= false)
    
    [w, n] = pcam(trn,pca);
 pcaTrained=scalem(trn,'variance')*w;
%  pcaTrained=trn*sel;
  trn = trn*pcaTrained;
  tst = tst*pcaTrained;

else
    n=0;
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


w7 = fisherc(trn);
e7 = testc(tst, w7);
end

%Producing output error table
errorTable=cell(8,2);
class =["svc" "qdc" "parzen" "bpxnc" "loglc" "knnc" "fisherc"];
errors = [strcat( " nrTrObjectsPerClass:",string(nrTrObjectsPerClass)," resizeSize:",string(resizeSize)," resizeMethod:",string(resizeMethod)," thresholding:",string(thresholding)," nrFeatures:",string(nrFeat)," featSelect:",string(featselect)," pca:",string(pca), " pcadimension:", string(n)) e1 e2 e3 e4 e5 e6 e7];
for i=1:8
            errorTable{i,2}=errors(i);
    if i>1
       errorTable{i,1}=class(i-1); 
    end
end
end