nycc_colors <- c(
  # "nycc blue" = "#2F56A6",
  # "dark blue" = "#23417D",
  # "black" = "#222222",
  "red" = "#D05D4E",
  "grape" = "#BE4BDB",
  "blue" = "#228AE6",
  "teal" = "#12B886",
  "lime" = "#82C91E",
  "gold" = "#F59F00",
  "brown" = "#A07952",
  "white" = "#FFFFFF"
)

nycc_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (nycc_colors)

  nycc_colors[cols]
}

nycc_palettes <- list(
  # main = nycc_cols("black", "dark blue", "nycc blue"),
  cool = nycc_cols("grape", "teal", "blue"),
  warm = nycc_cols("gold", "red"),
  mixed = nycc_cols( "gold", "red", "grape", "blue", "teal", "lime"),
  diverging = nycc_cols("blue", "grape", "red")
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

  colorRampPalette(pal, ...)
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
