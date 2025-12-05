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

###### for accessibility colorblindcheck::palette_check(), viz palette, pinetools and chroma.js color paletter helper websites were used ------------
# https://projects.susielu.com/viz-palette?colors=[%22#B63F26%22,%22#846126%22,%22#1D5FD6%22,%22#007534%22,%22#666666%22,%22#8744BC%22,%22#3b2483%22]&backgroundColor=%22white%22&fontColor=%22black%22&mode=%22normal%22
# https://gka.github.io/palettes/#/7|s|e6e6e6,800000|ffffe0,ff005e,93003a|1|1
# https://pinetools.com/lighten-color
# example:
#colorblindcheck::palette_plot(indigo)



##### categorical palettes ------------
secondary <- c('#211183','#979797','#1d5fd6',"#d6593f",'#002e14','#9d9dff','#584019')

primary <- c("#660000","#1850b5","#ba9f64","#1f3a70","#b3b3ff","#af6d46","#666666")

##### continuous palettes ---------

# palette based off maroon:#800000
warm <- c('#ffd8d8', '#eeb6b1', '#db958b', '#c67466', '#b05344', '#993123', '#800000' )
# palette based off dark blue:#23417D
cool <- c('#e3eaf7', '#c4cbe2', '#a5adcd', '#8691b9', '#6775a5', '#485a91', '#23417d')
# palette based off black:#222222
bw <- c('#e8e8e8', '#c3c3c3', '#a0a0a0', '#7e7e7e', '#5d5d5d', '#3e3e3e', '#222222')
# palette based off maroon:#800000, light grey:#E6E6E6, and forest:#007534 / blue:#1D5FD6
div <- c('#6d2516','#a93922','#dc6c55',"#e6e6e6",'#53c4de','#2091ab','#155d6d')
# palette based off maroon:#800000, light grey:#E6E6E6, and dark blue:#1D5FD6
div2 <- c('#6d2516','#a93922','#dc6c55',"#e6e6e6",'#acb2d9','#556cb3',"#23417D")
# meant for mapping; palette interpolated from white to nycc_blue, with white removed (can use white as NA)
nycc_blue <- c('#e3e5f2', '#c8cbe6', '#acb2d9', '#909acc', '#7482c0', '#556cb3', '#2f56a6')
# additional council color based palettes
indigo <- c('#e8e4f7', '#ccc1e3', '#b0a0d0', '#947fbc', '#7760a9', '#5a4296', '#3b2483')
blue <- c('#e7eefb', '#cdd4f5', '#b3bbf0', '#98a3ea', '#7a8be3', '#5675dd', '#1d5fd6')
violet <- c('#f3ecf8', '#e2cfee', '#d1b3e5', '#c098db', '#ae7cd1', '#9b60c6', '#8744bc')
bronze <- c('#f7f0e4', '#e5d7c2', '#d2bea1', '#bfa681', '#ac8e62', '#987744', '#846126')
blood_orange <- c('#f9eae7', '#f3cdc4', '#eab1a2', '#e09582', '#d37962', '#c65d44', '#b63f26')
forest <- c('#d1ffe6', '#addbc0', '#89b99b', '#679778', '#467757', '#255837', '#003a1a')

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
  nycc_blue = nycc_blue,
  warm = warm,
  cool = cool,
  diverging = div,
  indigo = indigo,
  blue = blue,
  violet = violet,
  bronze = bronze,
  orange = blood_orange,
  forest_green = forest
)

#' Make a color palette with NYCC colors. Second iteration from nycc_pal.
#'
#'
#' @param palette One of \code{"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"}. When palette is set to "single" or "double", it returns the first color and first and second color from the "main" palette respectively.
#' @param reverse Boolean, reverse the order of the selected palette
#'
#' @return The palette inputted, forward or reverse, grabbed from nycc_palettes and with additional palette options for \code{"single", "double"}
#' @export
#'
#' @importFrom grDevices colorRampPalette
#'
pal_nycc <- function(palette = "main", reverse = FALSE) {
  if (palette =="single"){
    pal <- nycc_palettes[["main"]][1]}
  else if (palette =="double"){
    pal <- nycc_palettes[["main"]][1:2]}
  else{
    pal <- nycc_palettes[[palette]]
  }

  if (reverse) pal <- rev(pal)

  return(pal)
}

