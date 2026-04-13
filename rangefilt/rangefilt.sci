// rangefilt.sci
// Computes local intensity range in a neighbourhood around each pixel
// R = max(X) - min(X) where X is the pixel values in the neighbourhood
//
// Calling Sequence:
//   R = rangefilt(IM)
//   R = rangefilt(IM, DOMAIN)
//   R = rangefilt(IM, DOMAIN, PADDING)
//
// Parameters:
//   IM      - Input grayscale image (2D matrix, double or uint8)
//   DOMAIN  - Binary mask defining neighbourhood (default: ones(3,3))
//   PADDING - Border padding method: 'symmetric' (default), 'replicate',
//             'zeros', 'circular'
//   R       - Output image with local intensity range values

function R = rangefilt(IM, DOMAIN, PADDING)

    // ---------- input validation ----------
    if ~isreal(IM) | ndims(IM) > 2 then
        error("rangefilt: IM must be a 2D real matrix");
    end

    // ---------- default arguments ----------
    if argn(2) < 2 | isempty(DOMAIN) then
        DOMAIN = ones(3, 3);
    end

    if argn(2) < 3 then
        PADDING = 'symmetric';
    end

    // ---------- convert to double for arithmetic ----------
    IM = double(IM);

    // ---------- neighbourhood size ----------
    [dm, dn] = size(DOMAIN);
    pad_r = floor(dm / 2);
    pad_c = floor(dn / 2);

    // ---------- pad the image ----------
    padded = pad_image(IM, pad_r, pad_c, PADDING);

    // ---------- original image size ----------
    [rows, cols] = size(IM);

    // ---------- output matrix ----------
    R = zeros(rows, cols);

    // ---------- get neighbourhood offsets from DOMAIN ----------
    [dr, dc] = find(DOMAIN);   // rows and cols of active elements in mask

    // ---------- slide window ----------
    for i = 1:rows
        for j = 1:cols
            // extract neighbourhood values using domain mask
            vals = [];
            for k = 1:length(dr)
                pi = i + dr(k) - 1;   // row index in padded image
                pj = j + dc(k) - 1;   // col index in padded image
                vals = [vals, padded(pi, pj)];
            end
            R(i, j) = max(vals) - min(vals);
        end
    end

endfunction


// -----------------------------------------------------------------------
// Helper: pad_image
// Pads a 2D matrix on all four sides by (pr rows, pc cols)
// Methods: 'symmetric', 'replicate', 'zeros', 'circular'
// -----------------------------------------------------------------------
function P = pad_image(IM, pr, pc, method)

    [rows, cols] = size(IM);

    select method

    case 'zeros'
        P = zeros(rows + 2*pr, cols + 2*pc);
        P(pr+1:pr+rows, pc+1:pc+cols) = IM;

    case 'replicate'
        P = zeros(rows + 2*pr, cols + 2*pc);
        // center
        P(pr+1:pr+rows, pc+1:pc+cols) = IM;
        // top and bottom rows
        for i = 1:pr
            P(i, pc+1:pc+cols)          = IM(1, :);
            P(pr+rows+i, pc+1:pc+cols)  = IM(rows, :);
        end
        // left and right cols
        for j = 1:pc
            P(pr+1:pr+rows, j)          = IM(:, 1);
            P(pr+1:pr+rows, pc+cols+j)  = IM(:, cols);
        end
        // corners
        P(1:pr, 1:pc)                               = IM(1,1);
        P(1:pr, pc+cols+1:pc+cols+pc)               = IM(1,cols);
        P(pr+rows+1:pr+rows+pr, 1:pc)               = IM(rows,1);
        P(pr+rows+1:pr+rows+pr, pc+cols+1:pc+cols+pc) = IM(rows,cols);

    case 'circular'
        P = zeros(rows + 2*pr, cols + 2*pc);
        // center
        P(pr+1:pr+rows, pc+1:pc+cols) = IM;
        // top rows wrap from bottom of IM
        for i = 1:pr
            P(pr+1-i, pc+1:pc+cols) = IM(rows+1-i, :);
        end
        // bottom rows wrap from top of IM
        for i = 1:pr
            P(pr+rows+i, pc+1:pc+cols) = IM(i, :);
        end
        // left cols wrap from right of IM
        for j = 1:pc
            P(pr+1:pr+rows, pc+1-j) = IM(:, cols+1-j);
        end
        // right cols wrap from left of IM
        for j = 1:pc
            P(pr+1:pr+rows, pc+cols+j) = IM(:, j);
        end
        // corners (wrap both)
        for i = 1:pr
            for j = 1:pc
                P(pr+1-i, pc+1-j)           = IM(rows+1-i, cols+1-j);
                P(pr+1-i, pc+cols+j)         = IM(rows+1-i, j);
                P(pr+rows+i, pc+1-j)         = IM(i, cols+1-j);
                P(pr+rows+i, pc+cols+j)      = IM(i, j);
            end
        end

    else  // default: symmetric (mirror)
        P = zeros(rows + 2*pr, cols + 2*pc);
        // center
        P(pr+1:pr+rows, pc+1:pc+cols) = IM;
        // top rows (mirror)
        for i = 1:pr
            P(pr+1-i, pc+1:pc+cols) = IM(i, :);
        end
        // bottom rows (mirror)
        for i = 1:pr
            P(pr+rows+i, pc+1:pc+cols) = IM(rows+1-i, :);
        end
        // left cols (mirror)
        for j = 1:pc
            P(pr+1:pr+rows, pc+1-j) = IM(:, j);
        end
        // right cols (mirror)
        for j = 1:pc
            P(pr+1:pr+rows, pc+cols+j) = IM(:, cols+1-j);
        end
        // corners (mirror both)
        for i = 1:pr
            for j = 1:pc
                P(pr+1-i, pc+1-j)       = IM(i, j);
                P(pr+1-i, pc+cols+j)    = IM(i, cols+1-j);
                P(pr+rows+i, pc+1-j)    = IM(rows+1-i, j);
                P(pr+rows+i, pc+cols+j) = IM(rows+1-i, cols+1-j);
            end
        end
    end

endfunction
