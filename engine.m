function OUT = engine(type, params, op)

% OUT = engine(type, params, op)
%
% This is a thermodynamic model for three different aeronautical engines: 
% turbofan, turbojet and ramjet
%
% Inputs: 
%       type =  string which provides engine type (turbofan, turbojet, ramjet)
%
%       params = struct containing engine parameters
%
%       op = operating conditions, which shall contain
%               op.M  ---> mach number
%               op.Pa ---> ambient pressure
%               op.Ta ---> ambient temperature

%%

% Caracteristicas Operacionais do Motor

n_d = params.n_d;     % eficiencia do difusor (entrada de ar)
n_f = params.n_f;     % eficiencia do fan
n_c = params.n_c;     % eficiencia do compressor
n_b = params.n_b;     % eficiencia da combustao
n_tc = params.n_tc;    % eficiencia da turbina do compressor
n_tf = params.n_tf;    % eficiencia da turbina do fan
n_hn = params.n_hn;    % eficiencia do bocal de gases quentes
n_fn = params.n_fn;    % eficiencia do bocal do fan
n_bpq = params.n_bpq;  % eficiencia de combustao do pos-queimador

gama_d = params.gama_d;    % gama do difusor
gama_f = params.gama_f;    % gama do fan
gama_c = params.gama_c;    % gama do compressor
gama_b = params.gama_b;    % gama da combustao
gama_tc = params.gama_tc;   % gama da turbina do compressor
gama_tf = params.gama_tf;   % gama da turbina do fan
gama_hn = params.gama_hn;   % gama do bocal de gases quentes
gama_fn = params.gama_fn;   % gama do bocal do fan

Prc = params.Prc;   % razao de pressao no compressor
Prf = params.Prf;   % razao de pressao no fan
T04 = params.T04;   % temp. na saida da camara de combustao (K)
T06 = params.T06;   % temp. na saida do pos-queimador (K)
B = params.B;       % razao de passagem
PC = params.PC;     % poder calorifico inferior do combustivel (kJ/kg)
R = params.R;       % R medio (m^2/(s^2 * K))
Cp = params.Cp;     % Cp no combustor (kJ/(kg * K))

% Ponto de Operacao
M = op.M;   % mach
Pa = op.Pa; % pressao ambiente (kPa)
Ta = op.Ta; % temperatura ambiente (K)

u_sf = 0;
f_pq = 0;
TET = 0;
PET = 0;

% Difusor
T02 = Ta * (1 + (gama_d-1)/2 * M^2);
P02 = Pa * (1 + n_d * (T02/Ta - 1))^(gama_d/(gama_d-1));

% Fan
if(~strcmp(type, 'turbofan'))
    Prf = 1;
end
P08 = P02 * Prf;
T08 = T02 * (1 + (1/n_f)*(Prf^((gama_f -1)/gama_f) - 1));

% Compressor
if(strcmp(type, 'ramjet'))
    Prc = 1;
end
P03 = P08 * Prc;
T03 = T08 * (1 + (1/n_c)*(Prc^((gama_c -1)/gama_c) - 1));

% Camara de Combustao
f = ((T04/T03) - 1)/( ((n_b*PC)/(Cp*T03)) - (T04/T03) );
P04 = P03; % assumindo pressao constante durante a combustao

if(strcmp(type, 'turbofan'))
    % Turbina do Compressor
    TET = T04 - (T03 - T08);
    PET = P04 * (1 - (1/n_tc)*(1 - TET/T04))^(gama_tc/(gama_tc-1));
    
    % Turbina do Fan
    T05 = TET - (B+1)*(T08 - T02);
    P05 = PET * (1 - (1/n_tf)*(1 - T05/TET))^(gama_tf/(gama_tf-1));
    
    % Bocal de Saida do Fan
    u_sf = sqrt(2 * n_fn * gama_fn/(gama_fn-1) * R * T08 * (1 - (Pa/P08)^((gama_fn -1)/gama_fn)));
    
    T06 = T05; % nao h� pos-queimador
    P06 = P05;

elseif(strcmp(type, 'turbojet'))
    % Turbina do Compressor
    T05 = T04 - (T03 - T02);
    P05 = P04 * (1 - (1/n_tc)*(1 - T05/T04))^(gama_tc/(gama_tc-1));
    
    % Pos-queimador    
    if(~isempty(T06))   
       f_pq = ((T06/T05)-1) / ((n_bpq*PC)/(Cp*T05) - (T06/T05));
       P06 = P05;
       f = f + f_pq;
    else
        T06 = T05;
        P06 = P05;
    end
else % ramjet
    % nao existe turbinas nem pos-queimador
    T05 = []; P05 = [];
    T06 = T04; P06 = P04; 
end

% Bocal de Saida dos Gases Quentes
u_s = sqrt(2 * n_hn * (gama_hn/(gama_hn - 1)) * R * T06 * (1 - (Pa/P06)^((gama_hn-1)/gama_hn)));

% Resultados finais
u = M * sqrt(gama_d * R * Ta);
T_ma = (((1+f)*u_s - u) + B*(u_sf - u)) / 1000;
TSFC = f / T_ma;

% Saidas
OUT.T02 = T02;
OUT.P02 = P02;
OUT.T03 = T03;
OUT.P03 = P03;
OUT.T04 = T04;
OUT.P04 = P04;
OUT.TET = TET;
OUT.PET = PET;
OUT.T05 = T05;
OUT.P05 = P05;
OUT.T06 = T06;
OUT.P06 = P06;
OUT.T08 = T08;
OUT.P08 = P08;

OUT.u_s = u_s;
OUT.u_sf = u_sf;

OUT.f = f;
OUT.f_pq = f_pq;

OUT.u = u;
OUT.T_ma = T_ma;
OUT.TSFC = TSFC;
end
