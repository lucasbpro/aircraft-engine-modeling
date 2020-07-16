clc; clear; close all;

%% Load engine params
params = turbojet();

%% Operating conditions

% Condition 1: altitude =  0 m, Mach = 0
altitude = 0; 
[~, temperature, pressure] = atmosferaISA(altitude);
op1.Pa = pressure/1000;     % ambient pressure in kPa
op1.Ta = temperature;       % ambient temperature in K
op1.M = 0;                  % mach number

% Condition 2: altitude = 18300 m, Mach = 2
altitude = 18300; 
[~, temperature, pressure] = atmosferaISA(altitude);
op2.Pa = pressure/1000;     % ambient pressure in kPa
op2.Ta = temperature;       % ambient temperature in K
op2.M = 2;                  % mach number

%% Simulating a Turbojet Engine in condition 1

mar = 80;            % airflow (kg/s)
T1 = [];
T_pq = 2000:2:3000;

for i=1:length(T_pq)
    params.T06 = T_pq(i);
    turbojet1 = engine('turbojet', params, op1);
    T1(i) = turbojet1.T_ma * mar;
end

figure;
plot(T_pq, T1, 'red','Linewidth',2);
title('Finding max thrust given a limit in post-burner temperature');
ylabel('Thrust [KN]'); xlabel('Post-burner temperature [K]');
grid on; hold on; text(2300,101,'2288');

params.T06 = 2288;
plot(T_pq,110*ones(1,length(T_pq)),'b--','Linewidth',2);
plot(2288*ones(1,length(T_pq)),linspace(100,130,length(T_pq)),'b--','Linewidth',2);
plot(2288,110,'k*','LineWidth',3);   text(2290,109,'Point of max. allowed temperature');

turbojet1 = engine('turbojet', params, op1);
fprintf('\nThrust for (a) = %f kN <-110 kN\n\n', turbojet1.T_ma*mar);
fprintf('\nFuel consumption for (a) = %f Kg/s <-110 kN\n\n', turbojet1.TSFC*mar);

%% Simulating a Turbojet Engine in condition 2

T2 = [];
rpm = .5:.001:1;
params.T06 = [];

mar = 80;
T04 = 1600;
Prc = 25;

for i=1:length(rpm)
    corr = parameterAdjustment(rpm(i),op2.Ta,op2.Pa);

    params.T04 = corr.T04*T04;
    params.Prc = corr.Pr*Prc;
    ajuste_mar = corr.mar*mar;

    turbojet2 = engine('turbojet',params,op2);
    T2(i) = turbojet2.T_ma * ajuste_mar;
end

figure;
plot(rpm, T2, 'red','Linewidth',2);
title('Adjusting engine RPM given a required thrust');
ylabel('Thrust [KN]'); xlabel('%rpm');
grid on; hold on;

perc_rpm = 0.909;
plot(rpm,2*ones(1,length(rpm)),'b--','Linewidth',2);
plot(perc_rpm*ones(1,length(rpm)),linspace(0.5,3.5,length(rpm)),'b--','Linewidth',2);
plot(perc_rpm,2,'k*','LineWidth',3); text(0.8,2.1,'Operation Point');
text(0.915,0.6,'0.909');

corr = parameterAdjustment(perc_rpm,op2.Ta,op2.Pa);
params.T04 = corr.T04*T04;
params.Prc = corr.Pr*Prc;
ajuste_mar = corr.mar*mar;

turbojet2 = engine('turbojet',params,op2);
    
fprintf('\nThrust for (b) = %f kN <-2 kN\n\n', turbojet2.T_ma*ajuste_mar);
fprintf('\nFuel consumption for (b) = %f Kg/s <-2 kN\n\n', turbojet2.TSFC*ajuste_mar);
