%Обратное перемежение битовой последовательности
%   Входные аргументы:
%       inputBits - Числовой вектор - перемешанная битовая последовательность.
%   Выходные аргументы:
%       deinterleavedBits - Числовой вектор - восстановленная битовая последовательность.
function deinterleavedBits = deinterleaver(inputBits)
    permutationVector = getappdata(0, 'permutationVector');

    if isempty(permutationVector)
        deinterleavedBits = inputBits;
        return;
    end

    minLen = min(length(inputBits), length(permutationVector));
    if length(inputBits) ~= length(permutationVector)
    end

    deinterleavedBits = zeros(1, minLen);
    deinterleavedBits(permutationVector(1:minLen)) = inputBits(1:minLen);
end
