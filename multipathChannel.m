function receivedSignal = multipathChannel(txSignal, params)
    L = length(txSignal);
    Ts = 1 / params.bandwidth;
    D = randi([10, 500], 1, params.numRays);
    tauSamples = round(((D - min(D)) / params.c) / Ts);
    G = params.c ./ (4 * pi * D * params.carrierFrequency);

    delayed = zeros(params.numRays, L + max(tauSamples));
    for i = 1:params.numRays
        idx = tauSamples(i) + (1:L);
        delayed(i, idx) = G(i) * txSignal;
    end

    channelOut = sum(delayed, 1);
    noise = wgn(1, length(channelOut), params.noisePowerBW, [], 'complex');
    receivedSignal = channelOut + noise;
    receivedSignal = receivedSignal(:);

    if length(receivedSignal) > L
        receivedSignal = receivedSignal(1:L);
    elseif length(receivedSignal) < L
        receivedSignal(end+1:L) = 0;
    end
end
