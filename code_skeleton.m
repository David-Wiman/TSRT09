% Kodskelett till lösningar på förberedelseuppgifter
% Laboration: "Robust reglerdesign av JAS 39 Gripen"

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definitioner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = tf('s');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Läs!

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = 0.3;
k = 1;

G = k/(s*T+1);

step(G);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Definitioner av S, T och Gwu, se kap. 6.1 i läroboken.
% feedback(A,B) ger överföringsmatrisen (I+A*B)^(-1)*A. Vad skall A, B vara
% för S, T och Gwu?
% Det kan vara bra att använda "minreal".

G  = eye(3)/s; % dummy
Fy = eye(3); % dummy

S = feedback( eye(3), G*Fy );
T = feedback( G*Fy, eye(3) );
Gwu = -feedback( Fy, G );

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gör för hand! (Detta är en omfattande uppgift som tar tid.)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %--------------- a) --------------------
% Förbered figurer för de kombinationer av a,b,c som anges i uppgiften.

% ---------------- Fallet c = 1, a > b: -------------------
W1 = W_help(1,5,1,1);
figure(51)
bodemag(W1)
title('c = 1, a > b')

% ---------------- Fallet c= 1, a < b: --------------------
W2 = W_help(1,1,5,1);
figure(52)
bodemag(W2)
title('c= 1, a < b')

% ---------------- Fallet a = inf: ------------------------
W3 = W_help(1,inf,1,1);
figure(53)
bodemag(W3)
title('a = inf')
    
% ---------------- Fallet c = 0:   ------------------------
W4 = W_help(1,1,1,0);
figure(54)
bodemag(W4)
title('c = 0')

% Observera: Var hamnar brytpunkterna? Vad är förstärkningen då w->0 resp.
% w->infty ?

% %--------------- b) --------------------
H = W_help(1, inf, 3*2*pi, 10^(3/19.5))*W_help(10^(3/19.5), 3*2*pi, 3*2*pi, 0);
figure(55)
bodemag(H)
title('Bandpass filter centered at 3 Hz = 18.8496 rad/s')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %--------------- a) --------------------
G11 = 1/(s+1);
G12 = 1/((s+1)*(s+4));
G21 = 1/(s+3);
G22 = 1/((s+1)*(s+5));
G  = [G11, G12 ; G21, G22];

dim_u = size(G,2); % Antalet kolonner är antalet inputs
Fy_a = eye(dim_u);

% Bestäm känslighetsfunktionerna, se uppg. 3.
S_a = feedback( eye(dim_u), G*Fy_a );
T_a = feedback( G*Fy_a, eye(dim_u) );
Gwu_a = -feedback( Fy_a, G );

figure(61)
sigma(S_a)
title('Singular values of S_a')

figure(62)
sigma(T_a)
title('Singular values of T_a')

figure(63)
sigma(Gwu_a)
title('Singular values of Gwu_a')

% %--------------- b) --------------------
Wt  = [s/(0.3*s+1), 0 ; 0, s/(0.3*s+1)];
Ws  = [1/(2*s+1), 0 ; 0, 1/(2*s+1)];
Wu  = [s/(3*s+1), 0 ; 0, s/(3*s+1)];

% % Se avsnitt 4 i labb-pm för hur Fy kan bestämmas med kommandot hinfsyn.

Ge = minreal( [zeros(2,2), Wu ; zeros(2,2), Wt*G ; Ws, Ws*G ; eye(2), G] );

Fy_b = hinfsyn(Ge, 2, 2, 'GMIN', 0.1, 'GMAX', 100, 'TOLGAM', 0.01);

Fy_b = -Fy_b;

% Bestäm känslighetsfunktionerna.
S_b = feedback( eye(dim_u), G*Fy_b );
T_b = feedback( G*Fy_b, eye(dim_u) );
Gwu_b = -feedback( Fy_b, G );

figure(64)
sigma(S_b)
title('Singular values of S_b')

figure(65)
sigma(T_b)
title('Singular values of T_b')

figure(66)
sigma(Gwu_b)
title('Singular values of Gwu_b')

%--------------- c) --------------------
Wt  = [10*(s+1)/(0.3*s+1), 0 ; 0, 10*(s+1)/(0.3*s+1)];
Ws  = [1/(2*s+1), 0 ; 0, 1/(2*s+1)];
Wu  = [s/(3*s+1), 0 ; 0, s/(3*s+1)];

Ge = minreal( [zeros(2,2), Wu ; zeros(2,2), Wt*G ; Ws, Ws*G ; eye(2), G] );

% Bestäm Fy
Fy_c = hinfsyn(Ge, 2, 2, 'GMIN', 0.1, 'GMAX', 100, 'TOLGAM', 0.01);

Fy_c = -Fy_c;

% Bestäm känslighetsfunktionerna.
S_c = feedback( eye(dim_u), G*Fy_c );
T_c = feedback( G*Fy_c, eye(dim_u) );
Gwu_c = -feedback( Fy_c, G );

figure(67)
sigma(S_c)
title('Singular values of S_c')

figure(68)
sigma(T_c)
title('Singular values of T_c')

figure(69)
sigma(Gwu_c)
title('Singular values of Gwu_c')

%--------------------------------------
% Jämför resultat
figure(610)
sigma(S_a,S_b,S_c)
legend('a','b','c','location','southeast')
title('S')

figure(611)
sigma(T_a,T_b,T_c)
legend('a','b','c','location','southwest')
title('T')

figure(612)
sigma(Gwu_a,Gwu_b,Gwu_c)
legend('a','b','c','location','southwest')
title('Gwu')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Detta är en omfattande uppgift som tar lång tid. Konstruera
% diagonalelementen till WS, WT och WU som lågpass/högpass/bandpass filter
% t.ex. med hjälpfunktionen W_help.

WS_beta = W_help(1, inf, 1, 10^(6/20));

WS_p = W_help(1, inf, 3, 10^(8/20));

center_freq = 2*3*pi;
peak_dB = 5/2 + 3;
WS_r = W_help(1, inf, center_freq, 10^(peak_dB/20)) * W_help(10^(peak_dB/20), center_freq, center_freq, 0);

WS = [  WS_beta    0        0;
        0          WS_p     0;
        0          0        WS_r];
    

WT_component = W_help( 0.3, 40, 40, 0 ); % Stability with pole above 40 rad/s

WT = [  WT_component    0                   0;
        0               WT_component        0;
        0               0                   WT_component];
    
    
WU_component = W_help( 10^(3/20), 4*2*pi, 4*2*pi, 0); % Gain less than 3 at 4 Hz = gain less than 9.54 dB at 25 rad/s

WU = [  WU_component    0                   0;
        0               WU_component        0;
        0               0                   WU_component];

figure(71)
sigma(WS,WT,WU)
legend('WS', 'WT', 'WU')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se tips i kompendiet.

G_tilde = minreal( feedback( G(1:2, 1:2), Fy(1:2, 1:2) ) );
Fr0 = pinv(dcgain(G_tilde));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uppgift 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gc = G_tilde*Fr; % Decoupled at steady state
