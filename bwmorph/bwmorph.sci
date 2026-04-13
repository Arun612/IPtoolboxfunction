function BW_out = bwmorph(BW, operation)


// ---------- input check ----------
if argn(2) < 2 then
    error("Usage: bwmorph(BW, operation)");
end

// ensure binary
BW = BW > 0;

// ---------- operation selection ----------
if strcmp(operation, "dilate") then
    BW_out = morph_core(BW, "dilate");

elseif strcmp(operation, "erode") then
    BW_out = morph_core(BW, "erode");

elseif strcmp(operation, "open") then
    temp = morph_core(BW, "erode");
    BW_out = morph_core(temp, "dilate");

elseif strcmp(operation, "close") then
    temp = morph_core(BW, "dilate");
    BW_out = morph_core(temp, "erode");

else
    error("Unsupported operation. Use dilate, erode, open, or close");
end

endfunction

// -------- CORE MORPH FUNCTION --------
function BW_out = morph_core(BW, mode)


[rows, cols] = size(BW);

// zero padding
padded = zeros(rows+2, cols+2);
padded(2:rows+1, 2:cols+1) = BW;

BW_out = zeros(rows, cols);

for i = 1:rows
    for j = 1:cols

        window = padded(i:i+2, j:j+2);

        if strcmp(mode, "dilate") then
            if sum(window) > 0 then
                BW_out(i,j) = 1;
            end

        elseif strcmp(mode, "erode") then
            if sum(window) == 9 then
                BW_out(i,j) = 1;
            end
        end

    end
end

endfunction
