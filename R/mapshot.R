#' mapshot pdf
#'
#' This is a \code{mapshot} adjustment that saves maps as pdf and
#' warns users if they choose png
#'
#' @inheritParams mapview::mapshot
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(leaflet)
#' library(councildown)
#' m <- leaflet() %>%
#'  addTiles() %>%
#'  addCouncilStyle(add_dists = TRUE)
#' mapshot(m, file = "test.png")
#' file.remove("test.png")
#' }
#'
#' @import mapview
#' @importFrom tools file_path_sans_ext
#' @importFrom tools file_ext
#'

# copied from original mapshot code
mapshot <- function (x, url = NULL, file = NULL, zoom = 2, vwidth = 1000, vheight = 850,
                     remove_controls = c("zoomControl",
                                         "layersControl", "homeButton", "scaleBar", "drawToolbar",
                                         "easyButton"), ...)
  {
    avl_url = !is.null(url)
    avl_file = !is.null(file)
    if (!avl_url & !avl_file)
      stop("Please provide a valid 'url' or 'file' argument (or both).")
    if (avl_url)
      url = normalizePath(url, mustWork = FALSE)
    if (avl_file)
      file = normalizePath(file, mustWork = FALSE)
    if (inherits(x, "mapview")) {
      x = mapview2leaflet(x)
    }
    if (!inherits(x, "leaflet") | mapview:::is_literally_false(remove_controls)) {
      remove_controls = NULL
    }
    if (!avl_url) {
      url = tempfile(fileext = ".html")
      x = mapview:::removeMapJunk(x, remove_controls)
    }
    args = list(url = url, file = file, vwidth = vwidth, vheight = vheight, zoom = zoom, ...)
    sw_ls = args
    sw_ls[names(sw_ls) == "file"] = NULL
    names(sw_ls)[which(names(sw_ls) == "url")] = "file"
    sw_args = match.arg(names(sw_ls), names(as.list(args(htmlwidgets::saveWidget))),
                        several.ok = TRUE)
    ws_args = match.arg(names(args), names(as.list(args(webshot::webshot))),
                        several.ok = TRUE)
    do.call(htmlwidgets::saveWidget, append(list(x), sw_ls[sw_args]))
    if (avl_file) {
      if (is.null(remove_controls)) {
        do.call(webshot::webshot, args)
        return(invisible())
      }
      tmp_url = tempfile(fileext = ".html")
      tmp_fls = paste0(tools::file_path_sans_ext(tmp_url),
                       "_files")
      sw_ls = utils::modifyList(sw_ls, list(file = tmp_url))
      args$url = tmp_url
      x = mapview:::removeMapJunk(x, remove_controls)
      do.call(htmlwidgets::saveWidget, append(list(x), sw_ls[sw_args]))
      do.call(webshot::webshot, args[ws_args])
      return(invisible())
    }
}



#' addLegend - but with the option for the highest number to be at the top of the legend
#'
#' solution from mpriem89 (https://github.com/rstudio/leaflet/issues/256#issuecomment-440290201)
#'
#' @export
#'
#' @import leaflet
#'
addLegend_decreasing <- function (map, position = c("topright", "bottomright", "bottomleft","topleft"),
                                  pal, values, na.label = "NA", bins = 7, colors, 
                                  opacity = 0.5, labels = NULL, labFormat = labelFormat(), 
                                  title = NULL, className = "info legend", layerId = NULL, 
                                  group = NULL, data = getMapData(map), decreasing = FALSE) {
  
  position <- match.arg(position)
  type <- "unknown"
  na.color <- NULL
  extra <- NULL
  if (!missing(pal)) {
    if (!missing(colors)) 
      stop("You must provide either 'pal' or 'colors' (not both)")
    if (missing(title) && inherits(values, "formula")) 
      title <- deparse(values[[2]])
    values <- evalFormula(values, data)
    type <- attr(pal, "colorType", exact = TRUE)
    args <- attr(pal, "colorArgs", exact = TRUE)
    na.color <- args$na.color
    if (!is.null(na.color) && col2rgb(na.color, alpha = TRUE)[[4]] == 
        0) {
      na.color <- NULL
    }
    if (type != "numeric" && !missing(bins)) 
      warning("'bins' is ignored because the palette type is not numeric")
    if (type == "numeric") {
      cuts <- if (length(bins) == 1) 
        pretty(values, bins)
      else bins   
      if (length(bins) > 2) 
        if (!all(abs(diff(bins, differences = 2)) <= 
                 sqrt(.Machine$double.eps))) 
          stop("The vector of breaks 'bins' must be equally spaced")
      n <- length(cuts)
      r <- range(values, na.rm = TRUE)
      cuts <- cuts[cuts >= r[1] & cuts <= r[2]]
      n <- length(cuts)
      p <- (cuts - r[1])/(r[2] - r[1])
      extra <- list(p_1 = p[1], p_n = p[n])
      p <- c("", paste0(100 * p, "%"), "")
      if (decreasing == TRUE){
        if (is.null(labels)) {labels <- rev(labFormat(type = "numeric", cuts))}
        colors <- pal(rev(c(r[1], cuts, r[2])))
        labels <- labels
      }else{
        if (is.null(labels)) {labels <- labFormat(type = "numeric", cuts)}
        colors <- pal(c(r[1], cuts, r[2]))
        labels <- labels
      }
      colors <- paste(colors, p, sep = " ", collapse = ", ")
    }
    else if (type == "bin") {
      cuts <- args$bins
      n <- length(cuts)
      mids <- (cuts[-1] + cuts[-n])/2
      if (decreasing == TRUE){
        colors <- pal(rev(mids))
        labels <- rev(labFormat(type = "bin", cuts))
      }else{
        colors <- pal(mids)
        labels <- labFormat(type = "bin", cuts)
      }
    }
    else if (type == "quantile") {
      p <- args$probs
      n <- length(p)
      cuts <- quantile(values, probs = p, na.rm = TRUE)
      mids <- quantile(values, probs = (p[-1] + p[-n])/2, na.rm = TRUE)
      if (decreasing == TRUE){
        colors <- pal(rev(mids))
        if(is.null(labels)) {labels = rev(labFormat(type = "quantile", cuts, p))}
        labels <- labels
      }else{
        colors <- pal(mids)
        if(is.null(labels)) {labels = labFormat(type = "quantile", cuts, p)}
        labels <- labels
      }
    }
    else if (type == "factor") {
      v <- sort(unique(na.omit(values)))
      colors <- pal(v)
      labels <- labFormat(type = "factor", v)
      if (decreasing == TRUE){
        colors <- pal(rev(v))
        labels <- rev(labFormat(type = "factor", v))
      }else{
        colors <- pal(v)
        labels <- labFormat(type = "factor", v)
      }
    }
    else stop("Palette function not supported")
    if (!any(is.na(values))) 
      na.color <- NULL
  }
  else {
    if (length(colors) != length(labels)) 
      stop("'colors' and 'labels' must be of the same length")
  }
  legend <- list(colors = I(unname(colors)), labels = I(unname(labels)), 
                 na_color = na.color, na_label = na.label, opacity = opacity, 
                 position = position, type = type, title = title, extra = extra, 
                 layerId = layerId, className = className, group = group)
  invokeMethod(map, data, "addLegend", legend)
}

