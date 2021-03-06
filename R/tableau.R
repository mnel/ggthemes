#' Tableau Color Palettes (discrete)
#'
#' Color palettes used in \href{http://www.tableausoftware.com/}{Tableau}.
#'
#' @details Tableau provides types of color palettes:
#' \code{"regular"} (discrete, qualitative categories),
#' \code{"ordered-sequential"}, and \code{"ordered-diverging"}.
#'
#' \itemize{
#' \item{\code{"regular"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["regular"]]))}}
#' \item{\code{"ordered-diverging"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-diverging"]]))}}
#' \item{\code{"ordered-sequential"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]]))}}
#' }
#'
#' @export
#' @param palette Palette name. See Details for available palettes.
#' @param type Type of palette. One of \code{"regular"}, \code{"ordered-diverging"}, or \code{"ordered-sequential"}.
#' @param direction If 1, the default, then use the original order of
#'   colors. If -1, then reverse the order.
#'
#' @references
#' \url{http://vis.stanford.edu/color-names/analyzer/}
#'
#' Maureen Stone, 'Designing Colors for Data' (slides), at the
#' International Symposium on Computational Aesthetics in Graphics,
#' Visualization, and Imaging, Banff, AB, Canada, June 22, 2007
#' \url{http://www.stonesc.com/slides/CompAe\%202007.pdf}.
#'
#' Heer, Jeffrey and Maureen Stone, 2012 'Color Naming Models for
#' Color Selection, Image Editing and Palette Design', ACM Human
#' Factors in Computing Systems (CHI)
#' \url{http://vis.stanford.edu/files/2012-ColorNameModels-CHI.pdf}.
#'
#' @family colour tableau
#' @example inst/examples/ex-tableau_color_pal.R
tableau_color_pal <- function(palette = "Tableau 10",
                              type = c("regular", "ordered-seqential",
                                       "ordered-diverging"),
                              direction = 1) {
  type <- match.arg(type)
  palettes <- ggthemes::ggthemes_data[["tableau"]][["color-palettes"]][[type]]
  if (!palette %in% names(palettes)) {
    stop("`palette` must be one of ", paste(names(palettes), collapse = ", "),
         ".")
  }
  values <- palettes[[palette]][["value"]]
  max_n <- length(values)
  f <- function(n) {
    check_pal_n(n, max_n)
    if (direction < 0) {
      values <- rev(values)
    }
    values[seq_len(n)]
  }
  attr(f, "max_n") <- length(values)
  f
}

