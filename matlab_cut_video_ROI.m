%% cut a ROI in a video and write into another video, matlab 2013a
clear

[fn,pa]=uigetfile([cd '\*'])
v=VideoReader([pa fn])
im1=read(v,v.NumberOfFrames/10);
h=figure(1);
imshow(im1,[])
title('use left button on mouse to drag a ROI in the image and then double click left button in the ROI centre to confirm.')
% rect = getrect(h)

hr = imrect;
p= wait(hr)%[XMIN YMIN WIDTH HEIGHT].

p=round(p);

wv=VideoWriter([pa 'cut_' fn])
wv.FrameRate =v.FrameRate;

open(wv)
for k=1:v.NumberOfFrames
    k
    im1=read(v,k);
    im2=im1(p(2):p(2)+p(4),p(1):p(1)+p(3));
    writeVideo(wv,im2);
    
end
close(wv)


