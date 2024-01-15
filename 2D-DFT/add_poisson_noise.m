function noisy_image = add_poisson_noise(image, noise_rate)
    image = im2double(image);
    mean_intensity = mean(image(:)) * noise_rate;
    poisson_noise = poissrnd(mean_intensity, size(image));
    noisy_image = image + poisson_noise;
    noisy_image = max(0, min(noisy_image, 1));
    noisy_image = im2double(noisy_image);
end