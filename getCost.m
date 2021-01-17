function cost = getCost(reg, input, realOutput)
% Returns the branch cost of entering bit input on registers saved in reg
% where realOutput is the 3 recieved parity bits for this "time"
output(1) = mod(input + reg(1) + reg(2), 2); 
output(2) = mod(input + reg(1), 2);
output(3) = mod(input + reg(2), 2);
cost = sum(abs(output - realOutput));
end 