% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP.utils.r
\name{na.omit.rrpp.data.frame}
\alias{na.omit.rrpp.data.frame}
\title{Handle missing values in rrpp.data.frame objects}
\usage{
\method{na.omit}{rrpp.data.frame}(object, ...)
}
\arguments{
\item{object}{object (from \code{\link{rrpp.data.frame}})}

\item{...}{further arguments (currently not used)}
}
\description{
Handle missing values in rrpp.data.frame objects
}
\examples{
y <- matrix(rnorm(15), 5, 3)
x <- rnorm(5)
rdf <- rrpp.data.frame(x = x, y = y, d = dist(y))
rdf$x[1] <- NA # create missing data
rdf

ndf <- na.omit(rdf)
ndf
}
\author{
Michael Collyer
}
\keyword{utilities}
