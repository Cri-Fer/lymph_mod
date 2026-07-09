function f = mu7

% height is the y dimension of the square
% length is the x dimension of the square
height = 0.25;
length = 0.5;
f = @(x, y) 10*double(mod(floor(x./length) + floor(y./height), 2) == 0)+1;

end