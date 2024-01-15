function x = IDFT(X)
    N = length(X);        % Get the length of the input vector
    x = zeros(1, N);      % Initialize the output vector

    for n = 1:N
        for k = 1:N
            % Compute each value in the output vector using the IDFT formula
            x(n) = x(n) + X(k) * exp(2j * pi * (k-1) * (n-1)/N);
        end
        x(n) = x(n) / N;   % Scale the result by dividing by N
    end
end