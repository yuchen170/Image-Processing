function noisy_image = add_speckle_noise(image, variance)
    noise = sqrt(variance) * randn(size(image));
    noisy_image = image + image .* noise;
    noisy_image = max(0, min(noisy_image, 1));
    noisy_image = im2double(noisy_image);
end