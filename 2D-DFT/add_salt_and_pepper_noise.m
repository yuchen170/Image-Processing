function noisy_image = add_salt_and_pepper_noise(image, noise_density)
    image = im2double(image);
    random_matrix = rand(size(image));
    salt_mask = random_matrix < noise_density / 2;
    pepper_mask = random_matrix > 1 - noise_density / 2;
    image(salt_mask) = 1;
    image(pepper_mask) = 0;
    noisy_image = im2double(image);
end