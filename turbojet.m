function params = turbojet()
%%
%   This loads the parameters of the ramjet engine
%%
    params.n_d = 0.97;     % eficiencia do difusor (entrada de ar)
    params.n_f = 0.85;     % eficiencia do fan
    params.n_c = 0.85;     % eficiencia do compressor
    params.n_b = 1.00;     % eficiencia da combustao
    params.n_bpq = 1.00;   % eficiencia da combustao do pos-queimador
    params.n_tc = 0.90;    % eficiencia da turbina do compressor
    params.n_tf = 0.90;    % eficiencia da turbina do fan
    params.n_hn = 0.98;    % eficiencia do bocal de gases quentes
    params.n_fn = 0.98;    % eficiencia do bocal do fan
    params.gama_d = 1.40;    % gama do difusor
    params.gama_f = 1.40;    % gama do fan
    params.gama_c = 1.37;    % gama do compressor
    params.gama_b = 1.35;    % gama da combustao
    params.gama_tc = 1.33;   % gama da turbina do compressor
    params.gama_tf = 1.33;   % gama da turbina do fan
    params.gama_hn = 1.36;   % gama do bocal de gases quentes
    params.gama_fn = 1.40;   % gama do bocal do fan
    params.Prc = 30;       % razao de pressao no compressor
    params.Prf = 1;        % razao de pressao no fan
    params.T04 = 1600;     % temp. na saida da camara de combustao (K)
    params.T06 = [];       % temp. na saida do pos-queimador (K)
    params.B = 0;          % razao de passagem
    params.PC = 45000;     % poder calorifico inferior do combustivel (kJ/kg)
    params.R = 288.3;      % R medio (m^2/(s^2 * K))
    params.Cp = 1.11;      % Cp no combustor (kJ/(kg * K))

end
