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
  packageStartupMessage("Using NYCC default colors and theme in `ggplot2` calls. To use `ggplot2` defaults call them with `::`.\nOverrides default mapshot with councildown::mapshot")
  ggplot2::theme_set(councildown::theme_nycc())
  mapshot <- councildown::mapshot
}


# Taken from yihui/knitr/R/util.R

`%n%` = getFromNamespace("%n%", "knitr")

all_figs = getFromNamespace("all_figs", "knitr")

in_base_dir = getFromNamespace("in_base_dir", "knitr")


#' Embed fonts in PDF images
#'
#' This knitr chunk hook embeds fonts in PDF images so that the appear correctly
#' on all computers.
#'
#' @param before Is hook being run before chunk
#' @param options Chunk options
#' @param envir Environment
#'
#' @export
#'
#' @importFrom utils getFromNamespace

hook_pdfembed <- function(before, options, envir) {
  # crops plots after a chunk is evaluated and plot files produced
  ext = options$fig.ext
  if (options$dev == 'tikz' && options$external) ext = 'pdf'
  if (before || (fig.num <- options$fig.num %n% 0L) == 0L) return()
  if(!knitr::is_latex_output()) return()
  paths = all_figs(options, ext, fig.num)
  in_base_dir(for (f in paths) extrafont::embed_fonts(f))
}