#' Make a color palette with NYCC colors for scale_*_nycc
#'
#'
#' @param palette One of \code{"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"}. When palette is set to "single" or "double", it returns the first color and first and second color from the "main" palette respectively.
#' @param reverse Boolean, reverse the order of the selected palette
#' @param ... Further arguments passed to \code{colorRampPalette}
#'
#' @return A function made by \code{colorRampPalette}
#'
#' @importFrom grDevices colorRampPalette
#'
scale_nycc <- function(palette = "mixed", reverse = FALSE, ...) {
  if (palette =="single"){
    pal <- nycc_palettes[["main"]][1]}
  else if (palette =="double"){
    pal <- nycc_palettes[["main"]][1:2]}
  else{
    pal <- nycc_palettes[[palette]]
  }

  if (reverse) pal <- rev(pal)

  raw_pal <- colorRampPalette(pal, ...)

  out <- function(n) {

    names(pal) <- NULL

    return(raw_pal(n))
  }
  out
}

#' DEPRACATED: Make a color palette with NYCC colors
#'
#'
#' @param palette One of \code{"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"}. When palette is set to "single" or "double", it returns the first color and first and second color from the "main" palette respectively.
#' @param reverse Boolean, reverse the order of the selected palette
#' @param ... Further arguments passed to \code{colorRampPalette}
#'
#' @return A function made by \code{colorRampPalette}
#' @export
#'
#' @importFrom grDevices colorRampPalette
#'
nycc_pal <- function(palette = "mixed", reverse = FALSE, ...) {
  if (palette =="single"){
    pal <- nycc_palettes[["main"]][1]}
  else if (palette =="double"){
    pal <- nycc_palettes[["main"]][1:2]}
  else{
    pal <- nycc_palettes[[palette]]
  }

  if (reverse) pal <- rev(pal)

  raw_pal <- colorRampPalette(pal, ...)

  out <- function(n) {

    names(pal) <- NULL

   return(raw_pal(n))
  }

  .Deprecated("pal_nycc", msg = "'nycc_pal' is deprecated.\nUse 'pal_nycc' for discrete palettes.\ncolorRampPalette() is an option to interpolate more bins.\nE.g. colorRampPalette(pal_nycc(\"main\"))(100)")
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
  pal <- scale_nycc(palette = palette, reverse = reverse)

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
  pal <- scale_nycc(palette = palette, reverse = reverse)

  if (discrete) {
    out <- ggplot2::discrete_scale("colour", paste0("nycc_", palette), palette = pal, na.value = "grey50", ...)
    if (palette != "main"){
      class(out) <- c("ScaleDiscrete_Colour","Changed_Palette",class(out))
    } else{
      class(out) <- c("ScaleDiscrete_Colour",class(out))
    }

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
  # This may cause problems if there are more than one dataset? I'm not certain
  num_colours <- nrow(unique(ggplot_build(plot)$data[[1]]["colour"]))
  #if ("Changed_Palette" %in% class(object)){
    if (num_colours > 7) {
      cli::cli_abort("Can't add {.var {object_name}} to a {.cls ggplot} object when there are more than 7 levels (colors).")
    } else if (num_colours <= 1){
      pal <- scale_nycc(palette = "single")
      object <- ggplot2::discrete_scale("colour", "single_palette", palette = pal, na.value = "grey50")
    } else if (num_colours == 2){
      pal <- scale_nycc(palette = "double")
      object <- ggplot2::discrete_scale("colour", "double_palette", palette = pal, na.value = "grey50")
    }
  #}

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




#' Make a diverging palette centered around a number of choice. Made by Noah
#'
#'
#' @param domain The numeric vector of data to be colored (e.g. df#column)
#' @param color_low Color for the low end of the palette (default: maroon)
#' @param color_mid Color for the middle of the palette (default: light gray)
#' @param color_high Color for the high end of the palette (default: navy)
#' @param low Value for low end of the palette. Can either be "min" for minimum of domain or numerical value.
#' @param mid Value for middle of the palette. Can either be "median", "mean", or numerical value.
#' @param high Value for high end of the palette. Can either be "max" for maximum of domain or numerical value.
#' @param ... Further arguments passed to \code{colorNumeric}
#'
#' @return A palette function made by \code{colorNumeric}
#' @export
#'
#' @importFrom grDevices colorRampPalette
#' @importFrom leaflet colorNumeric
#'
#' @examples
#' \dontrun{
#' library(leaflet)
#'
#' # Create some skewed data
#' # Most values are small (1-5), one value is huge (100)
#' df <- data.frame(val = c(1, 2, 3, 2, 1, 100))
#'
#' # 1. Standard usage: Midpoint is the Median (2)
#' pal_standard <- colorDiverging(df$val)
#'
#' leaflet(data = df) %>%
#'   addTiles() %>%
#'   addCircleMarkers(lng = -74, lat = 40,
#'                    fillColor = ~pal_standard(val),
#'                    fillOpacity = 1)
#'
#' # 2. Custom usage: Green to Purple, centered at mean
#' pal_custom <- colorDiverging(
#'   df$val,
#'   color_low = "green",
#'   color_mid = "white",
#'   color_high = "purple",
#'   mid = "mean"
#' )
#'
#' # 3. Custom numeric range: -10 to 10, centered at 0
#' vals <- -10:10
#' pal_zero <- colorDiverging(
#'   vals,
#'   low = -10,
#'   mid = 0,
#'   high = 10
#' )
#' }
#'
colorDiverging <- function(domain, color_low = "#800000", color_mid = "#E6E6E6", color_high = "#23417D", low = "min", mid = "median", high = "max", ...) {
  if(length(low) == 1 && low == "min") {
    low_val = min(domain, na.rm = TRUE)
  } else if(is.numeric(low))  {
    low_val <- low
  } else {
    stop("low must be either 'min' or numerical value")
  }

  if(length(mid) == 1 && mid == "median") {
    mid_val = median(domain, na.rm = TRUE)
  } else if(length(mid) == 1 && mid == "mean") {
    mid_val = mean(domain, na.rm = TRUE)
  } else if(is.numeric(mid)) {
    mid_val <- mid
  } else {
    stop("mid must be either 'mean', 'median', or numerical value")
  }

  if(length(high) == 1 && high == "max") {
    high_val = max(domain, na.rm = TRUE)
  } else if(is.numeric(high)) {
    high_val <- high
  } else {
    stop("high must be either 'max' or numerical value")
  }

  if(low_val >= mid_val) stop("low can't be greater than or equal to mid")
  if(mid_val >= high_val) stop("mid can't be greater than or equal to high")

  mid_scaled = round((mid_val - low_val) / (high_val - low_val) * 100) # Scale between 0 and 100

  if(mid_scaled == 100) stop("need to pick a lower value for mid, it's basically equal to max")
  if(mid_scaled == 0) stop("need to pick a higher value for mid, it's basically equal to min")

  ## Make vector of colors for values smaller than median
  rc1 <- colorRampPalette(colors = c(color_low, color_mid), space = "Lab")(mid_scaled)

  ## Make vector of colors for values larger than median
  rc2 <- colorRampPalette(colors = c(color_mid, color_high), space = "Lab")(100 - mid_scaled)

  ## Combine the two color palettes
  rampcols <- c(rc1, rc2)

  pal <- colorNumeric(palette = rampcols, domain = domain, ...)
  return(pal)
}
