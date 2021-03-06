#' Render a New York City Council PDF or HTML report
#'
#' @param toc Whether to include a table of contents. Defaults to \code{FALSE}.
#' @param highlight Highlighting style
#' @param ... Further options passed to \code{bookdown::pdf_document2()} or
#'     \code{bookdown::html_document2()}.
#'
#' @return An R Markdown output object
#' @export
#'

# shamelessly pilfered from https://github.com/ismayc/thesisdown/blob/master/R/thesis.R
council_pdf <- function(toc = FALSE, highlight = "default", ...){

  base <- bookdown::pdf_document2(template = "assets/template.tex",
                             toc = toc,
                             highlight = highlight,
                             keep_tex = TRUE,
                             pandoc_args = c("--top-level-division=section"),
                             ...)

  # Mostly copied from knitr::render_sweave
  base$knitr$opts_chunk$comment <- NA
  #base$knitr$opts_chunk$fig.align <- "center"

  old_opt <- getOption("bookdown.post.latex")
  options(bookdown.post.latex = fix_envs)
  on.exit(options(bookdown.post.late = old_opt))

  base

}



#' @export
#' @rdname council_pdf

council_html <- function(toc = FALSE, highlight = "default", ...) {
  bookdown::html_document2(toc = toc,
                           highlight = highlight,
                           css = "assets/style.css",
                           ...)
}

fix_envs <- function(x){
  beg_reg <- '^\\s*\\\\begin\\{.*\\}'
  end_reg <- '^\\s*\\\\end\\{.*\\}'
  i3 = if (length(i1 <- grep(beg_reg, x))) (i1 - 1)[grepl("^\\s*$", x[i1 - 1])]

  i3 = c(i3,
         if (length(i2 <- grep(end_reg, x))) (i2 + 1)[grepl("^\\s*$", x[i2 + 1])]
  )
  if (length(i3)) x = x[-i3]
  x
}
