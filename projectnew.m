newImageRGB = imread('lowlight_21.jpg');
newImageHSV = rgb2hsv(newImageRGB);
H = newImageHSV(:,:,1);
S = newImageHSV(:,:,2);
V = newImageHSV(:,:,3);
  
% convert image to gray level
grayImage = V;
grayImage1 = H;
grayImage2 = S;

% applying wiener filter ot image.
afterWiener = wiener2(grayImage,[5 5]);
%afterWiener1 = wiener2(grayImage1,[5 5],.11);
%afterWiener2 = wiener2(grayImage2,[5 5],.11);
grayImage = afterWiener;

%noise=imnoise(img,'salt & pepper',.15);
new=medfilt2(grayImage,[5 5]);
%new = imsharpen(new);
%new = adapthisteq(new);
V=new;
%H = afterWiener1;
%S = afterWiener2;
HSVaftermed = cat(3, H, S, V);
afterhsv = hsv2rgb(HSVaftermed);

AInv = imcomplement(afterhsv);
BInv = imreducehaze(AInv);
B = imcomplement(BInv);

imghsv = rgb2hsv(B);
H = imghsv(:,:,1);
S = imghsv(:,:,2);
V = imghsv(:,:,3);
%homomorphic

imghm = homomorphic_filtering(V);
%%%%%%%

%guided_work

original = imghm;    %reference(guidance) image for guided filter 

p = V;             %guided image 

r = 4;
eps = 0.009^2; % try eps=0.1^2, 0.2^2, 0.4^2

tic;
q = guidedfilter(original, p, r, eps);
toc;

s = 4; % sampling ratio
tic;
q_sub = improved(original, p, r, eps, s);
toc;
q_sub = log(1+q_sub);

afterretinex = retinex_frankle_mccann(q_sub,5);
V = afterretinex;

%S = retinex_frankle_mccann(S,5);
%H = retinex_frankle_mccann(H,5);

%H = filter2(fspecial('average',3),H);
%S = filter2(fspecial('average',3),S);
V = filter2(fspecial('average',3),V);
%H = medfilt2(H);
%S = medfilt2(S);
V = medfilt2(V);
%H = imsharpen(H);
%S = imsharpen(S);
V = imsharpen(V);
HSVafterwiener = cat(3, H, S, V);
afterhsv = hsv2rgb(HSVafterwiener);
afterhsv = afterhsv * 255;
afterhsv = uint8(afterhsv);
%afterhsv = imsharpen(afterhsv);
figure(4);
imshowpair(newImageRGB,afterhsv,'montage');

%-------------------------INPUT calculate mean, std. dev, entropy--------------
imgmean = mean2(newImageRGB);
imgstddev = std2(newImageRGB);
imgentropy = entropy(newImageRGB);

fprintf('Mean : ');
disp(imgmean);
fprintf('Std. deviation: ');
disp(imgstddev)
fprintf('Entropy: ');
disp(imgentropy);

%-------------------------OUTPUT calculate mean, std. dev, entropy--------------
imgmean = mean2(afterhsv);
imgstddev = std2(afterhsv);
imgentropy = entropy(afterhsv);

fprintf('Mean : ');
disp(imgmean);
fprintf('Std. deviation: ');
disp(imgstddev)
fprintf('Entropy: ');
disp(imgentropy);


[peaksnr, snr] = psnr(afterhsv, newImageRGB);
fprintf('Peak-SNR: %0.4f\n', peaksnr);
fprintf('SNR: %0.4f\n', snr);