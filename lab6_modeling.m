N_info = 64;             % Количество информационных поднесущих
N_pilot = 16;            % Количество опорных поднесущих
N_zero = 20;             % Количество нулевых поднесущих с каждой стороны
Delta_RS = 6;            % Шаг размещения опорных поднесущих
C = 1/4;                 % Параметр для вычисления защитного интервала
T_cp = 16;               % Размер циклического префикса

% Общее количество поднесущих
N_total = N_info + N_pilot + 2 * N_zero;

info_symbols = (randn(N_info, 1) + 1j*randn(N_info, 1)) / sqrt(2);
pilot_signal = repmat(0.707 + 1j*0.707, N_pilot, 1);

% Расчет индексов
pilot_indices = 1:Delta_RS:N_total;
pilot_indices = pilot_indices(1:N_pilot);  % Обрезаем до N_pilot

% Канальный мультиплексор: распределение поднесущих
freq_domain = zeros(N_total, 1);   % Инициализация спектра
freq_domain(N_zero+1:N_zero+N_info) = info_symbols;  % Информационные поднесущие
freq_domain(pilot_indices) = pilot_signal;  % Опорные поднесущие

% Добавление нулевых поднесущих слева и справа
N_zeros = round(C * (N_info + N_pilot));  % Количество нулевых поднесущих
freq_domain(1:N_zeros) = 0;
freq_domain(end-N_zeros+1:end) = 0;

% Обратное дискретное преобразование Фурье (ОДПФ)
time_domain = ifft(freq_domain);  % Преобразование в временную область

% Добавление циклического префикса
cyclic_prefix = time_domain(end-T_cp+1:end);  % Копирование конца в начало
time_domain_with_cp = [cyclic_prefix; time_domain];  % Объединение

% Визуализация спектра
figure;
subplot(2, 1, 1);
stem(abs(freq_domain));
title('Спектр символа (частотный домен)');
xlabel('Индекс поднесущей');
ylabel('Амплитуда');

% Визуализация временного сигнала
subplot(2, 1, 2);
plot(real(time_domain_with_cp));
title('Временной сигнал (с циклическим префиксом)');
xlabel('Время');
ylabel('Амплитуда');
