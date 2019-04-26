 
 newImageRGB = imread('lowlight_21.jpg');

figure(1);
imshow(newImageRGB);
%{
AInv = imcomplement(newImageRGB);
figure(2);
imshow(AInv);

BInv = imreducehaze(AInv);
figure(3);
imshow(BInv);


B = imcomplement(BInv);
figure(4);
imshow(B);

%}
%{
BInv = imreducehaze(AInv, 'Method','approx','ContrastEnhancement','boost');
BImp = imcomplement(BInv);
figure, montage({A, BImp});
%}
%}
%newImageHSV = rgb2hsv(B);
newImageHSV = rgb2hsv(newImageRGB);

H = newImageHSV(:,:,1);
S = newImageHSV(:,:,2);
V = newImageHSV(:,:,3);



%figure(1);
%imshow(V);
     
% convert image to gray level
     %grayImage = rgb2gray(newImageRGB);
     grayImage = V;
     %figure(2);
     %imshow(newImageRGB);
     %imshow(grayImage);

    %testing zone
%H = wiener2(H,[5 5]);

     % applying wiener filter ot image.
     afterWiener = wiener2(grayImage,[5 5]);
     %afterWiener = wiener2(newImageRGB,[5 5]);
     %figure, imshow(afterWiener);

 
%noise=imnoise(img,'salt & pepper',.15);
new=medfilt2(afterWiener,[5 5]);
figure(5);
imshow(new);
%H = medfilt2(H,[4 4]);
%S = medfilt2(S,[4 4]);

     V=new;
     HSVafterwiener = cat(3, H, S, V);
     afterhsv = hsv2rgb(HSVafterwiener);
     %figure(6);
     %imshow(afterhsv);

%%%%%
AInv = imcomplement(afterhsv);
figure(2);

imshow(AInv);

BInv = imreducehaze(AInv);
figure(3);
imshow(BInv);


B = imcomplement(BInv);
figure(4);
imshow(B);

%%%%%
     
     
%homomorphic

imghm = homomorphic_filtering(B);
figure(7);
imshowpair(newImageRGB,imghm,'montage');
%imshow(imghm);
%figure(4);



%%%%%%%


%guided_work


original = imghm;   %reference(guidance) image for guided filter
 %original = double(original);
% original = original / 255;

%p=afterhsv;
p = B;     %guided image 
%p=rgb2gray(p);
p = double(p);
%p = p/255;

%p = original;
r = 4;
eps = 0.009^2; % try eps=0.1^2, 0.2^2, 0.4^2

tic;
q = guidedfilter(original, p, r, eps);
toc;
%k = imresize(q,[1920 480]);

s = 4; % sampling ratio
tic;
q_sub = improved(original, p, r, eps, s);
toc;


%figure();
%imshow([original, q, q_sub], [0, 1]);

%imshow(original);
figure(8);
imshow(q);
figure(9);
imshow(q_sub);


%%%%

%q_sub = log(1+q_sub);


afterretinex = retinex_frankle_mccann(q_sub,5);
V=afterretinex;


HSVafterwiener = cat(3, H, S, V);
afterhsv = hsv2rgb(HSVafterwiener);

figure(10);
imshow(afterhsv);

%imshowpair(newImageRGB,V,'montage');

%%%%


