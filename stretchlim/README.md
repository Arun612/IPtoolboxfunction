# stretchlim — Contrast Stretch Limits

## Description

`stretchlim` computes the **low and high intensity limits** for contrast stretching
an image. For a given image and tolerance, it finds the pixel intensity values at
the specified low and high percentile positions in the sorted pixel distribution:

```
limits = [vec(round(tol(1) * N)), vec(round(tol(2) * N))]
```

where `vec` is the sorted (ascending) list of all pixel values and `N` is the total
number of pixels.

The result is a two-element vector `[low, high]` that can be passed to `imadjust`
or similar functions to **clip and rescale** the image intensity, enhancing contrast
by saturating a small fraction of the darkest and brightest pixels.

This is a Scilab reimplementation of the MATLAB / Octave `stretchlim` function.

---

## Calling Sequence

```scilab
limits = stretchlim(IM)
limits = stretchlim(IM, tol)
```

---

## Parameters

| Parameter | Type          | Default        | Description |
|-----------|---------------|----------------|-------------|
| `IM`      | 2D matrix     | *(required)*   | Input grayscale image (double or uint8) |
| `tol`     | 1×2 vector    | `[0.01, 0.99]` | Low and high percentile fractions (values in [0, 1]) |
| `limits`  | 1×2 vector    | *(output)*     | Intensity values `[low, high]` at the specified percentiles |

### Tolerance Notes

| `tol` value      | Behaviour |
|------------------|-----------|
| `[0.01, 0.99]`   | Saturates the bottom 1% and top 1% of pixels *(default)* |
| `[0, 1]`         | Returns the true minimum and maximum of the image |
| `[0.05, 0.95]`   | More aggressive clipping — useful for images with bright/dark outliers |

---

## Files

| File              | Purpose |
|-------------------|---------|
| `stretchlim.sci`  | Main function |
| `stretchlim.sce`  | Test suite (4 test cases) |
| `README.md`       | This file |

---

## How to Run

1. Open Scilab
2. Navigate to this folder using `cd` or the file browser
3. To load and use:
```scilab
exec('stretchlim.sci', -1);
A = grand(100, 100, 'uin', 0, 255);
limits = stretchlim(A)
```
4. To run all tests:
```scilab
exec('stretchlim.sce', -1);
```

---

## Test Cases

### Test 1 — Random 100×100 image

```scilab
img1 = grand(100,100,'uin',0,255);
disp(stretchlim(img1));
```

Expected output (approximate):
```
2.   253.
```
*A uniformly random image spreads values across 0–255. The 1st percentile falls near
2 and the 99th percentile near 253, clipping the extreme tails.*

---

### Test 2 — Black image (all zeros)

```scilab
img2 = zeros(100,100);
disp(stretchlim(img2));
```

Expected output:
```
0.   0.
```
*Every pixel is 0, so both percentiles resolve to 0 — there is no intensity range to stretch.*

---

### Test 3 — White image (all 255)

```scilab
img3 = ones(100,100)*255;
disp(stretchlim(img3));
```

Expected output:
```
255.   255.
```
*Every pixel is 255, so both percentiles resolve to 255 — the image is uniformly bright
with no contrast to enhance.*

---

### Test 4 — Horizontal gradient image

```scilab
img4 = repmat(0:99, 100, 1);
disp(stretchlim(img4));
```

Expected output (approximate):
```
1.   99.
```
*The gradient spans 0–99. At 1% of 10 000 pixels the low limit lands at index 100
(value 1) and at 99% it lands at index 9 900 (value 99), correctly capturing the
usable range of the gradient.*

---

## Algorithm Overview

1. Apply default `tol = [0.01, 0.99]` if not supplied
2. Convert `IM` to `double` for arithmetic
3. Flatten `IM` into a column vector `vec`
4. Sort `vec` in ascending order using `gsort`
5. Compute `low_idx  = round(tol(1) * N)` and `high_idx = round(tol(2) * N)`
6. Clamp `low_idx` to a minimum of 1 to avoid a zero index
7. Read off `low = vec(low_idx)` and `high = vec(high_idx)`
8. Return `limits = [low, high]`

---

## Notes

- Works on any 2D real matrix (not just images)
- `uint8` inputs are automatically converted to `double` before processing
- `tol` must be a two-element vector with `tol(1) <= tol(2)` and both values in `[0, 1]`
- A `tol` of `[0, 1]` is equivalent to `[min(IM(:)), max(IM(:))]`
- No external dependencies — the function is entirely self-contained in `stretchlim.sci`
- For very large images the `gsort` step dominates runtime; the rest of the function is O(1)
