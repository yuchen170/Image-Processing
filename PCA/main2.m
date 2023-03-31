%% PCA algorithm Group 10 

%% Part 2
clc
close all

rgb_img = imread('corgi.jpg');

X = double(reshape(rgb_img,[],3)');
L = size(X,2);

d = mean(X,2);
X_centered = X - repmat(d,1,L);
Cov = X_centered*X_centered'/(L-1);
[V, D] = eig(Cov);
[~, idx] = sort(diag(D), 'descend');
V = V(:,idx);
Y = V(:,1:2)' * X_centered;
Xc = V(:,1:2) * Y + repmat(d,1,L);
Xc = reshape(Xc', size(rgb_img));

%% Plot the original image
figure(1);
imshow(rgb_img);
title('RGB True-Color Composition of X');

%% Plot the two band images in Y as two gray-scale images
% reshape the matrix Y into 3D array in order to display as an image
Y_img = reshape(Y', [size(rgb_img,1) size(rgb_img,2) 2]);
figure(2);
imshow(Y_img(:,:,1), []);
title('Band 1');
figure(3);
imshow(Y_img(:,:,2), []);
title('Band 2');

%% Plot the reconstructed image
figure(4);
imshow(uint8(Xc));
title('RGB True-Color Composition of Xc');