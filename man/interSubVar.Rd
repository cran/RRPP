% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/interSubVar.r
\name{interSubVar}
\alias{interSubVar}
\title{Reveal the inter-subject variability from a measurement error analysis}
\usage{
interSubVar(ME, type = c("range", "sd", "var", "cv"))
}
\arguments{
\item{ME}{A measurement error object}

\item{type}{A value to indicate the type of variability (statistic)
to measure, which can be
one of range (the maximum value minus the minimum value, not the two values),
standard deviation (sd), variance (var), or coefficient of variation (cv).  No 
attempt is made to assure the distribution of values is appropriate for the 
statistics.  For example, if only two replicates are available, using sd, var, or
cv might not be wise.  Or if the replicated values are exact, cv 
will be NA (and other stats will be 0).  Choice of statistic should consider
the distribution of values.}
}
\value{
An object of class \code{interSubVar} is a list containing the 
following
\item{var.map}{A distance matrix object with values that map the variability
statistic used for inter-subject Euclidean distances.}
\item{distance.mats}{The inter-subject distance matrices for every replicate.}
\item{subject.order}{A vector of subject levels in the order that was used to
guarantee consistent sorting across distance matrices.}
\item{var.map}{The variability type (statistic) that was used.}
}
\description{
Function produces both a list of inter-subject Euclidean distance matrices, 
based on replicate measurements of the same subjects, and one matrix that 
summarizes the variability among the inter-subject distances, across subjects.  
This function can be considered a tool for the evaluation of subject 
estimate precision.  The function, \code{\link{plot.interSubVar}} can produce a 
heat map of the inter-subject variability.
}
\examples{

\dontrun{
# Measurement error analysis on simulated data of fish shapes

data(fishy)

# Analysis unconcerned with groups 

ME1 <- measurement.error(
  Y = "coords",
  subjects = "subj",
  replicates = "reps",
  data = fishy)

anova(ME1)
ICCstats(ME1, subjects = "Subjects", with_in = "Systematic ME")
plot(ME1)

# Analysis concerned with groups 

ME2 <- measurement.error(
  Y = "coords",
  subjects = "subj",
  replicates = "reps",
  groups = "groups",
  data = fishy)

anova(ME2)
ICCstats(ME2, subjects = "Subjects", 
  with_in = "Systematic ME", groups = "groups")
P <- plot(ME2)
focusMEonSubjects(P, subjects = 18:20, shadow = TRUE)
 }
 
}
\author{
Michael Collyer
}
\keyword{utilities}
