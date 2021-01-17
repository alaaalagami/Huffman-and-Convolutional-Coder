function decoded = HuffmanDecoder(characters, codes, inputEncoded)
   decoded = [];
   currentCode = [];
   for i = inputEncoded
       currentCode = [currentCode i];
       for j = 1:length(codes)
           if isequal(currentCode, codes{j})
               decoded = [decoded characters(j)];
               currentCode = [];
               break;
           end
       end
   end 
end