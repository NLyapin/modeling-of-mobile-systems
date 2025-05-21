function qpskSymbols = ofdmDemodulator(receivedSignal)
    cpLength = getappdata(0, 'cpLength');
    N = 64;
    symbolLength = N + cpLength;

    totalLength = length(receivedSignal);
    numSymbols = floor(totalLength / symbolLength);

    if numSymbols < 1
        neededLength = symbolLength;
        receivedSignal(end+1:neededLength) = 0;
        numSymbols = 1;
    else
        receivedSignal = receivedSignal(1:numSymbols * symbolLength);
    end

    try
        reshaped = reshape(receivedSignal, symbolLength, []);
    catch ME
        neededLength = ceil(length(receivedSignal)/symbolLength)*symbolLength;
        receivedSignal(end+1:neededLength) = 0;
        reshaped = reshape(receivedSignal, symbolLength, []);
    end

    ofdm_no_cp = reshaped(cpLength+1:end, :);
    qpskSymbols = fft(ofdm_no_cp, N);
    qpskSymbols = qpskSymbols(:);
end
