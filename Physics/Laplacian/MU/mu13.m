function f = mu13

f = @(x, y) 82 * (y < 0.25 | y > 0.75) + 8e-2 * (y >= 0.25 & y <= 0.75);
    
end