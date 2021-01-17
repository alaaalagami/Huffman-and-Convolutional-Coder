function codes = HuffmanCreator(symsArray, probsArray)
n = length(probsArray); 
codes = cell(1, n);
temp = cell(1, n);
for i = 1:n
    temp{i} = i; 
end
temp2 = [probsArray; 1:n]; 
for i = 1:n-1
    temp2 = (sortrows(temp2.', 1)).'; 
    temp = mixup(temp, temp2(2, :));
    for j = 1:length(temp{1})
        codes{temp{1}(j)} = strcat('0', codes{temp{1}(j)}); 
    end
    for j = 1:length(temp{2})
        codes{temp{2}(j)} = strcat('1', codes{temp{2}(j)}); 
    end
    temp{1} = [temp{1} temp{2}]; 
    temp{2} = 0;
    temp2(1, 1) = temp2(1,1) + temp2(1, 2); 
    temp2(1, 2) = 2; 
    temp2(2, :) = 1:n;     
end
% fprintf('Symbol Code\n');
% for i = 1:n
%     fprintf('%c      %s\n', symsArray(i), codes{i});  
% end 
end 