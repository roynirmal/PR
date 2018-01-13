%Tests
% errorTable = classifiersErrors(nrTrObjectsPerClass,resizing,resizeSize,resizeMethod,thresholding,features)
warning off;
%changing number of data
display("Processing initial values");
errors={" " ;"svc" ;"qdc"; "parzen" ;"bpxnc"; "loglc"; "knnc"; "treec"};
%feat = ["hog", "proj", "chain"];
nrData = [10,200,500];
resizeSize = [10, 16]; 
resizeMethod =  {'nearest'; 'box'};
    % 'nearest'; 'box'; 'triangle'; 'cubic'};
% features = [ True, False];
nrFeat = [5, 20, 50];
featselect = {"featselp"; "none"};
pca = [false, 0.95, 0.8] ;


% % 
% nrData = [5, 10];
% resizeSize = [10]; 
% resizeMethod = {'bicubic'};
% % features = [ True, False];
% nrFeat = [5, 10];
% featselect = {"featselp", "none"};
% pca = [0.95] ;


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
          display("Processing data");
          a = dataPreprocess(resizeSize(i), resizeMethod{j});
          display("Retrieving features");
          pr_ds_features = featCoding(a, resizeSize(i), true, false);
          display("All features retrieved");
          for k = 1:length(nrData)
                display("Trying a total of some objects");
                      for n =1:length(featselect)
                          if(featselect{n} == "none")
                               [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                             eT=classifiersErrors(resizeSize(i), resizeMethod{j}, pr_ds_features, trn, tst, nrData(k), false, true, 0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              break;
                          end
                        for m = 1:length(nrFeat)
                            [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                            display("1st loop feature Reduce");
                          for o = 1:length(pca)
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, pr_ds_features, trn, tst,  nrData(k), false, true, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)];
                              
                          end
                      end
                      end
          filename = strcat("data",string(nrData(k)),"resizeSize",string(resizeSize(i)),"resizeMethod", string(resizeMethod{j}), "featureTrueThreshFale");
          filename = sprintf('%s.csv', filename);
          cell2csv(filename ,errors);
          display(strcat(string(nrData(k)),"Objects - File Printed"));
          end
      end
  end
  
  
   for i =1:length(resizeSize)
      for j = 1:length(resizeMethod)
          a = dataPreprocess(resizeSize(i), resizeMethod{j});
          pr_ds_features = featCoding(a, resizeSize(i), false, true);
          for k = 1:length(nrData)
 
                      for n =1:length(featselect)
                          if(featselect{n} == "none")
                              [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a, trn, tst,  nrData(k),  true, false,0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              
                              break;
                          end
                        for m = 1:length(nrFeat)
                            [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                            display("2nd loop feature Reduce");
                          for o = 1:length(pca)
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a, trn, tst , nrData(k),  true, false, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)]; 
                              
                          end
                      end
                      end
          filename = strcat("data",string(nrData(k)),"resizeSize",string(resizeSize(i)),"resizeMethod", string(resizeMethod{j}), "featureFalseThreshTrue");
          filename = sprintf('%s.csv', filename);
          cell2csv(filename ,errors);
          display("File Printed");            
          end
      end
   end
  
   for i =1:length(resizeSize)
      for j = 1:length(resizeMethod)
          a = dataPreprocess(resizeSize(i), resizeMethod{j});
          pr_ds_features = featCoding(a, resizeSize(i), false, false);
          for k = 1:length(nrData)
 
                      for n =1:length(featselect)
                          if(featselect{n} == "none")
                                [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a,  trn, tst,nrData(k), false, false,0,featselect{n}, 0);
                              errors=[errors eT(:,2)]; 
                              break;
                          end
                        for m = 1:length(nrFeat)
                            [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{n}, nrData(k));
                            display("3nd loop feature Reduce");
                          for o = 1:length(pca)
                              eT=classifiersErrors(resizeSize(i), resizeMethod{j}, a, trn, tst,  nrData(k), false, false, nrFeat(m),featselect{n}, pca(o));
                              errors=[errors eT(:,2)]; 
                              
                          end
                      end
                      end
          filename = strcat("data",string(nrData(k)),"resizeSize",string(resizeSize(i)),"resizeMethod", string(resizeMethod{j}),"featureFalseThreshFalse");
          filename = sprintf('%s.csv', filename);
          cell2csv(filename ,errors);
          display("File Printed");
          end
      end
  end
                              
%Exporting to CSV to make plots in R.
% cell2csv("testsPR.csv",errors);
% cell2csv(strcat(string(resizeSize(i)), string(resizeMethod(j)),".csv"),errors);
