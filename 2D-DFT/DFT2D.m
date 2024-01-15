
function X = DFT2D(x)
    % First perform the DFT on all rows
    for i = 1:size(x, 1)
        x(i, :) = DFT(x(i, :));
    end

    % Then perform the DFT on all columns
    for i = 1:size(x, 2)
        x(:, i) = DFT(x(:, i));
    end

    X = x;
end

