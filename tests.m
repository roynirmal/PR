%Tests
% errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features)

%changing number of data

errors={" " ;"svc" ;"qdc"; "parzen" ;"bpxnc"; "loglc"; "knnc"; "treec"};
% feat = ["hog", "proj", "chain"];
% nrData = [10, 200, 300, 500, 750, 900];
% resizeSize = [10, 16, 20]; 
% resizeMethod = {'bicubic'; 'bilinear'}
%     % 'nearest'; 'box'; 'triangle'; 'cubic'};
% % features = [ True, False];
% nrFeat = [5, 20, 50, 100];
% featselect = {"featselp"; "featselo"; "none"};
pca = [false, 0.95, 0.9, 0.85, 0.8] ;
% 
nrData = [5, 10];
resizeSize = [10]; 
resizeMethod = {'bicubic'};
% features = [ True, False];
nrFeat = [5, 10];
featselect = {"featselp", "none"};
pca = [0.95] ;


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
 
%   for i=1:length(nrData)
%             eT=classifiersErrors(nrData(i),true,9,'bicubic',false,true,[]);
%             errors=[errors eT(:,2)];
%   end
  
  for i =1:length(resizeSize)
      for j = 1:length(resizeMethod)
          a = dataPreprocess(resizeSize(i), resizeMethod{j});
          pr_ds_features = featCoding(a, resizeSize);
          for k = 1:length(nrData)
 
                      for n =1:length(featselect)
                          if(featselect{n} == "none")
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, pr_ds_features, nrData(k), false, true, 0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              eT=classifiersErrors(resizeSize(i), resizeMethod(j), a, nrData(k), false, false, 0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              eT=classifiersErrors(resizeSize(i), resizeMethod(j), a, nrData(k), true, false, 0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              break;
                          end
                        for m = 1:length(nrFeat)
                          for o = 1:length(pca)
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, pr_ds_features, nrData(k), false, true, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)]; 
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a, nrData(k), false, false, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)]; 
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a, nrData(k), true, false, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)]; 
                              
                          end
                      end
                  end
          end
          filename = strcat(string(resizeSize(i)), string(resizeMethod{j}));
          filename = sprintf('%s.csv', filename);
          cell2csv(filename ,errors);
          display("File Printed");
      end
  end
  
                              
%Exporting to CSV to make plots in R.
% cell2csv("testsPR.csv",errors);
% cell2csv(strcat(string(resizeSize(i)), string(resizeMethod(j)),".csv"),errors);
