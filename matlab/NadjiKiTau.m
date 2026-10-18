function [ K1,Tau1,K2,Tau2 ] = NadjiKiTau( temp ,vrijeme,pobuda)
 % Ulazni parametri:
    % temp - vektor temperature
    % vrijeme - vektor vremena
    % pobuda - ulazni signal (npr. step-funkcija)

    % Prona?i to?ku prijelaza (maksimum temperature)
    [max_temp, idx_max] = max(temp);
    
    % 1. Rastu?i dio (od po?etka do maksimuma)
    temp_rast = temp(1:idx_max);
    vrijeme_rast = vrijeme(1:idx_max);
    
    % Po?etna i kona?na vrijednost za rastu?i dio
    T_pocetna = temp(1);
    T_krajnja_rast = max_temp;
    
    % Poja?anje K1 (razlika izme?u kona?ne i po?etne vrijednosti)
    K1 = T_krajnja_rast - T_pocetna;
    
    % Procjena Tau1: vremenska konstanta je vrijeme kada temperatura naraste za 63% ukupne promjene
    delta_T_rast = K1;
    cilj_T_rast = T_pocetna + 0.63 * delta_T_rast; % 63% promjene
    idx_Tau1 = find(temp_rast >= cilj_T_rast, 1, 'first');
    if ~isempty(idx_Tau1)
        Tau1 = vrijeme_rast(idx_Tau1) - vrijeme_rast(1);
    else
        Tau1 = NaN; % Ako ne možemo prona?i Tau1
    end
    
    % 2. Opadaju?i dio (od maksimuma do kraja)
    temp_opadanje = temp(idx_max:end);
    vrijeme_opadanje = vrijeme(idx_max:end) - vrijeme(idx_max); % Normalizacija vremena
    
    % Po?etna i kona?na vrijednost za opadaju?i dio
    T_krajnja_opadanje = temp(end);
    T_pocetna_opadanje = max_temp;
    
    % Poja?anje K2 (razlika izme?u po?etne i kona?ne vrijednosti)
    K2 = T_krajnja_opadanje - T_pocetna_opadanje;
    
    % Procjena Tau2: vremenska konstanta je vrijeme kada temperatura padne za 63% ukupne promjene
    delta_T_opadanje = abs(K2);
    cilj_T_opadanje = T_pocetna_opadanje + 0.63 * K2; % 63% promjene
    idx_Tau2 = find(temp_opadanje <= cilj_T_opadanje, 1, 'first');
    if ~isempty(idx_Tau2)
        Tau2 = vrijeme_opadanje(idx_Tau2);
    else
        Tau2 = NaN; % Ako ne možemo prona?i Tau2
    end

end

