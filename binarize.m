function y = binarize(x)
% Convert recieved signal to binary signal

% Initialize output array with ones
y = ones(1, length(x));
for i = 1:length(x)
    % If distance to -1 is less than distance to 1, set output bit to 0
    if x(i) <= 0
        y(i) = 0; 
    end 
end 
end