% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP.utils.r
\name{plot.kcomp}
\alias{plot.kcomp}
\title{Plot Function for RRPP}
\usage{
\method{plot}{kcomp}(x, axis1 = 1, axis2 = 2, flip = NULL, include.axes = TRUE, ...)
}
\arguments{
\item{x}{An object of class \code{\link{kcomp}}}

\item{axis1}{A value indicating which component should be 
displayed as the X-axis (default = K1)}

\item{axis2}{A value indicating which component should be 
displayed as the Y-axis (default = K2)}

\item{flip}{An argument that if not NULL can be used to flip 
components in the plot.  
The values need to match axis1 or axis2.  For example, if axis1 = 3 
and axis2 = 4, flip = 1 will not
change either axis; flip = 3 will flip only the horizontal axis; 
flip = c(3, 4) will flip both axes.}

\item{include.axes}{A logical argument for whether axes should be shown at x = 0 and y = 0.
This is different than the axes argument in the generic \code{\link{plot.default}} function, which
controls the edges of the plot (providing a box effect or not).  Using include.axes = TRUE does not 
allow aesthetic control of the axes.  If desired, it is better to use include.axes = FALSE and augment
the plot object with \code{\link{abline}} (choosing h = 0 and v = 0 in separate applications).}

\item{...}{other arguments passed to plot (helpful to employ
different colors or symbols for different groups).  See}
}
\value{
An object of class "plot.kcomp" is a list with components
 that can be used in other plot functions, such as the type of plot, points, 
 a group factor, and other information depending on the plot parameters used.
}
\description{
Plot Function for RRPP
}
\author{
Michael Collyer
}
\keyword{utilities}
\keyword{visualization}
