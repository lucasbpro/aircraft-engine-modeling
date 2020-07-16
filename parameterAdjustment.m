function parAdj = parameterAdjustment(rpm, Ta, Pa)

% parAdj = parameterAdjustment(rpm, Ta, Pa)
%       This function adjust the parameters of the engine to account for
%       specific flight operating conditions (rotation, temperature/pressure)
%

% Correção da temperatura na câmara de combustão 
parAdj.T04 = 5.55*rpm^4-13.13*rpm^3+11.96*rpm^2-4.67*rpm+1.28;

% Correção da razão de compressão 
parAdj.Pr = 1.28*rpm^2-0.73*rpm+0.45;

% Correção da vazão de ar - nível do mar
parAdj.ma0 = 1.1*rpm-0.0952;

% Correção da vazão de ar - na altitude de voo
parAdj.mar = parAdj.ma0*(288.15/101.30)*(Pa/Ta);

end
