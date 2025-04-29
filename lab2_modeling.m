input_bits = [1 0 1 0 1 1 0];  

polynomial1 = [1 1 1 1 0 0 1];  
polynomial2 = [1 0 1 1 0 1 1];    

n_bits = length(input_bits);  

encoded_bits = conv_encoder(input_bits, polynomial1, polynomial2);

disp('Закодированное сообщение:');
disp(encoded_bits);

trellis = poly2trellis(7, [171, 133]);  

decoded_bits = vitdec(encoded_bits, trellis, 5, 'trunc', 'hard');

disp('Декодированное сообщение:');
disp(decoded_bits);

function encoded = conv_encoder(input_bits, poly1, poly2)
    n_bits = length(input_bits);
    shift_register = zeros(1, 7);  
    encoded = [];
    
    for i = 1:n_bits
        shift_register = [input_bits(i), shift_register(1:end-1)];
        
        out_bit1 = mod(sum(shift_register .* poly1(1:length(shift_register))), 2);
        out_bit2 = mod(sum(shift_register .* poly2(1:length(shift_register))), 2);
        
        encoded = [encoded, out_bit1, out_bit2];
        
        disp(['Шаг ' num2str(i) ' - Входной бит: ' num2str(input_bits(i))]);
        disp(['Состояние регистра сдвига: ' num2str(shift_register)]);
        disp(['Выходные биты: ' num2str([out_bit1, out_bit2])]);
    end
end
