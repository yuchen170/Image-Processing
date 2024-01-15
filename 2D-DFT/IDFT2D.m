
function x = IDFT2D(X)
    % First perform the IDFT on all rows
    for i = 1:size(X, 1)
        X(i, :) = IDFT(X(i, :));
    end

    % Then perform the IDFT on all columns
    for i = 1:size(X, 2)
        X(:, i) = IDFT(X(:, i));
    end

    x = X;
end


