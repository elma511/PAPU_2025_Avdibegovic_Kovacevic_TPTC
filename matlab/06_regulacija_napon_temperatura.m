napon1=8-napon;
%plot(vrijeme)
T = -0.008498 * napon1.^4 + 0.1811 * napon1.^3 - 0.9524 * napon1.^2 -10.03*napon1+144.7;
plot(simout1, napon1, 'b');
xlabel('Vrijeme [s]');
ylabel('Napon na R_{NTC} [V]', 'Interpreter', 'tex', 'FontSize', 11);
title('Napon na R_{NTC} tokom dvopoložajne temperaturne regulacije', 'Interpreter', 'tex');
grid on;
figure
plot(simout1, T);
xlabel('Vrijeme [s]');
ylabel('Temperatura na NTC senzoru [°C]');
title('Temperatura na NTC senzoru tokom dvopoložajne regulacije', 'Interpreter', 'tex');
grid on;
figure
plot(simout1, T);
ylim([95 105]);
xlabel('Vrijeme [s]');
ylabel('Temperatura na NTC senzoru [°C]');
title('Temperatura na NTC senzoru tokom dvopoložajne regulacije', 'Interpreter', 'tex');
grid on;
