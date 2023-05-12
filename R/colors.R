##### list of main council colors --------

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

###### for accessibility colorblindcheck::palette_check(), viz palette and pinetools website were used ------------
# https://projects.susielu.com/viz-palette?colors=[%22#B63F26%22,%22#846126%22,%22#1D5FD6%22,%22#007534%22,%22#666666%22,%22#8744BC%22,%22#3b2483%22]&backgroundColor=%22white%22&fontColor=%22black%22&mode=%22normal%22
# https://pinetools.com/monochromatic-colors-generator
# example:
#colorblindcheck::palette_plot(indigo)



##### categorical palettes ------------
secondary <- c('#211183','#979797','#1d5fd6',"#d6593f",'#002e14','#9d9dff','#584019')

primary <- c("#660000","#1850b5","#ba9f64","#1f3a70","#b3b3ff","#af6d46","#666666")

##### continuous palettes ---------

# palette based off maroon:#800000
warm <- c( '#3f0000','#7f0000','#bf0000','#ff0000','#ff3f3f','#ff7f7f','#ffbfbf' )
# palette based off dark blue:#23417D
cool <- c('#0d1931','#1b3363','#294d95','#3767c7','#698dd5','#9bb3e3','#cdd9f1')
# palette based off black:#222222
bw <- c('#000000','#242424','#484848','#6d6d6d','#919191','#b6b6b6','#dadada')
# palette based off maroon:#800000, light grey:#E6E6E6, and forest:#007534 / blue:#1D5FD6
div <- c('#6d2516','#a93922','#dc6c55',"#e6e6e6",'#53c4de','#2091ab','#155d6d')
# additional council color based palettes
indigo <- c('#160d32','#2d1b64','#432996', '#5a36c8','#8368d5','#ac9ae3','#d5ccf1')
blue <- c('#071838','#0f3170','#164aa8','#1e63e0','#568ae8','#8eb1ef','#c6d8f7')
violet <- c('#21102e','#43215d','#64328c','#8643bb','#a472cc','#c2a1dd','#e0d0ee')
bronze <- c('#31240e','#62481c','#946d2a','#c59139','#d4ac6a','#e2c89c','#f0e3cd')
blood_orange <- c('#34120b','#692416','#9e3621','#d2492c','#dd7660','#e8a495','#f3d1ca')
forest <- c('#152919','#2b5333','#417d4c','#57a766','#81bd8c','#abd3b2','#d5e9d8')

# color and palette functions ------
nycc_cols <- function(...) {
  cols <- c(...)

  if (is.null(cols))
    return (nycc_colors)

  nycc_colors[cols]
}

nycc_palettes <- list(
  # main = nycc_cols("black", "dark blue", "nycc blue"),
  bw = bw,
  main = primary,
  mixed = secondary,
  warm = warm,
  cool = cool,
  diverging = div,
  indigo = indigo,
  blue = blue,
  violet = violet,
  bronze = bronze,
  orange = blood_orange,
  forest = forest
)

#' Make a color palette with NYCC colors
#'
#'
#' @param palette One of \code{"bw","main", "mixed", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest"}
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

   return(raw_pal(n))
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
    out <- ggplot2::discrete_scale("fill", paste0("nycc_", palette), palette = pal,na.value = "#CACACA", ...)
    class(out) <- c("ScaleDiscrete_Fill",class(out))
    return(out)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}




#' @inherit scale_fill_nycc
#' @rdname scale_fill_nycc
#' @export
scale_color_nycc <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {
  pal <- nycc_pal(palette = palette, reverse = reverse)

  if (discrete) {
    out <- ggplot2::discrete_scale("colour", paste0("nycc_", palette), palette = pal, na.value = "grey50", ...)
    class(out) <- c("ScaleDiscrete_Colour",class(out))
    return(out)
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

#' @export
ggplot_add.ScaleDiscrete_Colour <- function(object, plot, object_name) {
  num_colours <- nrow(unique(ggplot_build(plot)$data[[1]]["colour"]))
  if (num_colours > 7) {
    cli::cli_abort("Can't add {.var {object_name}} to a {.cls ggplot} object when there are more than 7 levels (colors).")
  }
  plot$scales$add(object)
  plot
}

#' @export
ggplot_add.ScaleDiscrete_Fill <- function(object, plot, object_name) {
  num_colours <- nrow(unique(ggplot_build(plot)$data[[1]]["fill"]))
  if (num_colours > 7) {
    cli::cli_abort("Can't add {.var {object_name}} to a {.cls ggplot} object when there are more than 7 levels (colors).")
  }
  plot$scales$add(object)
  plot
}
