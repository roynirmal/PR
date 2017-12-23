files = dir('*.mat');
c = 0;
p=0;
for i=1:length(files)
    eval(['load ' files(i).name ]);
    %eval (['load ' b.files(i)]);%
    for j=1:200
    im = imresize(imcells{j},[50 50], 'box');
    p=p+1;
    dat(p,: ) = reshape(im',1,[]);
    
    end
    c=c+1;
end
    
    