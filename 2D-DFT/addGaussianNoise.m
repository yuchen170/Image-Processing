function noisyImage = addGaussianNoise(image, mean, variance)
    [height, width] = size(image);
    noise = sqrt(variance) * randn(height, width) + mean;
    noisyImage = image + noise;
end