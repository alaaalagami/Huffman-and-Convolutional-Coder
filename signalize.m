function y = signalize(x)
% converts binary input to array of -1 and 1 volts 
y = ones(1, length(x));
for i = 1:length(x)
    if x(i) == 0 
        y(i) = -1; 
    end 
end 
end 
