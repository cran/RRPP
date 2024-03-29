% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP.utils.r
\name{getModelCov}
\alias{getModelCov}
\title{Utility Function for RRPP}
\usage{
getModelCov(
  fit,
  type = c("Cov", "Pcov"),
  format = c("S3", "S4"),
  forceSym = TRUE
)
}
\arguments{
\item{fit}{Object from \code{\link{lm.rrpp}}}

\item{type}{Whether the Cov or Pcov matrix is returned}

\item{format}{Whether an S3 or S4 format is returned}

\item{forceSym}{Logical value for whether a symmetric matrix should 
be returned for Pcov, even if Pcov was triangular as a solution.}
}
\description{
A function mostly for internal processing but can be used to extract either
the model covariance matrix (Cov) or the projection matrix for transformations made 
from the covariance matrix (Pcov), which is basically the square-root of 
the covariance matrix.  This matrix is the model covariance used for estimation,
not the residual covariance matrix (see \code{\link{getResCov}}). 
There are also options for S3 or S4 format versions, or
a forcing of symmetry for Pcov.
}
\author{
Michael Collyer
}
\keyword{utilities}
