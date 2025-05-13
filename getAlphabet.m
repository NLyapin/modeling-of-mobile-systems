function [alphabet, bitsPerSymbol] = getAlphabet()
    alphabet = ['a':'z', 'A':'Z', '0':'9', ' ', '.'];
    bitsPerSymbol = ceil(log2(length(alphabet)));
end