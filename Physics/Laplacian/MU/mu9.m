function f = mu9

r1 = 0.15;
r2 = 0.35;
x0 = 0.5;
y0 = 0.5;
iron_coeff = 23e-2;       % (cm^2/s)
concrete_coeff = 0.5e-2;  % (cm^2/s)

f = @(x,y) concrete_coeff + ...
           (iron_coeff - concrete_coeff) .* ...
           ( ((x-x0).^2 + (y-y0).^2 >= r1^2) & ...
             ((x-x0).^2 + (y-y0).^2 <= r2^2) );

end
