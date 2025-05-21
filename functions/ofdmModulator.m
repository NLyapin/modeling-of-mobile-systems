function ofdm_stream = ofdmModulator(qpskSymbols, params)
    N = params.numSubcarriers;
    cpLength = params.cpLength;

    numSymbols = floor(length(qpskSymbols) / N);
    qpskSymbols = qpskSymbols(1:numSymbols * N);

    ofdm_symbols = reshape(qpskSymbols, N, []);
    ifft_data = ifft(ofdm_symbols, N);

    cp = ifft_data(end - cpLength + 1:end, :);
    ofdm_with_cp = [cp; ifft_data];

    ofdm_stream = ofdm_with_cp(:);

    setappdata(0, 'cpLength', cpLength);
end
