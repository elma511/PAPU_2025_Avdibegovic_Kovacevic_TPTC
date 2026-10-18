%filtrirani_napon = smooth(napon, 100);
napon1 = napon(:);
T = -0.008498 * napon1.^4 + 0.1811 * napon1.^3 - 0.9524 * napon1.^2 -10.03*napon1+144.7;
figure 
plot(vrijeme, T, 'b');
xlabel('Vrijeme [s]');
ylabel('Temperatura na NTC senzoru [°C]');
title('Zavisnost temperature od vremena');
grid on;