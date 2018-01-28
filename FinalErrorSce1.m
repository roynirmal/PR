%Cross validation
%Final settings
a=dataPreprocess(8,'bicubic');
pr_ds=prdataset(a);

errorTable ={"classifier" ;"fisherc"};
for rep = 1:15
[trn,tst] = gendat(pr_ds,600/1000);

%Computing distance
dist='distance';
w=proxm(gendat(trn,[600 600 600 600 600 600 600 600 600 600]),dist);
d=trn*w;

w6=fisherc(d); %training in the dissimilarity space 
e6=testc(tst*w,w6);

display("One Repetition Done!");
errCol = {strcat(" distance",dist," rep",string(i)," prototypes",string(400)," training",string(600)); e6};
errorTable=[errorTable errCol];
end




