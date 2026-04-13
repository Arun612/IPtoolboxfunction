function limits = stretchlim(IM, tol)

    // default tol
    if argn(2) < 2 then
        tol = [0.01, 0.99];
    end

    IM = double(IM);

    // flatten
    vec = IM(:);

    // sort
    vec = gsort(vec, 'g', 'i');

    N = length(vec);

    // compute indices
    low_idx  = round(tol(1) * N);
    high_idx = round(tol(2) * N);

    // avoid index 0
    if low_idx < 1 then low_idx = 1; end

    low  = vec(low_idx);
    high = vec(high_idx);

    limits = [low, high];

endfunction