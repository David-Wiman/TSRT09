%load jasmodell
%jas
%jastraj

% The open system does not live up to the requirements of the closed loop
% system

% All measured outputs need feedback to reach their target value, none of
% them stay at 1

% Yes, the system is stable, all poles have negative real parts

% The system is fairly coupled
% Input 1 (skevroder) is good at controlling output 2 (rollhastighet)
% Input 2 (sidroder) is good at controlling output 1 (beta)

% The airplane is heavily influenced by wind, large terms in H



pole(G);

tzero(G);

figure(1)
sigma(G);

figure(2)
step(G);

G_freq = freqresp(G, 0);
RGA = G_freq.*pinv(G_freq.');

norm(G, Inf);
