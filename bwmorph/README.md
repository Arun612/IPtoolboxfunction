# bwmorph — Binary Image Morphological Operations

## Description

`bwmorph` applies **morphological operations** to a binary image using a flat
3×3 structuring element. For every pixel, it examines the 3×3 neighbourhood
and applies the chosen operation:

```
dilate : BW_out(i,j) = 1  if  sum(window) > 0
erode  : BW_out(i,j) = 1  if  sum(window) == 9
open   : erode followed by dilate  (removes small noise)
close  : dilate followed by erode  (fills small holes)
```

The result allows **shape analysis and binary image cleanup** — dilation grows
foreground regions, erosion shrinks them, opening removes isolated pixels, and
closing seals interior gaps.

This is a Scilab reimplementation of the Octave `image` package function
`bwmorph`.

---

## Calling Sequence

```scilab
BW_out = bwmorph(BW, operation)
```

---

## Parameters

| Parameter   | Type          | Default      | Description |
|-------------|---------------|--------------|-------------|
| `BW`        | 2D matrix     | *(required)* | Input binary image (any numeric matrix; thresholded internally to 0/1) |
| `operation` | string        | *(required)* | Morphological operation to apply (see below) |
| `BW_out`    | 2D matrix     | *(output)*   | Result binary image, same size as `BW` |

### Supported Operations

| Value       | Behaviour |
|-------------|-----------|
| `'dilate'`  | Expand foreground — a pixel is 1 if **any** neighbour in the 3×3 window is 1 |
| `'erode'`   | Shrink foreground — a pixel is 1 only if **all** 9 pixels in the 3×3 window are 1 |
| `'open'`    | Erode then dilate — removes isolated foreground pixels (noise) |
| `'close'`   | Dilate then erode — fills isolated background holes inside objects |

---

## Files

| File                  | Purpose |
|-----------------------|---------|
| `bwmorph.sci`         | Main function + `morph_core` helper |
| `bwmorph_tests.sce`   | Test suite (4 test cases) |
| `README.md`           | This file |

---

## How to Run

1. Open Scilab
2. Navigate to this folder using `cd` or the file browser
3. To load and use:
```scilab
exec('bwmorph.sci', -1);
BW = zeros(10,10);
BW(4:6,4:6) = 1;
BW_out = bwmorph(BW, 'dilate')
```
4. To run all tests:
```scilab
exec('bwmorph_tests.sce', -1);
```

---

## Test Cases

### Test 1 — Basic 3×3 foreground block (dilate and erode)

```scilab
BW = zeros(10,10);
BW(4:6,4:6) = 1;
dil = bwmorph(BW, "dilate");
ero = bwmorph(BW, "erode");
disp(sum(sum(dil)));
disp(sum(sum(ero)));
```

Expected output:
```
25     // dilate grows the 3×3 block to a 5×5 region
1      // erode shrinks it to only the single centre pixel
```
*Dilation expands one pixel outward in all directions; erosion retains only pixels fully surrounded by foreground.*

---

### Test 2 — Single foreground pixel

```scilab
BW2 = zeros(10,10);
BW2(5,5) = 1;
disp(sum(bwmorph(BW2,"dilate")));
disp(sum(bwmorph(BW2,"erode")));
```

Expected output:
```
9      // dilate spreads the single pixel to its full 3×3 neighbourhood
0      // erode removes it — no pixel has all 9 neighbours as 1
```
*A lone pixel cannot survive erosion since its neighbourhood is never fully foreground.*

---

### Test 3 — Open operation removes isolated noise pixel

```scilab
BW3 = zeros(10,10);
BW3(4:6,4:6) = 1;
BW3(2,2) = 1;           // isolated noise pixel
open_img = bwmorph(BW3, "open");
disp(sum(sum(open_img)));
```

Expected output:
```
1      // main block survives; isolated pixel at (2,2) is eliminated
```
*Opening (erode → dilate) destroys small isolated foreground regions that cannot survive erosion.*

---

### Test 4 — Close operation fills interior hole

```scilab
BW4 = zeros(10,10);
BW4(4:6,4:6) = 1;
BW4(5,5) = 0;           // hole punched in centre
close_img = bwmorph(BW4, "close");
disp(sum(sum(close_img)));
```

Expected output:
```
9      // all 9 pixels of the 3×3 block are restored
```
*Closing (dilate → erode) seals small interior gaps that dilation can reach and erosion then preserves.*

---

## Algorithm Overview

1. Validate inputs: require exactly 2 arguments; threshold `BW` to logical 0/1
2. Dispatch to the requested operation string
3. For `'dilate'` and `'erode'`, call `morph_core(BW, mode)` directly
4. For `'open'`: call `morph_core(BW, 'erode')` → pass result to `morph_core(..., 'dilate')`
5. For `'close'`: call `morph_core(BW, 'dilate')` → pass result to `morph_core(..., 'erode')`
6. Inside `morph_core`: zero-pad the image by 1 pixel on all sides
7. Slide a 3×3 window over every pixel; apply sum threshold (`> 0` for dilate, `== 9` for erode)
8. Return the resulting binary matrix

---

## Notes

- Input `BW` does not need to be strictly binary — any non-zero value is treated as foreground via `BW = BW > 0`
- The structuring element is always a flat 3×3 block (all ones); custom SE shapes are not supported
- Border handling uses zero-padding, so edge pixels are treated as surrounded by background
- `morph_core` is defined inside the same `.sci` file — no external dependencies
- For very large binary images, performance can be improved by replacing the double loop with convolution-based operations; this implementation prioritises readability
