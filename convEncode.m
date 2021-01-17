function s = convEncode(m)
% Encodes input m into output s 
% k = 3, r = 1/3
% Generator polynomials: 111, 110, 101
% Save length of m 
n = length(m);
% Add initial zeros (2 zeros originally held in shift registers) to the start of m
% Add 2 last zeros to ensure last bits are properly corrected
m = [0, 0, m, 0, 0];
% Initialize output array of size 3*input m 
s = zeros(1, n*3);
% Main loop to generate output
for i = 3:n+4
  j = i - 3; 
  s(j*3 + 1)= mod(m(i-2) + m(i-1) + m(i),2); % Parity output 1
  s(j*3 + 2)= mod(m(i-1) + m(i),2); % Parity output 2
  s(j*3 + 3)= mod(m(i-2) + m(i),2); % Parity output 3
end 
end 