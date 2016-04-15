clc, clear, close all;

M = .5;
m = 0.2;
b = 0.1;
I = 0.006; 
g = 9.8; 
l = 0.3;

[F, G, C, K, delta] = pendulum(M, m, b, I, g, l);
[dataset, norm] = createDataset(F, G, C, K, delta);
net = Network([6 10 1], 0.2, 3);
net = train(net, dataset, 5);
w(1 : 500) = 2;
[y_n, u_n] = test(net, F, G, C, w, norm);

plot(y_n(1, :));
hold all
plot(y_n(2, :));