# rangefilt — Local Intensity Range Filter

## Description

`rangefilt` computes the **local intensity range** in a neighbourhood around
each pixel in an image. For every pixel, it extracts all values within the
neighbourhood window and computes:

```
R = max(X) - min(X)
```

where `X` is the set of pixel values inside the neighbourhood.

The result highlights **edges and texture** — regions with high local contrast
appear bright, while flat regions appear dark (range = 0).

This is a Scilab reimplementation of the Octave `image` package function
`rangefilt`.

---

## Calling Sequence

```scilab
R = rangefilt(IM)
R = rangefilt(IM, DOMAIN)
R = rangefilt(IM, DOMAIN, PADDING)
```

---

## Parameters

| Parameter | Type          | Default       | Description |
|-----------|---------------|---------------|-------------|
| `IM`      | 2D matrix     | *(required)*  | Input grayscale image (double or uint8) |
| `DOMAIN`  | binary matrix | `ones(3,3)`   | Neighbourhood mask — non-zero elements define which pixels are included |
| `PADDING` | string        | `'symmetric'` | Border extrapolation method (see below) |
| `R`       | 2D matrix     | *(output)*    | Local intensity range image, same size as `IM` |

### Padding Options

| Value         | Behaviour |
|---------------|-----------|
| `'symmetric'` | Mirror pixels at the border *(default)* |
| `'replicate'` | Repeat the edge pixel value |
| `'zeros'`     | Pad with 0s |
| `'circular'`  | Wrap around (tiling) |

---

## Files

| File                | Purpose |
|---------------------|---------|
| `rangefilt.sci`     | Main function + `pad_image` helper |
| `rangefilt.sce`     | Test suite (4 test cases) |
| `README.md`         | This file |

---

## How to Run

1. Open Scilab
2. Navigate to this folder using `cd` or the file browser
3. To load and use:
```scilab
exec('rangefilt.sci', -1);
A = [1 2 3; 4 5 6; 7 8 9];
R = rangefilt(A)
```
4. To run all tests:
```scilab
exec('rangefilt.sce', -1);
```

---

## Test Cases

### Test 1 — Random 100×100 image (checks non-zero output)

```scilab
img1 = grand(100,100,'uin',0,255);
out1 = rangefilt(img1);
disp(max(out1));
```

Expected output:
```
255
```
*A random image with values spread across 0–255 will produce a max range of 255 in at least one neighbourhood.*

---

### Test 2 — Black image (all zeros, range must be zero)

```scilab
img2 = zeros(100,100);
out2 = rangefilt(img2);
disp(max(out2));
```

Expected output:
```
0
```
*Every neighbourhood contains identical values (0), so max − min = 0 everywhere.*

---

### Test 3 — White image (all 255, range must be zero)

```scilab
img3 = ones(100,100)*255;
out3 = rangefilt(img3);
disp(max(out3));
```

Expected output:
```
0
```
*A perfectly uniform image has no local contrast — range is 0 at every pixel.*

---

### Test 4 — Horizontal gradient image

```scilab
img4 = repmat(0:99, 100, 1);
out4 = rangefilt(img4);
disp([min(out4), max(out4)]);
Matplot(out4);
```

Expected output:
```
1   2
```
*Interior pixels span exactly 2 columns of the gradient (difference = 2); edge columns
span only 1 step due to symmetric padding, giving a minimum range of 1.*

---

## Algorithm Overview

1. Validate input: `IM` must be a 2D real matrix
2. Set defaults: `DOMAIN = ones(3,3)`, `PADDING = 'symmetric'`
3. Convert `IM` to `double` for arithmetic
4. Compute padding amounts: `pad_r = floor(dm/2)`, `pad_c = floor(dn/2)`
5. Pad the image using the chosen method via `pad_image()`
6. Find active offsets in `DOMAIN` using `find(DOMAIN)`
7. For each pixel `(i,j)`, collect values at all active domain positions
8. Compute `R(i,j) = max(vals) - min(vals)`
9. Return `R`

---

## Notes

- Works on any 2D real matrix (not just images)
- `uint8` inputs are automatically converted to `double` for arithmetic
- Passing an empty matrix `[]` as `DOMAIN` falls back to the default `ones(3,3)`
- The `pad_image` helper is defined inside the same `.sci` file — no external dependencies
- For very large images and domains, performance can be improved by vectorising the inner loop; this implementation prioritises readability
