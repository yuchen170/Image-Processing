function noisy_image = add_uniform_noise(image, range)
    noise = range * (rand(size(image)) - 0.5);
    noisy_image = image + noise;
    noisy_image = max(0, min(noisy_image, 1));
    noisy_image = im2double(noisy_image);
end