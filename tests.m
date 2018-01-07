%Tests
% errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features)

%changing number of data
nrData = [10 200];
errors={" " ;"svc" ;"qdc"; "parzen" ;"bpxnc"; "loglc"; "knnc"};
feat = ["hog", "proj", "chain"];

% %test varying nr Data using pixel representation with thresholding
% for i=1:length(nrData)
%     for j = 1:size(feat,2)
%         combi =  combntns(feat, j);
%         for k = 1:size(combi,1)
%             
%             eT=classifiersErrors(nrData(i),true,9,'bicubic',true,false,combi(k,:));
%             errors=[errors eT(:,2)];
%         end
%     end
% end
% 
% %test varying nr Data using pixel representation without thresholding
% for i=1:length(nrData)
%  for j = 1:size(feat,2)
%         combi =  combntns(feat, j);
%         for k = 1:size(combi,1)
%             
%             eT=classifiersErrors(nrData(i),true,9,'bicubic',false,false,combi(k,:));
%             errors=[errors eT(:,2)];
%         end
%     end
% end

% % this part is where we combine our features with the features from
% % prtools and do feature selection
% %test varying nr Data using pixel representation with thresholding
%  for i=1:length(nrData)
%             eT=classifiersErrors(nrData(i),true,9,'bicubic',true,true,[]);
%             errors=[errors eT(:,2)];
%  end
 % %test varying nr Data using pixel representation without thresholding
  for i=1:length(nrData)
            eT=classifiersErrors(nrData(i),true,9,'bicubic',false,true,[]);
            errors=[errors eT(:,2)];
 end
%Exporting to CSV to make plots in R.
cell2csv("testsPR.csv",errors);
