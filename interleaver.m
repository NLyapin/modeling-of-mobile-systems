function interleavedBits = interleaver(inputBits)
    if ~isnumeric(inputBits) || ~isvector(inputBits) || any((inputBits ~= 0) & (inputBits ~=1))
        error('[Interleaver] Входные биты должны быть числовым вектором, содержащим только 0 и 1.');
    end

    permutationVector = randperm(length(inputBits));
    interleavedBits = inputBits(permutationVector);

    setappdata(0, 'permutationVector', permutationVector);
end