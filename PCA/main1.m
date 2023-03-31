%% PCA algorithm Group 10 
clc
close all
%% Part 1

% generate X
X = rand(10, 100);
[U, S, Vt] = svd(X);

S(5:end) = 0;
S = diag(S(1:4));

X_rank_4 = U(:, 1:4) * S * Vt(1:4, :);

disp(size(X_rank_4));  % prints [10, 100]
disp(rank(X_rank_4));  % prints 4
disp(X_rank_4);  % prints desired matrix

rng('default'); % Set the random seed to the default value for reproducibility
m = 10;
n = 100;
r = 4;

% Generate a random 10x100 matrix of rank 4
A = randn(m, r);
B = randn(r, n);
X_original = A * B;

% Compute the SVD
[U, S, V] = svd(X_original, 'econ');

DEFAULT_FIGSIZE = [8, 5];

figure('Position', [100, 100, DEFAULT_FIGSIZE(1)*100, DEFAULT_FIGSIZE(2)*100]);
figure(1);
plot(1:length(S), S, 'o');
xticks(1:length(S));
set(gca, 'YScale', 'log');
title('Plot of singular values');

% Confirm U S V = X
%allclose(U.*diag(S)*V', X_original)

disp('X_original: ');
disp(X_original);

% Compute the mean vector d
d = mean(X_original, 2);
d_matrix = d * ones(1, size(X_original, 2));

% Center the data by subtracting the mean vector
X_centered = X_original - d_matrix;

% Compute the covariance matrix C
C = cov(X_centered');

% Compute the eigenvectors of C
[eigenvectors, eigenvalues] = eig(C);

% Select the first 4 eigenvectors to form the basis matrix C
C = eigenvectors(:, end-3:end);
figure(2);
% Plot each column of C as a separate curve
for i = 1:4
    plot(C(:, i));
    hold on;
end
hold off;
title('Plot of the 4 selected eigenvectors');

% Project the data onto the new basis
Y = C' * X_centered;

% Reconstruct the data using the compressed representation
X_reconstructed = C * Y + d_matrix;

X_reconstructed = real(X_reconstructed);

disp('X_reconstructed: ');
disp(X_reconstructed);

% Check if the reconstructed data matches the original data
disp(all(all(abs(X_original - X_reconstructed) < 1e-10)));
figure(3);
% Create the height map of the difference matrix
diff = X_reconstructed - X_original;
imagesc(diff);
colorbar;
title('Error map of difference matrix: (X(reconstructed) - X(original)');
