# Render a New York City Council PDF or HTML report

Render a New York City Council PDF or HTML report

## Usage

``` r
council_pdf(toc = FALSE, highlight = "default", ...)

council_html(toc = FALSE, highlight = "default", ...)
```

## Arguments

- toc:

  Whether to include a table of contents. Defaults to `FALSE`.

- highlight:

  Highlighting style

- ...:

  Further options passed to
  [`bookdown::pdf_document2()`](https://pkgs.rstudio.com/bookdown/reference/html_document2.html)
  or
  [`bookdown::html_document2()`](https://pkgs.rstudio.com/bookdown/reference/html_document2.html).

## Value

An R Markdown output object
