%Tests
% errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features)

%changing number of data
nrData = [5 10 25];
errors={" " ;"svc" ;"qdc"; "parzen" ;"bpxnc"; "loglc"; "knnc"};

%test varying nr Data using pixel representation with thresholding
for i=1:length(nrData)
    eT=classifiersErrors(nrData(i),true,9,'bicubic',true,false);
    errors=[errors eT(:,2)];
end

%test varying nr Data using pixel representation without thresholding
for i=1:length(nrData)
    eT=classifiersErrors(nrData(i),true,9,'bicubic',false,false);
    errors=[errors eT(:,2)];
end
