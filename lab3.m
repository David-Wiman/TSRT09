s = tf('s');

%% Task 2
% It is required to run simulink before this task, but simulink requires
% varaibles from later tasks to compile. Run them before this one.

task2a = out.task2a;
task2b = out.task2b;
task2c = out.task2c;

times = linspace(0, 15, length(task2a));

figure(2)
plot(times, task2a+task2b, times, task2c); % Should be the same if super position holds
legend('a + b', 'c')

%% Task 5

c = 0:0.01:10;
h = 3;
d = 2;

figure(51)
plot(c, dfcube(c,h))

figure(52)
plot(c, dfsat(c,[d,h]))

figure(53)
plot(c, dfdeadz(c,[d,h]))

figure(54)
plot(c, dfreldz(c,[d,h]))

%% Task 6

G = tf( 45, [1 10 9 0]);
c = [0.2121, 0.5, 0.6, 0.7]; % If c <= d we get wierd behaviour
w = [3, 10];
h = 1;
d = 0.2;
dfplot('dfreldz', [d,h], c, G, w)

%% Task 10

K = 0.5;

%% Task 11

td = 1.24;
beta = 0.07;
K = 0.27;

Flead = K * (td*s + 1) / (beta*td*s + 1);

%% Task 12

td = 1.24;
beta = 0.07;
K = 3.83*0.27;

Flead = K*(td*s + 1) / (beta*td*s + 1);

%% Task 14

K = 100; %  K = 52.1 to get graph touching circle & K = 100 still stable

G = K / (s*(s^2 + 4*s + 16));

ciplot(1, 0.2, G, [1, 10, 100])

%% Task 15

K = 167.61; % K = 167.61 is the biggest stable K

G = K / (s*(s^2 + 4*s + 16));

ciplot(1, 0.2, G, [1, 10, 100])

%% Task 16

A = [0 1 ; 0 0];

B = [0 ; 1];

C = [1 0];

D = 0;

% Fun test, alot faster, ~100x
Q1 = [100000 0 ; 0 10];
Q2 = 0.00001;
L = lqr(A, B, Q1, Q2);

L = place(A, B, [-2, -2.3]); % Ad hoc tuned to get time constant 1

Gc_no_feedforward = ss(A-B*L, B, C, D);

Lr = pinv( dcgain( Gc_no_feedforward ) );

Gc = ss(A-B*L, B*Lr, C, D);

step(Gc);