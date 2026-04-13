# Scilab Image Processing Toolbox Functions

This project contains Scilab implementations of selected image processing functions inspired by the Octave image package. The goal is to reproduce core functionality while maintaining clarity, correctness, and proper testing.

---

## Implemented Functions

### 1. rangefilt
Computes the local intensity range (max − min) within a neighbourhood for each pixel.

- Highlights edges and texture
- Supports custom neighbourhood masks
- Includes multiple padding options

---

### 2. stretchlim
Estimates intensity limits based on percentiles.

- Ignores extreme outliers
- Useful for contrast stretching
- Default tolerance: [0.01, 0.99]

---

### 3. bwmorph
Performs binary morphological operations.

Supported operations:
- dilate — expands white regions
- erode — shrinks white regions
- open — removes small noise
- close — fills small holes

---

## Project Structure

Arun_IPtoolboxfunction/
│
├── rangefilt/
│   ├── rangefilt.sci
│   ├── rangefilt_test.sce
│   ├── README.md
│
├── stretchlim/
│   ├── stretchlim.sci
│   ├── stretchlim_test.sce
│   ├── README.md
│
├── bwmorph/
│   ├── bwmorph.sci
│   ├── bwmorph_test.sce
│   ├── README.md

---

## How to Run

1. Open Scilab
2. Navigate to the function folder using:
   cd('path_to_folder')

3. Load the function:
   exec('function_name.sci', -1);

4. Run test script:
   exec('function_name_test.sce', -1);

---

## Key Features

- Implemented from scratch in Scilab
- Matches behavior of Octave equivalents
- Includes multiple test cases for validation
- Handles edge cases (uniform images, gradients, noise)
- Modular and readable code structure

---

## Notes

- rangefilt uses nested loops; performance may decrease for large images
- stretchlim is based on percentile estimation
- bwmorph uses a fixed 3×3 structuring element
- Advanced morphological operations (e.g., skeletonization) are not included

---

## Purpose

This project demonstrates:
- Understanding of image processing algorithms
- Ability to translate logic into Scilab
- Testing and validation of numerical methods
- Clean code organization and documentation

---

## Author

Arun