function v = viterbi(s)
% Viterbi convolutional code decoder 
% length of original unencoded signal
n = length(s)/3; 
% Initialize costs and paths
costs = [0, 0, 0, 0]; 
paths = zeros(4, n*2);
tempCosts = [0, 0, 0, 0]; 
tempPaths = zeros(4, n*2);
% Decode first time unit
paths(:, 1:2) = [0 0; 1 0; 0 0; 1 0]; 
costs(1) = getCost([0, 0], 0, s(1:3));
costs(2) = getCost([0, 0], 1, s(1:3));
costs(3) = costs(1);
costs(4) = costs(2);
% If original signal has second time unit, decode second unit
if n > 1
    paths(:, 3:4) = [0 0; 0 1; 1 0; 1 1]; 
    costs(1) = costs(1) + getCost([0, 0], 0, s(4:6));
    costs(2) = costs(2) + getCost([1, 0], 0, s(4:6));
    costs(3) = costs(3) + getCost([0, 0], 1, s(4:6));
    costs(4) = costs(4) + getCost([1, 0], 1, s(4:6));
end 
% For decode to decode till end 
p = [1 3 2 4];
for k = 2:n-1
    pIndex = 1; 
    pIndex2 = 1; 
    realOutput = s(k*3 + 1:k*3 + 3);
    for i = 0:3
        for j = 0:1
            c = costs(i+1) + getCost(flip(de2bi(i, 2)), j, realOutput);
            if i == 0 || i == 2
                tempCosts(p(pIndex)) = c;
                tempPaths(p(pIndex),:) = paths(i+1, :);
                tempPaths(p(pIndex),k*2 + 1:k*2 + 2) = flip(de2bi((p(pIndex) - 1), 2)); 
                pIndex = pIndex + 1; 
            else
                if c < tempCosts(p(pIndex2))
                    tempCosts(p(pIndex2)) = c;
                    tempPaths(p(pIndex2),:) = paths(i+1, :);
                    tempPaths(p(pIndex2),k*2 + 1:k*2 + 2) = flip(de2bi((p(pIndex2) - 1), 2));                    
                end 
                pIndex2 = pIndex2 + 1;
            end
        end 
    end 
    costs = tempCosts;
    paths = tempPaths; 
end 
% Get smallest cost
[~, leastCostIndex] = min(costs);
% Get path of smallest cost
shortestPath = paths(leastCostIndex, :);
% Downsample to return decoded message
v = downsample(shortestPath, 2);
% Remove last 2 bits (2 extra zeros that were added in encoder
v = v(1: end -2);
end 