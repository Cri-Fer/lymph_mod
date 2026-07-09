function f = mu8

r = 0.1;
x0 = 0.75;
y0 = 0.42;
% 0.03 and 0.25 are the coductivity of a healty tissue and a tumor
% tissue respectively (mammella)
f = @(x, y)  0.25  * ((x-x0).^2 + (y-y0).^2 <= r^2) + ...
             0.03  * ((x-x0).^2 + (y-y0).^2  > r^2);

end