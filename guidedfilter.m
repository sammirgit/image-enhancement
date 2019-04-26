function q = guidedfilter(I, p, r, eps)

[hei, wid] = size(I);
N = sum_work(ones(hei, wid), r); % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = sum_work(I, r) ./ N;
mean_p = sum_work(p, r) ./ N;
mean_Ip = sum_work(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = sum_work(I.*I, r) ./ N;
var_I = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = sum_work(a, r) ./ N;
mean_b = sum_work(b, r) ./ N;

q = mean_a .* I + mean_b; % Eqn. (8) in the paper;
end