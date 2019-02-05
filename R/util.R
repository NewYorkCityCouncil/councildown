#' Make a pretty date
#'
#' @param x A \code{Date}. If \code{x} is \code{NULL}, the system date is returned.
#'
#' @return A character string representing the date.
#' @export
#'
#' @examples
#'
#' pretty_date()
#'
pretty_date <- function(x = NULL) {
  if (is.null(x)) x <- Sys.Date()

  return(gsub("\\s+", " ", format(x, format = "%B %e, %Y")))
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Using NYCC default colors and theme in `ggplot2` calls. To use `ggplot2` defaults call them with `::`.")
  ggplot2::theme_set(councildown::theme_nycc())
}
