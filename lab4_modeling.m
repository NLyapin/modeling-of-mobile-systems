% Модулятор
function symbols = modulator(bits)
    if mod(length(bits), 2) ~= 0
        bits = [bits, 0]; % 0 в конец
    end
    
    map = [ 
        0.707,  0.707; % 00
        0.707, -0.707; % 01
       -0.707,  0.707; % 10
       -0.707, -0.707; % 11
    ];
    
    % Выходной вектор
    symbols = zeros(1, length(bits) / 2);
    
    % биты в символы
    for i = 1:2:length(bits)
        b0 = bits(i);
        b1 = bits(i+1);
        idx = b0 * 2 + b1 + 1;
        I = map(idx, 1);
        Q = map(idx, 2);
        symbols((i+1)/2) = I + 1j * Q;
    end
end

% Демодулятор
function bits = demodulator(symbols)
    bits = [];
    
    for k = 1:length(symbols)
        I = real(symbols(k));
        Q = imag(symbols(k));
        
        if I > 0 && Q > 0
            % Область 00
            bits = [bits, 0, 0];
        elseif I > 0 && Q < 0
            % Область 01
            bits = [bits, 0, 1];
        elseif I < 0 && Q > 0
            % Область 10
            bits = [bits, 1, 0];
        elseif I < 0 && Q < 0
            % Область 11
            bits = [bits, 1, 1];
        end
    end
end

bits_in = [0 0 0 1 1 0 1 1];
symbols = modulator(bits_in);
disp('Модулированные символы:');
disp(symbols);

% Добавляем шум
% symbols_noisy = symbols + 0.1 * (randn(size(symbols)) + 1j * randn(size(symbols)));

bits_out = demodulator(symbols);
disp('Демодулированные биты:');
disp(bits_out);
