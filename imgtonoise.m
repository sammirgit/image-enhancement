newImageRGB = imread('roseimg.jpg');
newImageHSV = rgb2hsv(newImageRGB);
H = newImageHSV(:,:,1);
S = newImageHSV(:,:,2);
V = newImageHSV(:,:,3);
noise=imnoise(newImageRGB,'salt & pepper',.11);
%noise=imnoise(V,'salt & pepper',.75);

%noiseimg = cat(3, H, S, V);
%noiseimg = hsv2rgb(noiseimg);
imwrite(noise,'noisyrose.jpg');