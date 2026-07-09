function f= mu14
    seed = 10;
    rng(seed);

    N = 50;
    r = 0.025 * rand(N,1) + 1.5e-3;

    pos = zeros(N,2);
    for k = 1:N
        pos(k,1) = r(k) + (1 - 2*r(k))*rand();
        pos(k,2) = r(k) + (1 - 2*r(k))*rand();
    end

    mu_in  = 1e-2;

    checkerboard_mu = @(x,y) 7e-4 + 5e-3 * ...
    double(mod(floor(x./0.1) + floor(y./0.1), 2) == 0);

f = @(x,y) eval_random_circles_overwrite(x,y,pos,r,checkerboard_mu,mu_in);
end

function val = eval_random_circles_overwrite(x,y,pos,r,base_mu,mu_circle)

    val = base_mu(x,y);

    for k = 1:size(pos,1)
        inside = (x-pos(k,1)).^2 + (y-pos(k,2)).^2 <= r(k)^2;
        val(inside) = mu_circle;
    end
end