#' Tableau color scales
#'
#' Categorical color scales from Tableau.
#'
#' @inheritParams ggplot2::scale_colour_hue
#' @inheritParams tableau_color_pal
#' @family colour tableau
#' @rdname scale_color_tableau
#' @export
#' @seealso \code{\link{tableau_color_pal}} for references.
#' @example inst/examples/ex-scale_color_tableau.R
scale_colour_tableau <- function(palette = "Tableau 10", ...) {
  discrete_scale("colour", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_fill_tableau <- function(palette = "Tableau 10", ...) {
  discrete_scale("fill", "tableau", tableau_color_pal(palette), ...)
}

#' @export
#' @rdname scale_color_tableau
scale_color_tableau <- scale_colour_tableau

#' Tableau Shape Palettes (discrete)
#'
#' Shape palettes used by
#' \href{http://www.tableausoftware.com/}{Tableau}.
#'
#' Not all shape palettes in Tableau are supported. Additionally, these
#' palettes are not exact, and use the best unicode character for the shape
#' palette.
#'
#' Since these palettes use unicode characters, their look may depend on the
#' font being used, and not all characters may be available.
#'
#' Shape palettes in Tableau are used to expose images for use a markers in
#' charts, and thus are sometimes groupings of closely related symbols.
#'
#' @export
#' @param palette Palette name.
#' @family shape tableau
#' @example inst/examples/ex-tableau_shape_pal.R
tableau_shape_pal <- function(palette = c("default", "filled", "proportions")) {
  palette <- match.arg(palette)
  shapes <- ggthemes::ggthemes_data$tableau[["shape-palettes"]][[palette]]
  f <- manual_pal(shapes[["pch"]])
  attr(f, "max_n") <- nrow(shapes)
  f
}

#' Tableau shape scales
#'
#' See \code{\link{tableau_shape_pal}} for details.
#'
#' @export
#' @inheritParams tableau_shape_pal
#' @inheritParams ggplot2::scale_x_discrete
#' @family shape tableau
#' @example inst/examples/ex-scale_shape_tableau.R
scale_shape_tableau <- function(palette = "default", ...) {
  discrete_scale("shape", "tableau", tableau_shape_pal(palette), ...)
}

#' Tableau colour gradient palettes (continuous)
#'
#' @param palette Palette name.
#'  \itemize{
#'  \item{\code{"ordered-sequential"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-sequential"]]))}}
#'  \item{\code{"ordered-diverging"}}{\Sexpr[results=rd]{ggthemes:::rd_optlist(names(ggthemes::ggthemes_data$tableau[["color-palettes"]][["ordered-diverging"]]))}}
#'  }
#' @param type Palette type, either \code{"ordered-sequential"} or
#'   \code{"ordered-diverging"}.
#' @param values if colours should not be evenly positioned along the gradient
#'   this vector gives the position (between 0 and 1) for each colour in the
#'   colours vector. See \link[scales]{rescale} for a convenience function to
#'   map an arbitrary range to between 0 and 1.
#' @param direction Sets the order of colors in the scale.
#'    If 1, the default, colors are as the original order.
#'    If -1, the order of colors is reversed.
#' @param ... Arguments passed to \code{tableau_gradient_pal}.
#' @family colour tableau
#'
#' @export
#' @example inst/examples/ex-tableau_seq_gradient_pal.R
tableau_gradient_pal <- function(palette = "Blue", type = "ordered-sequential",
                                 values = NULL, direction = 1) {
  type <- match.arg(type, c("ordered-sequential", "ordered-diverging"))
  pal <- ggthemes::ggthemes_data[[c("tableau", "color-palettes",
                                    type, palette)]]
  colours <- pal[["value"]]
  if (direction < 0) {
    colours <- rev(colours)
  }
  scales::gradient_n_pal(colours, values = values, space = "Lab")
}

#' @export
#' @rdname tableau_gradient_pal
tableau_seq_gradient_pal <- function(palette = "Blue", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-sequential", ...)
}

#' @export
#' @rdname tableau_gradient_pal
tableau_div_gradient_pal <- function(palette = "Orange-Blue Diverging", ...) {
  tableau_gradient_pal(palette = palette, type = "ordered-diverging", ...)
}

#' Tableau sequential colour scale (continuous)
#'
#' @export
#' @inheritParams tableau_seq_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @rdname scale_colour_gradient_tableau
#' @example inst/examples/ex-scale_colour_gradient_tableau.R
scale_colour_gradient_tableau <- function(palette = "Blue",
                                          ...,
                                          na.value = "grey50",
                                          guide = "colourbar") {
  continuous_scale("colour", "tableau",
                   tableau_seq_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_gradient_tableau <- function(palette = "Blue",
                                        ...,
                                        na.value = "grey50",
                                        guide = "colourbar") {
  continuous_scale("fill", "tableau",
                   tableau_seq_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_gradient_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_color_continuous_tableau <- scale_colour_gradient_tableau

#' @export
#' @rdname scale_colour_gradient_tableau
scale_fill_continuous_tableau <- scale_fill_gradient_tableau

#' Tableau diverging colour scales (continuous)
#'
#' @inheritParams tableau_div_gradient_pal
#' @inheritParams ggplot2::scale_colour_hue
#' @param guide Type of legend. Use \code{'colourbar'} for continuous
#'   colour bar, or \code{'legend'} for discrete colour legend.
#' @family colour tableau
#' @export
#' @rdname scale_colour_gradient2_tableau
#' @example inst/examples/ex-scale_colour_gradient2_tableau.R
scale_colour_gradient2_tableau <- function(palette = "Orange-Blue Diverging",
                                           ...,
                                           na.value = "grey50",
                                           guide = "colourbar") {
  continuous_scale("colour", "tableau2",
                   tableau_div_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_fill_gradient2_tableau <- function(palette = "Orange-Blue Diverging",
                                         ...,
                                         na.value = "grey50",
                                         guide = "colourbar") {
  continuous_scale("fill", "tableau2",
                   tableau_div_gradient_pal(palette),
                   na.value = na.value,
                   guide = guide,
                   ...)
}

#' @export
#' @rdname scale_colour_gradient2_tableau
scale_color_gradient2_tableau <- scale_colour_gradient2_tableau
