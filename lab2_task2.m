%% Comments

% k controlls the gain, k = 1/x => lower everything with 20*log10(x) dB

% a controlls the shape => 20*log10(k*b/a) = end value

% b controlls the bandwidth, b = x => bandwidth = x dB

% c controlls the shape => 20*log10(k*c) = start value

%% Ws

Ws_beta = W_help( 1/10, inf, 0.75, 20);

Ws_p = W_help( 1/10, inf, 5, 20);

Ws_r = W_help( 1/(3/2), inf, 3, 1) * W_help( 1/(4/3), 1, 3, 0);

Ws = [  Ws_beta    0        0;
        0          Ws_p     0;
        0          0        Ws_r];

%% Wt

Wt_component = W_help( 1/2.9, 19.5, 127, 1 );

Wt = [  Wt_component    0                   0;
        0               Wt_component        0;
        0               0                   Wt_component];
    
%% Wu

Wu_component = W_help( 1/5, 3.5, 50, 1);

Wu = [  Wu_component    0;
        0               Wu_component];

%% Controller

Ge = minreal(  [zeros(2,3) Wu ;
                zeros(3,3) Wt*G ;
                Ws Ws*G ;
                eye(3) G] );
            
[Fy, cl, gamma, info] = hinfsyn(Ge, 3, 2, 'GMIN', 0.1, 'GMAX', 100, 'TOLGAM', 0.01);
Fy = -Fy;

%% Evaluation, sigma

S = minreal( feedback( eye(3), G*Fy ) );
T = minreal( feedback( G*Fy, eye(3) ) );
Gwu = minreal( -feedback( Fy, G ) );

figure(1)
sigma(S*H) % Should be lower than -40 dB for w < 1 AND < -27 dB for w = 3
title('SH')

figure(2)
delta_G = 1 / tf( [1/40 0] , [1/40 1] );
sigma(T, delta_G) % Should be lower than 1/abs(delta_G) at 40 rad/s AND 10 dB
title('T')

figure(3)
sigma(Gwu) % Not more than 9.5 dB (gain 3) above 25 rad/s (4 Hz)
title('Gwu')

%% Evaluation, step response

G_tilde = minreal( feedback(G*Fy, eye(3)) );

G_tilde = G_tilde(1:2, 1:2);

% prefilter
Fr = pinv(dcgain(G_tilde));

Gc = minreal(G_tilde*Fr);

figure(4)
step( Gc(1,1) )
hold on
plot([0 0.2 2.2 5],[0 0 0.8 0.8 ; 1.2 1.2 1.2 1.2], 'r--')
title('Step in aileron to beta')

figure(5)
step( Gc(2,2) )
hold on
step(tf(1,[0.3 1]),'r--')
title('Step in side rudder to roll velocity')

figure(6)
step(Gc)
title('Step Gc')
