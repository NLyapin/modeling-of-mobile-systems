function params = ofdm_config()
    params.numSubcarriers = 64;                  % N
    params.cpLengthRatio = 1/16;
    params.zeroPaddingRatio = 1/4;
    params.cpLength = round(params.numSubcarriers * params.cpLengthRatio);
    params.fftSize = params.numSubcarriers;
    params.numSymbols = []; % Позже задается из длины данных
end
