%% Task 3

h = 3;
d = 2;

% saturation

% gain = h/d
% saturaion = [-h,h]

% relay with deadzone

% dead zone = [-d,d]
% gain = h

%% Task 4

G = tf(30,[1 4 7 1]);
w = [2.64:0.001:2.65];
c = [2,3,4,5];
dfplot('dfsat',[2,3],c,G,w)

%% Task 9

A = [0 1 ; 0 0];

B = [0 ; 1];

C = [1 0];

D = 0;

L = place(A, B, [-30, -40]); %Beräknar återkopplingsmatrisen

Gc_no_feedforward = ss(A-B*L,B,C,D);

Lr = pinv(dcgain(Gc_no_feedforward)); %Beräknar framkopplingsmarisen

Gc = ss(A-B*L, B*Lr, C, D); %Beräknar det slutna systemet

step(Gc);
