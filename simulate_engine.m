%% Simulates a specific type of engine

option = input(['Choose the type of engine (default=turbojet):\n(1)turbojet' ...
        '\n(2)turbofan\n(3)ramjet\n']);

switch(option)
    case {'2'}
        type = 'turbofan';  
        params = turbofan();
    case {'3'}
        type = 'ramjet';C:\Users\Lucas\Documents\1. Formação\Mestrado\1. Material de Estudo\Exercício - KF
        params = ramjet();
    otherwise
        type = 'turbojet';
        params = turbojet();
end

%% Operating Conditions
% assuming aircraft at an altitude of 18300 meters:

disp('Input the operating conditions:');
mach = input('Mach number:');
altitude = input('Altitude (meters):');

[~, temperature, pressure] = atmosferaISA(altitude);
op.M = mach;             % mach number 
op.Pa = pressure/1000;   % ambient pression (kPa)
op.Ta = temperature;     % ambient temperature (K)

%% Simulation
engine(type, params, op)