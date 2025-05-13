function ber = calculateBER(originalBits, decodedBits)
    minLength = min(length(originalBits), length(decodedBits));
    ber = sum(originalBits(1:minLength) ~= decodedBits(1:minLength)) / minLength;
end