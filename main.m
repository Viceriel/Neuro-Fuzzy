clc, clear, close all;

M = .5;
m = 0.2;
b = 0.1;
I = 0.006; 
g = 9.8; 
l = 0.3;

[F, G, C, K, delta] = pendulum(M, m, b, I, g, l);
[dataset, norm] = createDataset(F, G, C, K, delta, 0);

j = 1;
for i = 1 : 4900 : 490000
   
    data(j, :) = dataset(1 : 6, i);
    j = j + 1;
end

net = RBFnetwork([6, 100, 1], 0.01, data);
net = UncontrolledLearning(net, dataset(1 : 6, :)', 0.7);
%dataset(7, :) = (dataset(7, :) / (max(max(dataset(7, :)), -min(dataset(7, :)))) + 1) / 2;

% net = Network([6 10 1], 0.2, 3);
net = train(net, dataset, 8);
w(1 : 500) = 2;
[y_n, u_n] = test(net, F, G, C, w, norm);
% 
% plot(y_n(1, :));
% hold all
% plot(y_n(2, :));