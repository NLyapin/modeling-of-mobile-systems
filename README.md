# OFDM Communication System in MATLAB

## Описание проекта

Данный проект реализует имитационную модель OFDM-системы передачи данных в среде MATLAB. Система использует:

* **QPSK-модуляцию/демодуляцию**
* **Сверточное кодирование и декодирование Витерби**
* **Прямое и обратное перемежение**
* **Многолучевой канал с аддитивным белым гауссовским шумом (AWGN)**
* **OFDM-модуляцию с циклическим префиксом**

Система может использоваться для оценки производительности цифровой передачи по показателю **битовой ошибки (BER)**.

---

## Структура кода

| Функция                            | Назначение                                                |
| ---------------------------------- | --------------------------------------------------------- |
| `symbolEncoder`                    | Кодирование строки в битовую последовательность           |
| `symbolDecoder`                    | Декодирование битовой последовательности в строку         |
| `getAlphabet`                      | Получение допустимого алфавита и количества бит на символ |
| `convolutionalEncoder`             | Сверточное кодирование бит                                |
| `viterbiDecoder`                   | Декодирование Витерби                                     |
| `interleaver`, `deinterleaver`     | Перемежение и обратное перемежение                        |
| `qpskModulator`, `qpskDemodulator` | QPSK-модулятор и демодулятор                              |
| `ofdmModulator`, `ofdmDemodulator` | OFDM-модуляция и демодуляция                              |
| `multipathChannel`                 | Модель многолучевого канала с шумом                       |
| `calculateBER`                     | Расчёт вероятности битовой ошибки                         |
| `channel_config`                   | Параметры канала связи                                    |
| `ofdm_config`                      | Параметры OFDM                                            |

---

## Пример использования

```matlab
% Исходное сообщение
message = 'Hello World.';

% Кодирование символов в биты
inputBits = symbolEncoder(message);

% Сверточное кодирование
codedBits = convolutionalEncoder(inputBits);

% Перемежение
interleavedBits = interleaver(codedBits);

% QPSK модуляция
modulatedSymbols = qpskModulator(interleavedBits);

% OFDM модуляция
paramsOFDM = ofdm_config();
ofdmSignal = ofdmModulator(modulatedSymbols, paramsOFDM);

% Параметры канала
paramsChannel = channel_config();

% Передача по каналу
receivedSignal = multipathChannel(ofdmSignal, paramsChannel);

% OFDM демодуляция
receivedSymbols = ofdmDemodulator(receivedSignal);

% QPSK демодуляция
demodulatedBits = qpskDemodulator(receivedSymbols);

% Обратное перемежение
deinterleavedBits = deinterleaver(demodulatedBits);

% Декодирование Витерби
decodedBits = viterbiDecoder(deinterleavedBits);

% Декодирование символов
decodedMessage = symbolDecoder(decodedBits);

% BER
ber = calculateBER(inputBits, decodedBits);
disp(['BER: ', num2str(ber)]);
disp(['Полученное сообщение: ', decodedMessage]);
```

---

## Требования

* MATLAB с установленным **Communications Toolbox**
* Версия MATLAB R2016 и новее рекомендуется