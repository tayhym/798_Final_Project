% test color conversion - rainbow should look like protanopia rainbow 
% after conversion
img = double(imresize(imread('rainbow.png'),0.01));
figure; image(uint8(img));


[l,m,s] = RGB_to_LMS(img(:,:,1),img(:,:,1),img(:,:,1) );
% [ln,mn,sn] = color_blind_sight(1,l,m,s);
ln = l;
mn = m;
sn = s;
[r,g,b] = LMS_to_RGB(ln,mn,sn);
new_img = uint8(cat(3,r,g,b));
figure; image(new_img);

