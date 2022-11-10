#' mapshot pdf
#'
#' This is a \code{mapshot} adjustment that saves maps as pdf and
#' warns users if they choose png
#'
#' @param
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(leaflet)
#'
#' m <- leaflet() %>%
#'  addTiles()
#' mapshot(m, file = "test.png")
#' file.remove("test.pdf")
#' }
#'
#' @import mapview
#' @importFrom tools file_path_sans_ext
#' @importFrom tools file_ext
#'

# copied from original mapshot code
mapshot <- function (x, url = NULL, file = NULL, remove_controls = c("zoomControl",
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
      if (file_ext(file) == "png" | file_ext(file) == "jpeg") {
        file = paste0(file_path_sans_ext(file), ".pdf")
        warning("councildown overrides .png and .jpeg extensions with .pdf to improve image quality\nuse mapview::mapshot if you want the default function")
      }
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
    args = list(url = url, file = file, ...)
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
