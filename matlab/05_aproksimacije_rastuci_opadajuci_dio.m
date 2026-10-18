t = vrijeme(:);  % Osiguraj da je kolona
y = napon(:);    % Osiguraj da je kolona
boja_neutralna = [0.3, 0.3, 0.3]; 

% --- Parametri za segmentaciju ---
t0 = 100;
t1 = 800;
idx_rast = (t >= t0 & t <= t1);
idx_pad = (t > t1);

% --- Provjere ---
if ~any(idx_rast) || ~any(idx_pad)
    error('Indeksi za rastu?i ili opadaju?i dio nisu validni. Provjeri t0 i t1.');
end

% --- Rastu?i dio ---
t_rast = t(idx_rast);
t_rast = t_rast - t_rast(1);
t_rast = t_rast / max(t_rast);  % Normalizacija
y_rast = y(idx_rast);

% --- Opadaju?i dio ---
t_pad = t(idx_pad);
t_pad = t_pad - t_pad(1);
t_pad = t_pad / max(t_pad);  % Normalizacija
y_pad = y(idx_pad);

% --- Polinomi ---
p3_rast = polyfit(t_rast, y_rast, 3); y_p3_rast = polyval(p3_rast, t_rast);
p5_rast = polyfit(t_rast, y_rast, 5); y_p5_rast = polyval(p5_rast, t_rast);

p3_pad = polyfit(t_pad, y_pad, 3); y_p3_pad = polyval(p3_pad, t_pad);
p5_pad = polyfit(t_pad, y_pad, 5); y_p5_pad = polyval(p5_pad, t_pad);

% --- Eksponencijalna funkcija - RAST ---
ft_exp_rast = fittype('A*(1 - exp(-x/tau)) + B', 'independent', 'x');
opts_rast = fitoptions(ft_exp_rast);
opts_rast.StartPoint = [max(y_rast), 1, min(y_rast)];
opts_rast.Lower = [0, 0.001, -Inf];
opts_rast.Upper = [Inf, 10, Inf];
fit_exp_rast = fit(t_rast, y_rast, ft_exp_rast, opts_rast);
y_exp_rast = feval(fit_exp_rast, t_rast);
% --- Ispis funkcija u eksplicitnom obliku ---

% Polinomi - RAST
fprintf('\n--- POLINOM 3. REDA (RAST) ---\n');
fprintf('y = %.4f*x^3 + %.4f*x^2 + %.4f*x + %.4f\n', p3_rast);

fprintf('\n--- POLINOM 5. REDA (RAST) ---\n');
fprintf('y = %.4f*x^5 + %.4f*x^4 + %.4f*x^3 + %.4f*x^2 + %.4f*x + %.4f\n', p5_rast);

% Polinomi - PAD
fprintf('\n--- POLINOM 3. REDA (PAD) ---\n');
fprintf('y = %.4f*x^3 + %.4f*x^2 + %.4f*x + %.4f\n', p3_pad);

fprintf('\n--- POLINOM 5. REDA (PAD) ---\n');
fprintf('y = %.4f*x^5 + %.4f*x^4 + %.4f*x^3 + %.4f*x^2 + %.4f*x + %.4f\n', p5_pad);

% Eksponencijalne funkcije
coeffs_rast = coeffvalues(fit_exp_rast);
fprintf('\n--- EKSPONENCIJALNA FUNKCIJA (RAST) ---\n');
fprintf('y = %.4f * (1 - exp(-x / %.4f)) + %.4f\n', coeffs_rast(1), coeffs_rast(2), coeffs_rast(3));

coeffs_pad = coeffvalues(fit_exp_pad);
fprintf('\n--- EKSPONENCIJALNA FUNKCIJA (PAD) ---\n');
fprintf('y = %.4f * exp(-x / %.4f) + %.4f\n', coeffs_pad(1), coeffs_pad(2), coeffs_pad(3));

% --- Eksponencijalna funkcija - PAD ---
ft_exp_pad = fittype('A*exp(-x/tau) + B', 'independent', 'x');
opts_pad = fitoptions(ft_exp_pad);
opts_pad.StartPoint = [max(y_pad), 1, min(y_pad)];
opts_pad.Lower = [0, 0.001, -Inf];
opts_pad.Upper = [Inf, 10, Inf];
fit_exp_pad = fit(t_pad, y_pad, ft_exp_pad, opts_pad);
y_exp_pad = feval(fit_exp_pad, t_pad);

% --- Funkcija za greške ---
calc_errors = @(y_true, y_pred) struct( ...
    'MAE', mean(abs(y_true - y_pred)), ...
    'RMSE', sqrt(mean((y_true - y_pred).^2)), ...
    'MAPE', mean(abs((y_true - y_pred)./max(y_true, eps))) * 100, ...
    'SSE', sum((y_true - y_pred).^2) ...
);

% --- Greške ---
err_p3_rast = calc_errors(y_rast, y_p3_rast);
err_p5_rast = calc_errors(y_rast, y_p5_rast);
err_exp_rast = calc_errors(y_rast, y_exp_rast);

err_p3_pad = calc_errors(y_pad, y_p3_pad);
err_p5_pad = calc_errors(y_pad, y_p5_pad);
err_exp_pad = calc_errors(y_pad, y_exp_pad);

% --- Ispis ---
disp('--- GRESKE RASTUCI DIO ---');
disp(err_p3_rast);
disp(err_p5_rast);
disp(err_exp_rast);

disp('--- GRESKE OPADAJUCI DIO ---');
disp(err_p3_pad);
disp(err_p5_pad);
disp(err_exp_pad);

% --- Grafici ---
figure;
plot(t_rast, y_rast, 'Color',boja_neutralna, 'LineWidth', 1.2, 'DisplayName', 'Originalni signal'); hold on;
plot(t_rast, y_p3_rast, 'r--', 'LineWidth', 1.4, 'DisplayName', 'Polinom 3. reda');
plot(t_rast, y_p5_rast, 'b--', 'LineWidth', 1.4, 'DisplayName', 'Polinom 5. reda');
plot(t_rast, y_exp_rast, 'g-', 'LineWidth', 1.4, 'DisplayName', 'Eksponencijalna funkcija');
legend('Location', 'southeast');
xlabel('Vrijeme (normalizovano)');
ylabel('Napon [V]');
title('Aproksimacije – Rastuci dio');
grid on;

figure;
plot(t_pad, y_pad, 'Color',boja_neutralna, 'LineWidth', 1.2, 'DisplayName', 'Originalni signal'); hold on;
plot(t_pad, y_p3_pad, 'r--', 'LineWidth', 1.4, 'DisplayName', 'Polinom 3. reda');
plot(t_pad, y_p5_pad, 'b--', 'LineWidth', 1.4, 'DisplayName', 'Polinom 5. reda');
plot(t_pad, y_exp_pad, 'g-', 'LineWidth', 1.4, 'DisplayName', 'Eksponencijalna funkcija');
legend('Location', 'northeast');
xlabel('Vrijeme (normalizovano)');
ylabel('Napon [V]');
title('Aproksimacije – Opadajuci dio');
grid on;