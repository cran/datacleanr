% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{handle_add_outlier_trace}
\alias{handle_add_outlier_trace}
\title{Handle outlier trace}
\usage{
handle_add_outlier_trace(
  sp,
  dframe,
  ok,
  selectors,
  trace_map,
  source = "scatterselect",
  session
)
}
\arguments{
\item{sp}{selected points}

\item{dframe}{plot data}

\item{ok}{reactive, old keys}

\item{selectors}{reactive input selectors}

\item{trace_map}{numeric, max trace id}

\item{source}{plotly source}

\item{session}{active session}
}
\description{
Single outlier trace is added to plotly; interactive select/deselect
was implemented by adjusting \code{selected_points}, and subsequently adding, or deleting+adding
the (modified) trace at the end of the existing JS data array. Requires tracemap with
trace names and corresponding indices.
Simple check for re-execution was implemented by passing on the selection keys to compare against
on pertinent \code{plotly_event}.
}
