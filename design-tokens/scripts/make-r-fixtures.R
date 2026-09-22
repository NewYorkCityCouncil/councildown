# Writes test/fixtures/r-reference.json: outputs of councildown's R palette and
# scale functions, used by the TypeScript tests to check the ports match.
# Run from design-tokens/: npm run fixtures:r
suppressPackageStartupMessages(library(leaflet))
sys.source("../R/colors.R", envir = environment())

hex <- function(x) toupper(substr(x, 1, 7))

ramps <- list()
for (p in c(names(nycc_palettes), "single", "double")) {
  for (n in c(1, 2, 3, 5, 7, 10)) {
    ramps[[length(ramps) + 1]] <- list(palette = p, n = n, colors = hex(scale_nycc(p)(n)))
  }
}

evaluate_at <- function(domain) sort(unique(c(domain, seq(min(domain), max(domain), length.out = 21))))

diverging_cases <- list(
  list(name = "skewed, median mid", domain = c(1, 2, 3, 2, 1, 100), args = setNames(list(), character(0))),
  list(name = "zero centered", domain = -10:10, args = list(low = -10, mid = 0, high = 10)),
  list(name = "custom range wider than data", domain = 2:8, args = list(low = 0, mid = 5, high = 10)),
  list(name = "mean mid", domain = c(5, 12, 18, 25, 40, 41, 77), args = list(mid = "mean")),
  list(name = "custom colors", domain = seq(0, 1, 0.1),
       args = list(color_low = "#007534", color_mid = "#F9F9F9", color_high = "#8744BC"))
)
diverging <- lapply(diverging_cases, function(case) {
  pal <- suppressWarnings(do.call(colorDiverging, c(list(domain = case$domain), case$args)))
  x <- evaluate_at(case$domain)
  c(case, list(x = x, colors = hex(pal(x))))
})

bin_cases <- list(
  list(domain = c(0, 100), bins = 7, palette = "nycc_blue"),
  list(domain = c(3.2, 87.9), bins = 5, palette = "warm"),
  list(domain = c(0.001, 0.047), bins = 7, palette = "cool"),
  list(domain = c(-35, 120), bins = 4, palette = "nycc_blue"),
  list(domain = c(0, 100), bins = c(0, 10, 25, 50, 100), palette = "diverging"),
  list(domain = c(1200, 98000), bins = 6, palette = "forest_green"),
  list(domain = c(0, 1), bins = 3, palette = "indigo")
)
bin <- lapply(bin_cases, function(case) {
  # Mirrors councildown::colorBin() defaults.
  pal <- leaflet::colorBin(pal_nycc(case$palette), domain = case$domain, bins = case$bins, na.color = "#FFFFFF")
  x <- c(evaluate_at(case$domain), min(case$domain) - 1, max(case$domain) + 1)
  breaks <- if (length(case$bins) > 1) case$bins else pretty(case$domain, n = case$bins)
  c(case, list(x = x, breaks = breaks, colors = hex(suppressWarnings(pal(x)))))
})

pretty_cases <- list(
  list(range = c(0, 100), n = 7), list(range = c(3.2, 87.9), n = 5), list(range = c(0.001, 0.047), n = 7),
  list(range = c(-35, 120), n = 4), list(range = c(1200, 98000), n = 6), list(range = c(0, 1), n = 3),
  list(range = c(5, 5), n = 5), list(range = c(0, 0), n = 5), list(range = c(-0.3, 0.3), n = 7),
  list(range = c(17, 1234567), n = 7)
)
pretty_out <- lapply(pretty_cases, function(case) c(case, list(breaks = pretty(case$range, n = case$n))))

jsonlite::write_json(
  list(ramps = ramps, diverging = diverging, bin = bin, pretty = pretty_out),
  "test/fixtures/r-reference.json", auto_unbox = TRUE, digits = NA, pretty = TRUE
)
cat("Wrote test/fixtures/r-reference.json\n")
