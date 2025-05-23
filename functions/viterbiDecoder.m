%Декодирование Витерби битовой последовательности.
function decodedBits = viterbiDecoder(encodedBits)
    [constraintLength, codeGenerator] = getCodingParameters();
    trellis = poly2trellis(constraintLength, codeGenerator);

    if ~isnumeric(encodedBits) || ~isvector(encodedBits) || any((encodedBits ~= 0) & (encodedBits ~= 1))
        error('[ViterbiDecoder] Входные биты должны быть числовым вектором, содержащим только 0 и 1.');
    end

    % ОБРЕЗАЕМ ЛИШНИЕ БИТЫ
    n = length(codeGenerator); % количество выходных бит на входной бит
    validLength = floor(length(encodedBits) / n) * n;
    encodedBits = encodedBits(1:validLength);

    tbLen = 5 * constraintLength;
    decodedBits = vitdec(encodedBits, trellis, tbLen, 'trunc', 'hard');
end
