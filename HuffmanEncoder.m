function encoded = HuffmanEncoder(symsArray, codes, input)
encoded = [];
for i = input 
    for j = 1:length(symsArray)
        if i == symsArray(j)
            encoded = [encoded codes{j}]; 
        end
    end 
end 
end 