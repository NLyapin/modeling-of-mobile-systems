% Функция кодирования текста в биты
function bit_vector = text_to_bits(text)
    alphabet = ['ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .'];
    bit_vector = [];
    
    for i = 1:length(text)
        idx = find(alphabet == text(i)) - 1; % Индекс символа (0-based)
        bin_code = dec2bin(idx, 6); % Преобразование в 6-битный код
        bit_vector = [bit_vector, bin_code - '0']; % Преобразование строки в массив битов
    end
end

% Функция декодирования битов в текст
function text = bits_to_text(bit_vector)
    alphabet = ['ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .'];
    text = '';
    
    for i = 1:6:length(bit_vector)
        bin_code = bit_vector(i:i+5); % Берём 6 бит
        idx = bin2dec(char(bin_code + '0')) + 1; % Конвертируем в число (1-based)
        text = [text, alphabet(idx)];
    end
end

% --- Тестирование кодера и декодера ---
clc; clear;

% Исходный текст
original_text = 'Hello World.';

% Кодирование
bits = text_to_bits(original_text);
disp('Битовый код:');
disp(bits);

% Декодирование
decoded_text = bits_to_text(bits);
disp('Декодированный текст:');
disp(decoded_text);

% Проверка правильности
if strcmp(original_text, decoded_text)
    disp('Кодирование и декодирование выполнено успеshно!');
else
    disp('Ошибка!');
end