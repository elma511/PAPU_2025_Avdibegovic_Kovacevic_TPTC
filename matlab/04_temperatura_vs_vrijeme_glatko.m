
filtrirani_napon = smooth(napon, 100);
T = -0.008498 * filtrirani_napon.^4 + 0.1811 * filtrirani_napon.^3 - 0.9524 * filtrirani_napon.^2 -10.03*filtrirani_napon+144.7;;
plot(vrijeme, T, 'b');
xlabel('Vrijeme [s]');
ylabel('Temperatura na NTC senzoru [°C]');
title('Filtrirana zavisnost temperature od vremena');
grid on;