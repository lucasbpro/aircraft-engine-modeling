%% Turbojet vs. Turbofan performance comparison

clc; clear; close all;

%% Load prameters

% Commmon parameters
params = turbofan(); 

% turbofan-specific parameters
paramsTurboFan = params;
paramsTurboFan.Prf = 1.5;      % razao de pressao no fan
paramsTurboFan.Prc = 20;       % razao de pressao no compressor
paramsTurboFan.T04 = 1700;     % temp. na saida da camara de combustao (K)
paramsTurboFan.B = 7;          % razao de passagem

% turbojet-specific parameters
paramsTurboJet = params;
paramsTurboJet.Prf = 1;        % razao de pressao no fan
paramsTurboJet.Prc = 30;       % razao de pressao no compressor 
paramsTurboJet.T04 = 1700;     % temp. na saida da camara de combustao (K)
paramsTurboJet.B = 0;          % razao de passagem


%% Operating conditions

% 0 m
op_Takeoff.M = 0;   % mach
op_Takeoff.Pa = 101.30; % pressao ambiente (kPa)
op_Takeoff.Ta = 288.2; % temperatura ambiente (K)

% 7000 m
op_Climb.M = 0.45;   % mach
op_Climb.Pa = 41.0; % pressao ambiente (kPa)
op_Climb.Ta = 246.65; % temperatura ambiente (K)

% 12200 m
op_Cruise.M = 0.85;   % mach
op_Cruise.Pa = 18.75; % pressao ambiente (kPa)
op_Cruise.Ta = 216.7; % temperatura ambiente (K)

%% Simulacao Motor Turbofan
turbofan_Takeoff = engine('turbofan', paramsTurboFan, op_Takeoff);
turbofan_Climb = engine('turbofan', paramsTurboFan, op_Climb);
turbofan_Cruise = engine('turbofan', paramsTurboFan, op_Cruise);

%% Simulacao Motor Turbojato
turbojet_Takeoff = engine('turbojet', paramsTurboJet, op_Takeoff);
turbojet_Climb = engine('turbojet', paramsTurboJet, op_Climb);
turbojet_Cruise = engine('turbojet', paramsTurboJet, op_Cruise);

%% Graficos

figure; 
subplot(2,1,1); 
bar([1 2 3],[[turbojet_Takeoff.TSFC turbojet_Climb.TSFC turbojet_Cruise.TSFC]' ...
    [turbofan_Takeoff.TSFC turbofan_Climb.TSFC turbofan_Cruise.TSFC]']);
xlabels = {'Takeoff','Climb','Cruise'};
set(gca, 'XTick', 1:3, 'XTickLabel', xlabels);
ylabel('TSFC in ^{kg}/_{kN.s}');
title('Performance comparison per flight phase'); 
legend('Turbojet','Turbofan','Location','SouthEast'); 
grid on;

subplot(2,1,2); 
bar([1 2 3],[[turbojet_Takeoff.T_ma turbojet_Climb.T_ma turbojet_Cruise.T_ma]' ...
    [turbofan_Takeoff.T_ma turbofan_Climb.T_ma turbofan_Cruise.T_ma]']);
xlabels = {'Takeoff','Climb','Cruise'};
set(gca, 'XTick', 1:3, 'XTickLabel', xlabels);
ylabel('Specific Thrust - ^{kN.s}/_{kg}');
legend('Turbojet','Turbofan','Location','SouthEast'); 
grid on; 

saveas(gcf,'./img/performance_per_flight_phase.png')