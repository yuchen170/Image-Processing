function newImage = TVdenoise(inputImage, lambda, n)
    L2 = 8.0;
    s = 0.005;
    sigma = 1.0 / (L2 * s);
    lt = lambda * s;
    [height, width] = size(inputImage);
    updatedImage = double(inputImage);
    normalizedImage = updatedImage;
    gradientX = zeros(height, width);
    gradientY = zeros(height, width);
    p = zeros(height, width, 2);

    % Calculate gradient
    p(:, :, 1) = updatedImage(:, [2:width, width]) - updatedImage;
    p(:, :, 2) = updatedImage([2:height, height], :) - updatedImage;

    for k = 1:n
        gradientX = updatedImage(:, [2:width, width]) - updatedImage;
        gradientY = updatedImage([2:height, height], :) - updatedImage;
        p = p + sigma * cat(3, gradientX, gradientY);
        normalizedGradients = max(1, sqrt(p(:, :, 1) .^ 2 + p(:, :, 2) .^ 2));
        p(:, :, 1) = p(:, :, 1) ./ normalizedGradients;
        p(:, :, 2) = p(:, :, 2) ./ normalizedGradients;

        divergence = [p([1:height-1], :, 2); zeros(1, width)] - [zeros(1, width); p([1:height-1], :, 2)];
        divergence = [p(:, [1:width-1], 1)  zeros(height, 1)] - [zeros(height, 1)  p(:, [1:width-1], 1)] + divergence;

        v = updatedImage + s * divergence;
        updatedImage = (v - lt) .* (v - normalizedImage > lt) + (v + lt) .* (v - normalizedImage < -lt) + normalizedImage .* (abs(v - normalizedImage) <= lt);

        updatedImage = updatedImage + (updatedImage - updatedImage);
    end

    newImage = updatedImage;
end
