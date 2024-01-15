function X = DFT(x)
    N = length(x);   % Get the length of the input vector
    X = zeros(1, N); % Initialize the output vector

    for k = 1:N
        for n = 1:N
            % Compute each value in the output vector using the DFT formula
            X(k) = X(k) + x(n) * exp(-2j * pi * (k-1) * (n-1) / N);
        end
    end
end
