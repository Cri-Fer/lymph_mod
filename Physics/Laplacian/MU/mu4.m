function f = mu4

f = @(x, y) (115 .* (x <= 0.5) + 23 .* (x>0.5)) * 1e-4; 

end