#' Basic Styling for Leaflet Popups
#'
#' This function wraps its input in a \code{<div>} and sets council fonts for
#' body and headers.
#'
#' @param x The popup HTML
#'
#' @return A character vector
#' @export
#'
#' @examples
#'
#' councilPopup("Test")
councilPopup <- function(x) {

  style <- "h1,h2,h3,h4,h5 {font-family: Georgia, serif; margin: inherit;}
font-family: 'Open Sans', sans-serif;"

  paste0("<div>", "<style>", style, "</style>", x, "</div>")
}
