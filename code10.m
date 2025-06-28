%% Thermodynamic Cycle Comparison
% Compares Otto, Diesel, Dual, and Atkinson cycles on P-V diagram

clear; clc; close all;

%% Constants
gamma = 1.4;       % Specific heat ratio
P1 = 100;          % Initial pressure (kPa)
V1 = 0.287*300/100; % Initial volume (m³/kg)
T1 = 300;          % Initial temperature (K)
R = 0.287;         % Gas constant (kJ/kg-K)
cv = 0.718;        % Specific heat at constant volume (kJ/kg-K)
cp = 1.005;        % Specific heat at constant pressure (kJ/kg-K)
rc = 12;           % Compression ratio
rp = 1.7;          % Pressure ratio (P3/P2)
cutoff_ratio = 1.55; % Cut-off ratio (V4/V3)
re = 17;           % Expansion ratio (Atkinson)

%% Dual Cycle Calculations
V2 = V1 / rc;
P2 = P1 * (rc^gamma);
T2 = T1 * (rc^(gamma-1));

% Constant volume heat addition
P3 = rp * P2;
T3 = T2 * rp;
V3 = V2;

% Constant pressure heat addition
V4 = cutoff_ratio * V3;
T4 = T3 * cutoff_ratio;
P4 = P3;

% Isentropic expansion
V5 = V1;
P5 = P4 * ((V4/V5)^gamma);

%% Otto Cycle Calculations
T3_otto = T2 * rp;
P3_otto = P2 * (T3_otto/T2);
V4_otto = V1;
P4_otto = P3_otto * ((V3/V4_otto)^gamma);

%% Diesel Cycle Calculations
V3_diesel = cutoff_ratio * V2;
P3_diesel = P2;
V4_diesel = V1;
P4_diesel = P3_diesel * ((V3_diesel/V4_diesel)^gamma);

%% Atkinson Cycle Calculations
% Process 1-2: Isentropic compression
V2_atk = V1 / rc;
P2_atk = P1 * (rc^gamma);
T2_atk = T1 * (rc^(gamma-1));

% Process 2-3: Constant volume heat addition
T3_atk = 1320;       % Given temperature (K)
P3_atk = P2_atk * (T3_atk/T2_atk);
V3_atk = V2_atk;

% Process 3-4: Isentropic expansion (full expansion)
V4_atk = V1;
P4_atk = P3_atk * ((V3_atk/V4_atk)^gamma);
T4_atk = T3_atk * ((V3_atk/V4_atk)^(gamma-1));

%% Generate P-V points
% Dual Cycle
V_dual = [linspace(V1,V2,100), V2, V3, linspace(V3,V4,100), V4, linspace(V4,V5,100), V5, V1];
P_dual = [P1*(V1./linspace(V1,V2,100)).^gamma, P2, P3, P3*ones(1,100), P4, P4*(V4./linspace(V4,V5,100)).^gamma, P5, P1];

% Otto Cycle
V_otto = [linspace(V1,V2,100), V2, V3, linspace(V3,V4_otto,100), V4_otto, V1];
P_otto = [P1*(V1./linspace(V1,V2,100)).^gamma, P2, P3_otto, P3_otto*(V3./linspace(V3,V4_otto,100)).^gamma, P4_otto, P1];

% Diesel Cycle
V_diesel = [linspace(V1,V2,100), linspace(V2,V3_diesel,100), linspace(V3_diesel,V4_diesel,100), V4_diesel, V1];
P_diesel = [P1*(V1./linspace(V1,V2,100)).^gamma, P2*ones(1,100), P3_diesel*(V3_diesel./linspace(V3_diesel,V4_diesel,100)).^gamma, P4_diesel, P1];

% Atkinson Cycle
V_atk = [linspace(V1,V2_atk,100), V2_atk, V3_atk, linspace(V3_atk,V4_atk,100), V4_atk, V1];
P_atk = [P1*(V1./linspace(V1,V2_atk,100)).^gamma, P2_atk, P3_atk, P3_atk*(V3_atk./linspace(V3_atk,V4_atk,100)).^gamma, P4_atk, P1];

%% Plotting
figure('Position', [100, 100, 900, 650]);
hold on;

% Plot all cycles
plot(V_dual, P_dual, 'b-', 'LineWidth', 2);
plot(V_otto, P_otto, 'r--', 'LineWidth', 2);
plot(V_diesel, P_diesel, 'g-.', 'LineWidth', 2);
plot(V_atk, P_atk, 'm:', 'LineWidth', 2);

% Mark key points
plot([V1 V2 V3 V4 V5], [P1 P2 P3 P4 P5], 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
plot([V1 V2 V3 V4_otto], [P1 P2 P3_otto P4_otto], 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
plot([V1 V2 V3_diesel V4_diesel], [P1 P2 P3_diesel P4_diesel], 'go', 'MarkerSize', 6, 'MarkerFaceColor', 'g');
plot([V1 V2_atk V3_atk V4_atk], [P1 P2_atk P3_atk P4_atk], 'mo', 'MarkerSize', 6, 'MarkerFaceColor', 'm');

% Formatting
xlabel('Volume (m^3/kg)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Pressure (kPa)', 'FontSize', 12, 'FontWeight', 'bold');
title('P-V Diagram Comparison (r_c=12)', 'FontSize', 14, 'FontWeight', 'bold');
legend('Dual Cycle', 'Otto Cycle', 'Diesel Cycle', 'Atkinson Cycle', 'Location', 'northeast');
grid on;
xlim([0, 1.1]);
ylim([0, 6000]);

hold off;

%% Performance Calculations for Atkinson Cycle
m = P1*V1/(R*T1);   % Mass of gas (kg)
Q_in_atk = m*cv*(T3_atk-T2_atk);
Q_out_atk = m*cp*(T4_atk-T1);
W_net_atk = Q_in_atk - Q_out_atk;
eta_atk = W_net_atk / Q_in_atk * 100;

%% Display Results
fprintf('=== Atkinson Cycle Performance ===\n');
fprintf('T1 = %.2f K, T2 = %.2f K\n', T1, T2_atk);
fprintf('T3 =%.2f K, T4 = %.2f K\n\n', T3_atk, T4_atk);
fprintf('Heat Input (Q_in) = %.2f kJ\n', Q_in_atk);
fprintf('Heat Rejected (Q_out) = %.2f kJ\n', Q_out_atk);
fprintf('Net Work Output (W_net) = %.2f kJ\n', W_net_atk);
fprintf('Thermal Efficiency = %.2f%%\n\n', eta_atk);

% Save high-quality image
print('Thermodynamic_Cycles_Comparison.png', '-dpng', '-r300');