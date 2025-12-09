# Make a color palette with NYCC colors for scale\_\*\_nycc

Make a color palette with NYCC colors for scale\_\*\_nycc

## Usage

``` r
scale_nycc(palette = "mixed", reverse = FALSE, ...)
```

## Arguments

- palette:

  One of
  `"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"`.
  When palette is set to "single" or "double", it returns the first
  color and first and second color from the "main" palette respectively.

- reverse:

  Boolean, reverse the order of the selected palette

- ...:

  Further arguments passed to `colorRampPalette`

## Value

A function made by `colorRampPalette`
