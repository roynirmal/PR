function [trn, tst ] = featureReduce(pr_ds_features, nrFeat, featselect, nrTrObjectsPerClass)

if (featselect =="featselp")
    [sel,r] = featselp(pr_ds_features,'maha-s',nrFeat);
    [trn,tst] = gendat(pr_ds_features*sel,nrTrObjectsPerClass/1000);
elseif (featselect == "featselo")
    [sel,r] =featselo(pr_ds_features,'maha-s',nrFeat);
    [trn,tst] = gendat(pr_ds_features*sel,nrTrObjectsPerClass/1000);
else   
[trn,tst] = gendat(pr_ds_features,nrTrObjectsPerClass/1000);
end