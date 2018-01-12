function a = dataPreprocess(resizeSize, resizeMethod)

a = prnist([0:9],[1:1:1000]);

preproc = im_box([],0,1)*im_resize([],[resizeSize resizeSize],resizeMethod)*im_box([],1,0); %resize method needs tuning
a = a*preproc;
end
