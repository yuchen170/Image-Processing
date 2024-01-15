function noisy_image = add_exponential_noise(image, lambda)
    noise = -log(1 - rand(size(image))) / lambda;
    noisy_image = image + noise;
    noisy_image = max(0, min(noisy_image, 1));
    noisy_image = im2double(noisy_image);
end