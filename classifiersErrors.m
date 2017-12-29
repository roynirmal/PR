% PR assignment 
function errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding)
%preprocessing : resizing all images to same square dimensions
a = prnist([0:9],[1:(1000/nrTrObjectsPerClass):1000]);
if (resizing)
    preproc = im_box([],0,1)*im_resize([],[resizeSize resizeSize],resizeMethod)*im_box([],1,0); %resize method needs tuning
    a = a*preproc;
end

if (thresholding)
    a=im_threshold(a,'otsu');
end
pr_ds=prdataset(a);


%Training with several classifiers
%Splitting data - 80% train and 20 % test
[trn,tst] = gendat(pr_ds,0.8);
w1 = svc(trn);
e1=testc(tst, w1);

w2 = qdc(trn);
e2=testc(tst,w2);

w3 = parzenc(trn);
e3=testc(tst, w3);

w4 = loglc(trn); %neural networks package was not working on my laptop so i changed it. sorry!Barbara
e4=testc(tst,w4);

w5 = loglc(trn); 
e5=testc(tst, w5);

w6 = knnc(trn);
e6=testc(tst,w6);

% using features
features = im_features(a, a, 'all');
pr_ds_features=prdataset(features);
[sel,r] =featself(pr_ds_features,'maha-s',20);

[trn,tst] = gendat(pr_ds_features*sel,0.8);
w1 = svc(trn);
e1F=testc(tst, w1);

w2 = qdc(trn);
e2F=testc(tst,w2);

w3 = parzenc(trn);
e3F=testc(tst, w3);

w4 = loglc(trn); %neural networks package was not working on my laptop so i changed it. sorry!Barbara
e4F=testc(tst,w4);

w5 = loglc(trn); 
e5F=testc(tst, w5);

w6 = knnc(trn);
e6F=testc(tst,w6);

%Producing output error table
errorTable=cell(7,3);
class =[strcat("nrTrObjectsPerClass:",string(nrTrObjectsPerClass)," resizing:",string(resizing)," resizeSize:",string(resizeSize)," resizeMethod:",string(resizeMethod)," thresholding:",string(thresholding)) "svc" "qdc" "parzen" "bpxnc" "loglc" "knnc"];
errors = [e1 e2 e3 e4 e5 e6];
errorsF = [e1F e2F e3F e4F e5F e6F];
for i=1:7
    errorTable{i,1}=class(i);
    if i>1
        errorTable{i,2}=errors(i-1);
        errorTable{i,3}=errorsF(i-1);
    end
end
end