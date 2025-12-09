# Make a color palette with NYCC colors. Second iteration from nycc_pal.

Make a color palette with NYCC colors. Second iteration from nycc_pal.

## Usage

``` r
pal_nycc(palette = "main", reverse = FALSE)
```

## Arguments

- palette:

  One of
  `"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"`.
  When palette is set to "single" or "double", it returns the first
  color and first and second color from the "main" palette respectively.

- reverse:

  Boolean, reverse the order of the selected palette

## Value

The palette inputted, forward or reverse, grabbed from nycc_palettes and
with additional palette options for `"single", "double"`
