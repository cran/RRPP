% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP.utils.r
\name{add.trajectories}
\alias{add.trajectories}
\title{Plot Function for RRPP}
\usage{
add.trajectories(
  TP,
  traj.pch = 21,
  traj.col = 1,
  traj.lty = 1,
  traj.lwd = 1,
  traj.cex = 1.5,
  traj.bg = 1,
  start.bg = 3,
  end.bg = 2
)
}
\arguments{
\item{TP}{plot object (from \code{\link{plot.trajectory.analysis}})}

\item{traj.pch}{Plotting "character" for trajectory points.
Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for pch.}

\item{traj.col}{The color of trajectory lines.
Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for col.}

\item{traj.lty}{Trajectory line type.  Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for lty.}

\item{traj.lwd}{Trajectory line width.  Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for lwd.}

\item{traj.cex}{Trajectory point character expansion.  Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for cex.}

\item{traj.bg}{Trajectory point background.  Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for bg.}

\item{start.bg}{Trajectory point background, just the start points.
Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for bg.  Green start points are the default.}

\item{end.bg}{Trajectory point background, just the end points.
Can be a single value or vector 
of length equal to the number of trajectories.  
See \code{\link{par}} and its description 
for bg.  Red end points are the default.}
}
\description{
Function adds trajectories to a principal component plot
}
\details{
The function adds trajectories to a plot made by 
 \code{\link{plot.trajectory.analysis}}.
 This function has a restricted set of plot parameters 
 based on the number of trajectories
 to be added to the plot.
}
\references{
Adams, D. C., and M. M. Cerney. 2007. 
Quantifying biomechanical motion using Procrustes 
  motion analysis. J. Biomech. 40:437-444.

Adams, D. C., and M. L. Collyer. 2007. 
The analysis of character divergence along environmental 
  gradients and other covariates. Evolution 61:510-515.

Adams, D. C., and M. L. Collyer. 2009. 
A general framework for the analysis of phenotypic 
  trajectories in evolutionary studies. Evolution 63:1143-1154.

Collyer, M. L., and D. C. Adams. 2007. 
Analysis of two-state multivariate phenotypic change 
  in ecological studies. Ecology 88:683-692.

Collyer, M. L., and D. C. Adams. 2013. 
Phenotypic trajectory analysis: comparison of shape change patterns 
in evolution and ecology. Hystrix 24: 75-83.

Collyer, M.L., D.J. Sekora, and D.C. Adams. 2015. 
A method for analysis of phenotypic change for phenotypes described 
by high-dimensional data. Heredity. 115:357-365.
}
\seealso{
\code{\link{plot.default}} and \code{\link{par}}
}
\author{
Michael Collyer
}
\keyword{utilities}
\keyword{visualization}
