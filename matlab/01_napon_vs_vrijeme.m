
napon = squeeze(napon);
plot (vrijeme, napon, 'b');
ylabel('Napon na R_{NTC} [V]', 'Interpreter', 'tex', 'FontSize', 14);
xlabel('Vrijeme [s]', 'FontSize', 14);
title('Zavisnost napona od vremena', 'Interpreter', 'tex', 'FontSize', 14)
grid on;
