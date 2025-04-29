% Исходник
input_bits = [1 0 0 1 0 1 1 0];
N = length(input_bits);

permutation = randperm(N);

% Прямое перемежение
pupupu_bits = input_bits(permutation);

% Обратное перемежение
inverse_permutation = zeros(1, N);
for i = 1:N
    inverse_permutation(permutation(i)) = i;
end

depupupu_bits = pupupu_bits(inverse_permutation);

disp('Исходный вектор битов:');
disp(input_bits);
disp('Закон перестановки:');
disp(permutation);
disp('После прямого перемежения:');
disp(interleaved_bits);
disp('После обратного перемежения:');
disp(deinterleaved_bits);
