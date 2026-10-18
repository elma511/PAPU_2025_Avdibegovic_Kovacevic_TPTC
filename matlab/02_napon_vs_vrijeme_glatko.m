napon_glatko = smooth(napon, 100); 
plot(vrijeme, napon_glatko, 'b');
ylabel('Napon na R_{NTC} [V]', 'Interpreter', 'tex', 'FontSize', 14);
xlabel('Vrijeme [s]', 'FontSize', 14);
title('Filtrirana zavisnost napona od vremena', 'Interpreter', 'tex', 'FontSize', 14)
grid on;