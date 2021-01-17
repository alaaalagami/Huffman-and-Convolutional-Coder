function probs = GetProbabilities(input, characters)
    charCount = zeros(1,length(characters));
    for i = 1:length(characters)
        for c = input
            if c == characters(i)
                charCount(i) = charCount(i) + 1;
            end
        end
    end
    probs = charCount ./ length(input);
end