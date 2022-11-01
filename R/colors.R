nycc_colors <- c(
   "nycc blue" = "#2F56A6",
   "dark blue" = "#23417D",
   "dark grey" = "#666666",
   "medium grey" = "#CACACA",
   "light grey" = "#E6E6E6",
   "off white" = "#F9F9F9",
   "white" = "#FFFFFF",
   "black" = "#222222",
   "maroon" = "#800000",
   "blood orange" = "#B63F26",
   "Bronze" = "#846126",
   "Forest" = "#007534",
   "Blue" = "#1D5FD6",
   "Indigo"= "#3B2483",
   "Violet" = "#8744BC",
   "Brown" = "#674200",
   "terra orange" ="#dc6d4f")

nycc_monochromatic <- c("#000000",  "#16294f",  "#2c529f",  "#5f85d2",  "#afc2e8")
nycc_bw <- c("#000000",  "#333333",  "#666666",  "#999999",  "#cccccc")

nycc_categorical_main <- c(
  "blue" = "#1d5fd6",
  "dark umber brown" = "#471914",
  "blood orange" = "#B63F26",
  "grey" = "#959595",
  "indigo" = "#3b2483"
)

nycc_categorical_primary <- c(
   "dark red" = "#880000",
   "tan"   = "#bca066",
   "blue" = "#1d5fd6",
   "periwinke purple" = "#bbb8ff"
)

nycc_categorical_secondary <- c(
  "dark umber brown" = "#471914",
  "terra orange" ="#dc6d4f",
  "light grey" = "#e6e6e6",
  "purple" = "#6a4ca9",
  "indigo" = "#3b2483"
)

nycc_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (nycc_colors)

  nycc_colors[cols]
}

nycc_palettes <- list(
  # main = nycc_cols("black", "dark blue", "nycc blue"),
  bw = nycc_bw,
  main = nycc_categorical_main,
  mixed = nycc_categorical_primary,
  warm = nycc_cols("marron", "blood orange", "violet", "medium grey","terra orange"),
  cool = nycc_monochromatic,
  diverging = nycc_categorical_secondary
)

#' Make a color palette with NYCC colors
#'
#'
#' @param palette One of \code{"mixed", "cool", "warm", "diverging"}
#' @param reverse Boolean, reverse the order of the selected palette
#' @param ... Further arguments passed to \code{colorRampPalette}
#'
#' @return A function made by \code{colorRampPalette}
#' @export
#'
#' @importFrom grDevices colorRampPalette
#'
nycc_pal <- function(palette = "mixed", reverse = FALSE, ...) {
  pal <- nycc_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  raw_pal <- colorRampPalette(pal, ...)

  out <- function(n) {

    names(pal) <- NULL

    if (n >= length(pal)) {
      return(raw_pal(n))
    } else {
      return(pal[1:n])
    }
  }

  out
}

#' Color and fill scales for ggplots
#'
#' The functions \code{scale_*_continuous} and \code{scale_*_discrete} are
#' exported from this package as aliases for the functions \code{scale_*_nycc}
#' with appropriate default arguments. Because of this, these colors will
#' overwrite \code{ggplot2}'s default scales. To prevent this, either set scales
#' manually in plots by calling \code{ggplot2::scale_*}, or attach
#' \code{ggplot2} after \code{councildown}.
#'
#' When \code{discrete} is \code{TRUE} arguments are passed via \code{...} to
#' \code{\link[ggplot2]{discrete_scale}}. This is the default behavior.
#' Otherwise, \code{...} arguments are passed to
#' \code{\link[ggplot2]{scale_color_gradientn}} or
#' \code{\link[ggplot2]{scale_fill_gradientn}} as appropriate.
#'
#' @inheritParams nycc_pal
#' @inheritParams ggplot2::discrete_scale
#' @inheritParams ggplot2::scale_fill_gradientn
#' @inheritParams ggplot2::scale_color_gradientn
#'
#' @param discrete Boolean, should the scale be discrete?
#' @param ... Further arguments passed to \code{scale_*} from \code{ggplot2}
#'
#' @export
#'
#'
scale_fill_nycc <- function(palette = "mixed", discrete = TRUE, reverse = FALSE, ...) {
  pal <- nycc_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill", paste0("nycc_", palette), palette = pal,na.value = "grey50", ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}




#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_color_nycc <- function(palette = "mixed", discrete = TRUE, reverse = FALSE, ...) {
  pal <- nycc_pal(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("colour", paste0("nycc_", palette), palette = pal, na.value = "grey50", ...)
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_color_discrete <- scale_color_nycc
#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_color_continuous <- function(...) councildown::scale_color_nycc(..., discrete = FALSE)
#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_fill_discrete <- scale_fill_nycc
#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_fill_continuous <- function(...) councildown::scale_fill_nycc(discrete = FALSE)

