clear all;
close all;
addpath(genpath(pwd))
%%%%%%%%%%%%%%%%%%% DFT %%%%%%%%%%%%%%%%%%%
%% Load image  and add noise
% load clean image
img = imread('lena.jpg');
imgR = im2double(img(:,:,1));
imgG = im2double(img(:,:,2));
imgB = im2double(img(:,:,3));

% filter size
r = 20;
% add noise
noise_imgR = add_noise(imgR,r); 
noise_imgG = add_noise(imgG,r); 
noise_imgB = add_noise(imgB,r); 
% noise_imgR = imnoise(imgR,'speckle'); 
% noise_imgG = imnoise(imgG,'speckle'); 
% noise_imgB = imnoise(imgB,'speckle'); 
figure();
subplot(1,2,1),imshow(img);title('original image')
noise_img(:,:,1) = noise_imgR;
noise_img(:,:,2) = noise_imgG;
noise_img(:,:,3) = noise_imgB;
subplot(1,2,2),imshow(noise_img);title('noisy image')
tic
%% Fourier transform the original image
F_oriimgR = DFT2D(imgR);
F_oriimgG = DFT2D(imgG);
F_oriimgB = DFT2D(imgB);
% center shift (You can read Section: Periodicity and Center shifting)
F_orimgR = fftshift(F_oriimgR); 
F_orimgG = fftshift(F_oriimgG); 
F_orimgB = fftshift(F_oriimgB); 
% for displaying the power part by log scale
F_orimg(:,:,1) = F_orimgR;
F_orimg(:,:,2) = F_orimgG;
F_orimg(:,:,3) = F_orimgB;
log_FToriimg = log(1+abs(F_orimg)); 
% normalize the power to 0-1
log_FToriimg = mat2gray(log_FToriimg); 

figure();
subplot(2,2,1),imshow(log_FToriimg);title('log FT original image')

%% Implement Fourier transform on noisy images
F_imgR = DFT2D(noise_imgR);
F_imgG = DFT2D(noise_imgG);
F_imgB = DFT2D(noise_imgB);
F_img(:,:,1) = F_imgR;
F_img(:,:,2) = F_imgG;
F_img(:,:,3) = F_imgB;
F_mag = fftshift(F_img);
log_FTimage = log(1+abs(F_mag));
log_FTimage = mat2gray(log_FTimage);

subplot(2,2,2),imshow(log_FTimage);title('log FT noisy image')

%% Create a filter
% get the size of the input image
[m, n, z] = size(img); 
% create a rectangular filter at center
filter = zeros(m,n);
filter(r:m-r,r:n-r) =1;

subplot(2,2,3),imshow(filter,[]);title('filter')

%% Filter out the denoised image
% FT image .* the filter
fil_img = F_mag.*filter; 

log_fil_img = log(1+abs(fil_img));
log_fil_img = mat2gray(log_fil_img);

subplot(2,2,4),imshow(log_fil_img);title('after filter FT image')

%% Inverse Fourier transform
% unshift
fil_img = ifftshift(fil_img); 
% display the denoised image
resultR = real(IDFT2D(fil_img(:,:,1))); 
resultG = real(IDFT2D(fil_img(:,:,2))); 
resultB = real(IDFT2D(fil_img(:,:,3))); 
result(:,:,1) = resultR;
result(:,:,2) = resultG;
result(:,:,3) = resultB;
toc

figure();
subplot(1,2,1),imshow(noise_img);title('noisy image')
subplot(1,2,2);imshow(result,[]);title('denoised image')
original = im2double(img);
err = immse(result, original);
psnr_ = psnr(result, original);

%%%%%%%%%%%%%%%%%%%% Total Variation %%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = imread('lena.jpg');
img = im2double(img);

% filter size
r = 20;
% add noise
noise_img = add_noise(img,r); 

gray_img = rgb2gray(img);
gray_noise_img = rgb2gray(noise_img);
%% add noise
figure()
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img);title('noisy image')
err1 = immse(gray_noise_img, gray_img);
psnr1 = psnr(gray_noise_img, gray_img);
tic
denoisedI=TVdenoise(gray_noise_img, 1.4, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img);title('noisy image')
subplot(1,2,2),imshow(denoisedI);title('Denoised image')
err2 = immse(denoisedI, gray_img);
psnr2 = psnr(denoisedI, gray_img);
%% speckle
gray_noise_img_2 = add_speckle_noise(gray_img, 0.05);

figure()
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img_2);title('noisy image')
err3 = immse(gray_noise_img_2, gray_img);
psnr3 = psnr(gray_noise_img_2, gray_img);
tic
denoisedII=TVdenoise(gray_noise_img_2, 1.4, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img_2);title('noisy image')
subplot(1,2,2),imshow(denoisedII);title('Denoised image')
err4 = immse(denoisedII, gray_noise_img_2);
psnr4 = psnr(denoisedII, gray_noise_img_2);
%% Gaussian
gray_noise_img_3 = addGaussianNoise(gray_img, 0, 0.05);
figure()
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img_3);title('noisy image')
err5 = immse(gray_noise_img_3, gray_img);
psnr5 = psnr(gray_noise_img_3, gray_img);
tic
denoisedII=TVdenoise(gray_noise_img_3, 1.4, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img_3);title('noisy image')
subplot(1,2,2),imshow(denoisedII);title('Denoised image')
err6 = immse(denoisedII, gray_noise_img_3);
psnr6 = psnr(denoisedII, gray_noise_img_3);
%% salt and pepper
gray_noise_img_4 = add_salt_and_pepper_noise(gray_img, 0.1);
figure()
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img_4);title('noisy image')
err7 = immse(gray_noise_img_4, gray_img);
psnr7 = psnr(gray_noise_img_4, gray_img);
tic
denoisedIII=TVdenoise(gray_noise_img_4, 2, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img_4);title('noisy image')
subplot(1,2,2),imshow(denoisedIII);title('Denoised image')
err8 = immse(denoisedIII, gray_noise_img_4);
psnr8 = psnr(denoisedIII, gray_noise_img_4);
%% poisson
gray_noise_img_5 = add_poisson_noise(gray_img, 0.8);
figure(9);
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img_5);title('noisy image')
err9 = immse(gray_noise_img_5, gray_img);
psnr9 = psnr(gray_noise_img_5, gray_img);
tic
denoisedIV=TVdenoise(gray_noise_img_5, 2, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img_5);title('noisy image')
subplot(1,2,2),imshow(denoisedIV);title('Denoised image')
err10 = immse(denoisedIV, gray_noise_img_5);
psnr10 = psnr(denoisedIV, gray_noise_img_5);
%% uniform
gray_noise_img_6 = add_uniform_noise(gray_img, 0.5);
figure();
subplot(1,2,1),imshow(gray_img);title('original image')
subplot(1,2,2),imshow(gray_noise_img_6);title('noisy image')
err11 = immse(gray_noise_img_6, gray_img);
psnr11 = psnr(gray_noise_img_6, gray_img);
tic
denoisedV=TVdenoise(gray_noise_img_6, 2, 600);
toc
figure()
subplot(1,2,1),imshow(gray_noise_img_6);title('noisy image')
subplot(1,2,2),imshow(denoisedV);title('Denoised image')
err12 = immse(denoisedV, gray_noise_img_6);
psnr12 = psnr(denoisedV, gray_noise_img_6);
