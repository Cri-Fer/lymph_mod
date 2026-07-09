function fh = mu15
    seed = 39;
    rng(seed);

    N = 700;
    r = 0.01 * rand(N,1) + 5e-4;

    pos = zeros(N,2);
    for k = 1:N
        pos(k,1) = r(k) + (1 - 2*r(k))*rand();
        pos(k,2) = r(k) + (1 - 2*r(k))*rand();
    end

    mu_out = 3;
    mu_in  = 1.1e-2;

    fh = @(x,y) eval_random_circles(x,y,pos,r,mu_out,mu_in);
end

function val = eval_random_circles(x,y,pos,r,mu_out,mu_in)
    val = mu_out * ones(size(x));
    for k = 1:size(pos,1)
        inside = (x-pos(k,1)).^2 + (y-pos(k,2)).^2 <= r(k)^2;
        val(inside) = mu_in;
    end
end