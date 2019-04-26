function [imghm] = homomorphic_filtering(img)


% Homomorphic filtering -----------------
% convert img to floating-point type
img = im2double(img);
% convert the image to log domain
img = log(1+img);

% DFT  wraparound error solve.
M = 2*size(img,1)+1;
N = 2*size(img,2)+1;
std = 10; % setting a standard deviation for Gaussian to filter out low frequency band 

% the high pass filter
[X,Y] = meshgrid(1:N,1:M);
centerX = ceil(N/2);    % determining centers as it is a 
centerY = ceil(M/2);    % centered filter with low freq. at center
gaussianNumerator = (X - centerX).^2 + (Y - centerY).^2;
H = exp(-gaussianNumerator./(2*std.^2));  % formulae of low pass filter
H = 1 - H;  % subtracting low pass filter from 1, which gives the high pass filter
H = fftshift(H); % rearranging the filter in uncentered format

% high pass filter the log transformed img in the frequency domain
imgf = fft2(img,M,N); % computing FFT of the log transformed image with zero padding
imgout = real(ifft2(H.*imgf)); % apply the high pass filter to compute inverse FFT
imgout = imgout(1:size(img,1),1:size(img,2)); % crop the img back to it's original size

imghm = exp(imgout) - 1; % apply exponential to invert log transform to get the Homomorphic Img

%img = hsv2rgb(img);
%imghm = hsv2rgb(imghm);
%imshowpair(img,imghm,'montage');
end

