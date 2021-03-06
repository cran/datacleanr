% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{navbarPageWithInputs}
\alias{navbarPageWithInputs}
\title{Navbar with Input}
\source{
\url{https://github.com/daattali/advanced-shiny/tree/master/navbar-add-text}
}
\usage{
navbarPageWithInputs(..., inputs)
}
\arguments{
\item{...}{Regular Navbar elements, like tabPanel}

\item{inputs}{shiny ui inputs}
}
\value{
Navbar function that allows adding inputs
}
\description{
Call this function with an input (such as \code{textInput("text", NULL, "Search")}) if you
want to add an input to the navbar
}
