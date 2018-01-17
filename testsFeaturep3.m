warning off;
%changing number of data
display('Processing initial values');
errors={' ' ;'rbsvc';'svc*fishercc';' pksvc';'svc'};
% 
nrData = [10];
resizeSize =  16; 
resizeMethod =  {'bicubic'};
    
 nrFeat = [50   ];
 featselect = {'featselp'};
pca = [ 0.95] ;

% nrData = [10];
% resizeSize =  16; 
% resizeMethod =  {'bicubic'};
%     
%  
%  nrFeat = [5];
%  featselect = {'featselp'};
% pca = [ 0.95] ;



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
   display('Processing data');
 a = dataPreprocess(resizeSize, resizeMethod{1});
  display('Retrieving features');
  pr_ds_features = featCoding(a, resizeSize, true, false);
   display('All features retrieved');
 
j=1;
          for k = 1:length(nrData)
                display('Trying a total of some objects');
                        for m = 1:length(nrFeat)
                            [trn, tst] = featureReduce(pr_ds_features, nrFeat(m), featselect{1}, nrData(k));
                            display('1st loop feature Reduce');
                          for o = 1:length(pca)
                              eT =classifiersErrorsFeaturessp3(resizeSize, resizeMethod{1}, pr_ds_features, trn, tst,  nrData(k), false, true, nrFeat(m),featselect{1}, pca(o));
                              errors=[errors eT(:,2)];
                              
                          end
                      end

          filename = strcat('data',string(nrData(k)),'resizeSize',string(resizeSize),'resizeMethod', string(resizeMethod{1}), 'featureTrueThreshFale', 'optimizeSVC');
          filename = sprintf('%s.csv', filename);
          cell2csv(filename ,errors);
          display(strcat(string(nrData(k)),'Objects - File Printed'));
          errors={' ' ;'rbsvc';'svc*fishercc';' pksvc'; 'svc'};
          end
    