%Tests
% classifiersErrors (nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding)
%changing number of data
nrData = [5 10 25]

for i=1:length(nrData)
    errTabclassifiersErrors(nrData(i),true,9,'bicubic',true);
    classifiersErrors(nrData(i),true,9,'bicubic',false);
    classifiersErrors(nrData(i),false,9,'bicubic',true);
    classifiersErrors(nrData(i),false,9,'bicubic',false);
end