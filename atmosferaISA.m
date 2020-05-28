function [rho, T, p] = atmosferaISA(h)

% atmosferaISA(h) = retorna as condi��es da atmosfera padr�o (ISA), isto �,
% densidade, temperatura e press�o, para uma determinada altitude (em metros).
%
% Sintaxe:      [rho, T, p] = atmosferaISA(h)
%
%               h - altitude (meters)
%               rho - densidade (kg/m3)
%               T - temperatura (K)
%               p - press�o (Pa)
%%

% Constantes
R = 287;         % constante do g�s ideal
rho_0 = 1.225;   % densidade ISA (a n�vel do mar) - em kg/m3
T0 = 288.15;     % temperatura ISA - em Kelvin
g = 9.81;        % acelera��o da gravidade, em m/s2
dTdh = -6.5e-3;  % derivada da temperatura em fun��o da altitude, em K/m

if h<=11000
    rho = rho_0*(1+ dTdh/T0*h)^(-1/dTdh*(g/R + dTdh));  % densidade 
    T = T0 + dTdh*h;                                    % temperatura 
elseif h>11000 && h<=20000
    h1 = 11000;                                            % fim da troposfera, in�cio da tropopausa
    rho_1 = rho_0*(1+ dTdh/T0*h1)^(-1/dTdh*(g/R + dTdh));  % densidade a 11000 m
    T1 = T0 + dTdh*h1;                                     % temperatura a 11000 m
    
    rho = rho_1*exp(-g/(R*T1)*(h-h1));   % densidade 
    T = T1;                              % temperatura constante nessa faixa    
end;                                                   

p = rho*R*T; 

end