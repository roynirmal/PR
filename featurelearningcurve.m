 a = dataPreprocess(16, 'bicubic');
 pr_ds_features = featCoding(a, 16, true, false);
  [sel,r] = featselp(pr_ds_features,'maha-s',100);
    
% 
 trdata= [200,250, 300, 350, 400, 450, 500,550,  600, 650, 700, 750,800, 850, 900];
%  trdata= [200, 400, 500,  600, 700,800, 900];
%trdata = 600;
 for i = 1: length(trdata)
     temperr = 0 ;
     for j = 1:10
     [trn,tst] = gendat(pr_ds_features*sel,nrTrObjectsPerClass/1000);
      [w, n] = pcam(trn,0.95);
 pcaTrained=scalem(trn,'variance')*w;
%pcaTrained=trn*sel;
trn = trn*pcaTrained;
  tst = tst*pcaTrained;
  
%   f = parzenc(trn);
%   errc= testc(tst,f);
    f = fisherc(trn);
  errc= testc(tst,f);
  temperr = temperr + errc;
     end    
  error(i) = temperr/j;
  display("one dataset done ");
 end
 
plot(trdata, error)

%title('Learning Curve - ParzenC')
xlabel('Training data')
ylabel('Error')



