% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/module_plot_selectable.R
\name{module_server_plot_selectable}
\alias{module_server_plot_selectable}
\title{Server Module: box for str filter condition}
\usage{
module_server_plot_selectable(
  input,
  output,
  session,
  selector_inputs,
  df,
  sel_points,
  mapstyle
)
}
\arguments{
\item{input, output, session}{standard \code{shiny} boilerplate}

\item{selector_inputs}{reactive, output from module_plot_selectorcontrols}

\item{df}{reactive df}

\item{sel_points}{reactive, provides .dcrkey of selected points}

\item{mapstyle}{reactive, selected mapstyle from below-plot controls}
}
\description{
Server Module: box for str filter condition
}
\details{
provides plot, note, that data set needs a column .dcrkey, added in initial processing step
}
