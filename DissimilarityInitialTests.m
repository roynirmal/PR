%Dissimilarity representation

a=dataPreprocess(10,'bicubic');
pr_ds=prdataset(a);

%ndiff, sigmoid is terrible, others perform better, the best are minkowski, distance
%and cosine
distmeasures = {'minkowski', 'polynomial','hellinger','distance','cosine','ndiff','sigmoid'};



% Initial tests for scenario 1 and 2
[trn,tst] = gendat(pr_ds,0.1); %Scenario 1
[trn,tst] = gendat(pr_ds,0.01); %Scenario 2

for d =1:length(distmeasures)
    dist = distmeasures{d};
    w=proxm(trn,dist);
    d=trn*w;
    w1=svc(d); %training in the dissimilarity space nmc, fisherc
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
%Scenario 1 - Error is 0.4 for euclidean distance (for fisherc)
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


%% Automated version - all training = representatives

nrData = [10, 200];

for (i=1:length(nrData))
[trn,tst] = gendat(pr_ds,nrData(i)/1000);

errorTable ={"classifier" ;"svc"; "qdc"; "parzen"; "bpxnc"; "loglc"; "knnc"; "treec"; "fisher"};
distmeasures = {'minkowski', 'polynomial','distance','cosine','ndiff','sigmoid'};


for di =1:length(distmeasures)
    dist = distmeasures{di};
    
    w=proxm(trn,dist);
    d=trn*w;
    
    w1=svc(d); %training in the dissimilarity space nmc, fisherc
    e1=testc(tst*w,w1);
    
    w2=qdc(d); %training in the dissimilarity space nmc, fisherc
    e2=testc(tst*w,w2);
    
    w3=parzenc(d); %training in the dissimilarity space nmc, fisherc
    e3=testc(tst*w,w3);
    
    w4=bpxnc(d); %training in the dissimilarity space nmc, fisherc
    e4=testc(tst*w,w4);
    
    w5=loglc(d); %training in the dissimilarity space nmc, fisherc
    e5=testc(tst*w,w5);
    
    w6=knnc(d); %training in the dissimilarity space nmc, fisherc
    e6=testc(tst*w,w6);
    
    w7=treec(d); %training in the dissimilarity space nmc, fisherc
    e7=testc(tst*w,w7);
    
    w8=fisherc(d); %training in the dissimilarity space nmc, fisherc
    e8=testc(tst*w,w8);
    
    errors = {dist; e1; e2; e3; e4; e5; e6; e7; e8};
    errorTable=[errorTable errors];
end

filename = strcat("Dissimilarity",string(nrData(i)));
filename = sprintf('%s.csv', filename);
cell2csv(filename ,errorTable);
errorTable ={"classifier" ;"svc"; "qdc"; "parzen"; "bpxnc"; "loglc"; "knnc"; "treec"; "fisher"};
end


%% Automated version - all training different from representatives - Scenario 1

nrRep = [10, 20,30,40,50];
nrRepMatrix=zeros(5,10);
for rep = 1:length(nrRep)
for cl=1:10
    nrRepMatrix(rep,cl) = nrRep(rep);
end
end
nrData = [200,300,400,500];

errorTable ={"classifier" ;"svc"; "qdc"; "parzen"; "bpxnc"; "loglc"; "knnc"; "fisher"};
distmeasures = {'minkowski', 'polynomial','distance','cosine','ndiff','sigmoid','radial_basis'};
for i=1:length(nrData)
        display(strcat("i ",string(nrData(i))));
for j=1:length(nrRep)  
        display(strcat("j ",string(nrRep(j))));
[trn,tst] = gendat(pr_ds,nrData(i)/1000);


for di =1:length(distmeasures)
    display(strcat("di ",string(di)));
    dist = distmeasures{di};
    
    w=proxm(gendat(trn,nrRepMatrix(j,:)),dist);
    d=trn*w;
    
    w1=svc(d); %training in the dissimilarity space
    e1=testc(tst*w,w1);
    
    w2=qdc(d); %training in the dissimilarity space 
    e2=testc(tst*w,w2);
    
    w3=parzenc(d); %training in the dissimilarity space 
    e3=testc(tst*w,w3);
    
    w4=bpxnc(d); %training in the dissimilarity space 
    e4=testc(tst*w,w4);
    
    w5=loglc(d); %training in the dissimilarity space 
    e5=testc(tst*w,w5);
    
    w6=knnc(d); %training in the dissimilarity space 
    e6=testc(tst*w,w6);
    
    w7=fisherc(d); %training in the dissimilarity space 
    e7=testc(tst*w,w7);
    
    errors = {strcat(" distance",dist," prototypes",string(nrRep(j))," training",string(nrData(i))); e1; e2; e3; e4; e5; e6; e7};
    errorTable=[errorTable errors];
end
end
filename = strcat("DissimilarityWithPrototypes",string(nrData(i)));
filename = sprintf('%s.csv', filename);
cell2csv(filename ,errorTable);
errorTable ={"classifier" ;"svc"; "qdc"; "parzen"; "bpxnc"; "loglc"; "knnc"; "fisher"};
end

%% Automated version - all training different from representatives - Scenario 2 -RUN

nrRep = [10];
nrData = [10];

errorTable ={"classifier" ;"svc"; "qdc"; "parzen"; "bpxnc"; "loglc"; "knnc"; "fisher"};
distmeasures = {'minkowski', 'polynomial','distance','cosine','ndiff','sigmoid','radial_basis'};

nrRepetitions =15;
for di =1:length(distmeasures)
    for i = 1:nrRepetitions 
       
        [trn,tst] = gendat(pr_ds,0.01);
        dist = distmeasures{di};
    
        w=proxm(trn,dist);
        d=trn*w;
    
        w1=svc(d); %training in the dissimilarity space nmc, fisherc
        e1=testc(tst*w,w1);
        
        w2=qdc(d); %training in the dissimilarity space nmc, fisherc
        e2=testc(tst*w,w2);

    
        w3=parzenc(d); %training in the dissimilarity space nmc, fisherc
        e3=testc(tst*w,w3);

    
        w4=bpxnc(d); %training in the dissimilarity space nmc, fisherc
        e4=testc(tst*w,w4);
    
        w5=loglc(d); %training in the dissimilarity space nmc, fisherc
        e5=testc(tst*w,w5);

    
        w6=knnc(d); %training in the dissimilarity space nmc, fisherc
        e6=testc(tst*w,w6);


    
        w7=fisherc(d); %training in the dissimilarity space nmc, fisherc
        e7=testc(tst*w,w7);
    errCol = {strcat(" distance",dist," rep",string(i)," prototypes",string(10)," training",string(10)); e1;e2;e3;e4;e5;e6;e7};
    errorTable=[errorTable errCol];

    end
end
filename = strcat("DissimilarityWithPrototypesScenario2");
filename = sprintf('%s.csv', filename);
cell2csv(filename ,errorTable);

