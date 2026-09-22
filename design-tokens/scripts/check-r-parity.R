# Checks that generated dist/r/tokens.R matches the hand-written values in
# councildown's R/colors.R. Run from design-tokens/: npm run check:r
old <- new.env()
sys.source("../R/colors.R", envir = old)
new <- new.env()
sys.source("dist/r/tokens.R", envir = new)

ok <- TRUE
check <- function(label, a, b) {
  if (identical(a, b)) {
    cat("OK  ", label, "\n")
  } else {
    ok <<- FALSE
    cat("FAIL", label, "\n")
    print(list(colors.R = a, tokens = b))
  }
}

check("nycc_colors", old$nycc_colors, new$nycc_colors)
check("palette names", names(old$nycc_palettes), names(new$nycc_palettes))
for (p in names(old$nycc_palettes)) {
  check(paste0("palette ", p), old$nycc_palettes[[p]], new$nycc_palettes[[p]])
}

if (!ok) quit(status = 1)
