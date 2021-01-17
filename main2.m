%% Convolutinal Coding

%% Convolutional Encoder
% <include>convEncode.m</include>
%% Function to convert binary array to array of -1's and 1's
% <include>signalize.m</include>
%% Function to convert array of -1's and 1's to binary array
% <include>signalize.m</include>
%% Function to get the branch cost from ose state to another
% <include>getCost.m</include>
%% Convolutional Decoder
% <include>viterbi.m</include>
%% Phase 1 function: Returns array of symbol probabilities
% <include>GetProbabilities.m</include>
%% Phase 1 function: Helper function for creating Huffman dictionary
% <include>mixup.m</include>
%% Phase 1 function: Creates Huffman Dictioary
% <include>HuffmanCreator.m</include>
%% Phase 1 function: Huffman Encoder
% <include>HuffmanEncoder.m</include>
%% Phase 1 function: Huffman Decoder
% <include>HuffmanDecoder.m</include>

%% Main function 


%Read the text file
fileID = fopen('Test_text_file.txt','r');
input = fscanf(fileID, '%c');
fclose(fileID); 

fprintf("Working...\n\n");

%Calculate probability of each character
%Order: a-z ().,/-
characters = ['a':'z', ' ', '(', ')', '.', ',', '/', '-'];
probs = GetProbabilities(input, characters);


%Create Huffman code for each character
codes = HuffmanCreator(characters, probs); 

%Encode test file
huffmanEncoded = HuffmanEncoder(characters, codes, input); 

%Channel Encoding
huffmanEncodedArray = zeros(1, length(huffmanEncoded)); 
for i = 1:length(huffmanEncoded)
    huffmanEncodedArray(i) = str2double(huffmanEncoded(i)); 
end
bitCount = length(huffmanEncodedArray); % store the total number of bits
channelEncoded = convEncode(huffmanEncodedArray);

%Send in channel
channelEncodedS = signalize(channelEncoded); % convert sent signal to volt values of 1 and -1
%Send in channel without channel coding
noConv = signalize(huffmanEncodedArray);

BER = zeros(1, 23);
BERnoConv = zeros(1, 23);
SNR = 1:0.5:12; 
for i = 1:23
  
  % With convolutional encoding
    %Add AWGN in channel
    channelEncodedNoisy = awgn(channelEncodedS, SNR(i), 'measured');

    %Recieve from channel
    channelEncodedNoisy = binarize(channelEncodedNoisy); % convert recieved signal to zeros and ones

    %Channel Decoding 
%     t = poly2trellis(3,[7 6 5]);
%     channelDecoded = vitdec(channelEncodedNoisy, t,1 , 'trunc','hard');
%     channelDecoded = channelDecoded(1:end-2); 
    channelDecoded = viterbi(channelEncodedNoisy);
    
    % Calculate BER
    BER(i) = sum(abs(channelDecoded - huffmanEncodedArray))/bitCount;
    
 % No convolutional encoding
    
    %Add AWGN in channel
    noConvNoisy = awgn(noConv, SNR(i), 'measured');
    %Recieve from channel 
    noConvNoisy = binarize(noConvNoisy); 
    % Calculate BER
    BERnoConv(i) = sum(abs(noConvNoisy - huffmanEncodedArray))/bitCount;
    
    % Huffman decode and write to text file for SNR = 12, 8, or 4
    if SNR(i) == 12 || SNR(i) == 8 || SNR(i) == 4
        
       % With convolutional coding
        %Huffman Decoding
        channelDecodedString = '';
        for j = 1:length(channelDecoded)
            channelDecodedString = strcat(channelDecodedString, num2str(channelDecoded(j)));
        end
        huffmanDecoded = HuffmanDecoder(characters, codes, channelDecodedString);
        
        %Write the decoded text to a separate file
        snrString = num2str(SNR(i));
        name = strcat("channelText", snrString);
        name = strcat(name, ".txt");
        fileID_Decoded = fopen(name, 'w');
        fprintf(fileID_Decoded, huffmanDecoded);
        fclose(fileID_Decoded);
       
       % No channel coding
        %Huffman Decoding
        noConvDecodedString = '';
        for j = 1:length(channelDecoded)
            noConvDecodedString = strcat(noConvDecodedString, num2str(noConvNoisy(j)));
        end
        huffmanDecoded = HuffmanDecoder(characters, codes, noConvDecodedString);
        
        %Write the decoded text to a separate file
        name = strcat("noConvText", snrString);
        name = strcat(name, ".txt");
        fileID_Decoded = fopen(name, 'w');
        fprintf(fileID_Decoded, huffmanDecoded);
        fclose(fileID_Decoded);    
        
    end

end 
%Plot BER vs SNR
plot(SNR, BER);
hold on 
plot(SNR, BERnoConv);
hold off 
grid on
xlim([1 12]);
legend('Convolutional Coding', 'No Channel Coding');
xlabel("SNR in dB");
ylabel("BER");
title("BER - SNR plot");
fprintf("Done!\n"); 