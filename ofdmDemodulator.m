function qpskSymbolsOut = ofdmDemodulator(receivedSignal)
    cpLength = getappdata(0, 'cpLength');
    Nzero = getappdata(0, 'Nzero');
    rsIndices = getappdata(0, 'rsIndices');
    referenceSignal = getappdata(0, 'referenceSignal');
    Nqpsk = getappdata(0, 'Nqpsk');
    Nrs = getappdata(0, 'Nrs');

    if isempty(cpLength) || isempty(Nzero) || isempty(rsIndices) || isempty(referenceSignal) || isempty(Nqpsk) || isempty(Nrs)
        error('[OFDM Demodulator] Не удалось получить параметры, сохраненные модулятором. Убедитесь, что ofdmModulator был выполнен.');
    end

    if ~isnumeric(receivedSignal) || ~isvector(receivedSignal)
        error('[OFDM Demodulator] Принятый сигнал должен быть числовым вектором.');
    end

    expectedMinLength = cpLength + Nqpsk + Nrs + 2 * Nzero;

    signalLength = length(receivedSignal);

    % Корреляция для определения начала
    if signalLength >= cpLength && cpLength > 0
        cpPart = receivedSignal(1:cpLength);
        corr = zeros(1, signalLength - cpLength + 1);
        for i = 1:length(corr)
            if i + cpLength - 1 <= signalLength
                corr(i) = abs(sum(conj(cpPart) .* receivedSignal(i:i + cpLength - 1)));
            end
        end
        [~, startIdx] = max(corr);
    else
        startIdx = 1; % запасной вариант
    end

    % Проверка на выход за границы
    if startIdx + expectedMinLength - 1 > signalLength
        warning('[OFDM Demodulator] Длина сигнала меньше ожидаемой. Сигнал будет усечён.');
        receivedSignal = receivedSignal(startIdx:end);
    else
        receivedSignal = receivedSignal(startIdx:startIdx + expectedMinLength - 1);
    end

    % Удаление ЦП
    if length(receivedSignal) <= cpLength
        error('[OFDM Demodulator] Недостаточная длина сигнала после обрезки для удаления циклического префикса.');
    end
    receivedSignal = receivedSignal(cpLength + 1:end);

    % FFT
    freqSignal = fft(receivedSignal);

    % Удаление нулевой подкладки
    if 2 * Nzero >= length(freqSignal)
        error('[OFDM Demodulator] Неверные параметры нулевого заполнения.');
    end
    freqSignal = freqSignal(Nzero + 1:end - Nzero);

    % Эквалайзинг по опорным сигналам
    if isempty(rsIndices) || length(referenceSignal) ~= length(rsIndices)
        error('[OFDM Demodulator] Некорректные опорные данные.');
    end

    C = freqSignal;
    setappdata(0, 'ofdmSpectrum_C', C);

    H = ones(size(C));
    H(rsIndices) = C(rsIndices) ./ referenceSignal;
    H_interp = interp1(rsIndices, H(rsIndices), 1:length(C), 'linear', 'extrap');

    Ceq = C ./ H_interp;
    setappdata(0, 'equalizedSpectrum_Ceq', Ceq);

    allIndices = 1:length(Ceq);
    dataIndices = setdiff(allIndices, rsIndices);

    if length(dataIndices) < Nqpsk
        warning('[OFDM Demodulator] Получено меньше QPSK символов, чем ожидалось.');
        qpskSymbolsOut = Ceq(dataIndices);
    else
        qpskSymbolsOut = Ceq(dataIndices(1:Nqpsk));
    end
end
