function f = mu6

% Dividing for the number 0.1 we get squares of length 0.1 and heigth 0.1
% Changing those numbers cahnge the shape of it

f = @(x, y) 0.5 + 2*double(mod(floor(x./0.01) + floor(y./0.01), 2) == 0);

end