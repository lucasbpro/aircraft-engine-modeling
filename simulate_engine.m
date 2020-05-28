%% Simulates a specific type of engine

option = input(['Choose the type of engine (default=turbojet):\n(1)turbojet' ...
        '\n(2)turbofan\n(3)ramjet\n']);

switch(option)
    case {'2','turbofan'}
        type = 'turbofan';  
        params = turbofan();
    case {'3','ramjet'}
        type = 'ramjet';
        params = ramjet();
    otherwise
        type = 'turbojet';
        params = turbojet();
end

%% Operating Conditions
% assuming aircraft at an altitude of 18300 meters:

op.M = 3.0;         % mach number 
op.Pa = 7.15808;    % ambient pression (kPa)
op.Ta = 216.650;    % ambient temperature (K)

%% Simulation
engine(type, params, op)