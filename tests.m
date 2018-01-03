    %Tests
% errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features)

%changing number of data
nrData = [5 10 25];
errors={" " ;"svc" ;"qdc"; "parzen" ;"bpxnc"; "loglc"; "knnc"};
feat = ["hog", "proj", "chain"];

%test varying nr Data using pixel representation with thresholding
for i=1:length(nrData)
    for j = 1:size(feat,2)
        combi =  combntns(feat, j);
        for k = 1:size(combi,1)
            
            eT=classifiersErrors(nrData(i),true,9,'bicubic',true,false,combi(k,:));
            errors=[errors eT(:,2)];
        end
    end
end

%test varying nr Data using pixel representation without thresholding
for i=1:length(nrData)
 for j = 1:size(feat,2)
        combi =  combntns(feat, j);
        for k = 1:size(combi,1)
            
            eT=classifiersErrors(nrData(i),true,9,'bicubic',false,false,combi(k,:));
            errors=[errors eT(:,2)];
        end
    end
end
