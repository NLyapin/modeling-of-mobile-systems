function y = ofdm_mod(x, d, t)
    N = numel(x);
    disp('QPSK:');
    disp(x.');

    P = floor(N / d);
    c = 0.25;
    z = round(c * (P + N));

    s = zeros(1, N + P);
    xi = 1; pi = 0; idx = [];

    for i = 1:length(s)
        if mod(i, d) == 0 && pi < P
            s(i) = 0.707 + 0.707i;
            idx(end + 1) = i;
            pi = pi + 1;
        else
            s(i) = x(xi);
            xi = xi + 1;
        end
    end

    disp('With pilots:');
    disp(s);

    setappdata(0, 'idx', idx);
    setappdata(0, 'z', z);
    setappdata(0, 'pval', 0.707 + 0.707i);
    setappdata(0, 'c', c);
    setappdata(0, 't', t);
    setappdata(0, 'd', d);

    sz = zeros(1, N + P + 2 * z);
    sz(z + 1:end - z) = s;
    f = ifft(sz);

    cp = round(t * length(f));
    setappdata(0, 'cp', cp);

    y = [f(end - cp + 1:end), f];
    disp('OFDM:');
    disp(y);
end

msg = 'HELLO WORLD';
b = de2bi(double(msg), 8, 'left-msb');  
b = b'; 
b = b(:); 

symb = reshape(b, [], 2);
q = (1 - 2 * symb(:,1)) + 1i * (1 - 2 * symb(:,2)); 
q = q / sqrt(2);

d = 6;
t = 0.25;

ofdm = ofdm_mod(q, d, t);

figure;
plot(real(ofdm)); hold on; plot(imag(ofdm));
legend('Re','Im');
title('OFDM');
xlabel('Index');
ylabel('Amp');
