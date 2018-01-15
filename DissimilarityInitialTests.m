%Dissimilarity representation

a=dataPreprocess(10,'bicubic');
pr_ds=prdataset(a);

%ndiff is terrible, others perform better, the best are minkowski, distance
%and cosine
distmeasures = { 'minkowski', 'polynomial','hellinger','sigmoid','distance','cosine'};



% Initial tests for scenario 1 and 2
[trn,tst] = gendat(pr_ds,0.1); %Scenario 1
[trn,tst] = gendat(pr_ds,0.01); %Scenario 2

for d =1:length(distmeasures)
    dist = distmeasures{d};
    w=proxm(trn,dist);
    d=trn*w;
    w1=svc(d); %training in the dissimilarity space
    e1=testc(tst*w,w1);
    display(strcat(dist," has error ",string(e1)));
end

%pca is not helping 
for d =1:length(distmeasures)
    dist = distmeasures{d};
    w=proxm(trn,dist);
    d=trn*w; %proximity matrix, relative to trn set
    u=scalem([],'variance')*pcam([],0.9);
    pca = d*u;
    w1=knnc(d*pca);
    d_test=tst*w;
    pca_test=d_test*pca;
    e1=testc(pca_test,w1);
    display(strcat(dist," has error ",string(e1)));
end

%Initial results:
%Scenario 1 -
%Scenario 2 - Error is 0.23 for cosine distance! (for parzen)

%Pseudo euclidean space - 37steps.com/distools/ -- very bad results, but
%its okay
dt=trn*proxm(trn,'m',1);
ds=tst*proxm(trn,'m',1);
w=dt*pe_em; %compute mapping using the training set
xt=dt*w;
xs=ds*w;
w1=xt*pe_knnc; %used pe_nmc,pe_knnc,pe_parzenc classifier in pe space, but results are above 0.2 for 200 objects
testc(xs,w1);

