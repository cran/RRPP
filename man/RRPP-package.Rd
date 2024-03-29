% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP-package.R, R/RRPP.support.code.r
\docType{package}
\name{RRPP-package}
\alias{RRPP-package}
\alias{RRPP}
\title{RRPP: Linear Model Evaluation with Randomized Residuals in a Permutation Procedure}
\value{
Key functions for this package:
\item{\code{\link{lm.rrpp}}}{Fits linear models, using RRPP.
plus model comparisons.}
\item{\code{\link{coef.lm.rrpp}}}{Extract coefficients or perform test 
on coefficients, using RRPP.}
\item{\code{\link{predict.lm.rrpp}}}{Predict values from lm.rrpp fits 
and generate bootstrapped confidence intervals.}
\item{\code{\link{pairwise}}}{Perform pairwise tests, based on lm.rrpp 
model fits.}
}
\description{
Linear model calculations are made for many random versions of data. Using residual randomization in a permutation procedure, sums of squares are calculated over many permutations to generate empirical probability distributions for evaluating model effects. This packaged is described by Collyer & Adams (2018). Additionally, coefficients, statistics, fitted values, and residuals generated over many permutations can be used for various procedures including pairwise tests, prediction, classification, and model comparison. This package should provide most tools one could need for the analysis of high-dimensional data, especially in ecology and evolutionary biology, but certainly other fields, as well.

Functions in this package allow one to evaluate linear models 
with residual randomization.
The name, "RRPP", is an acronym for, "Randomization of Residuals in a 
Permutation Procedure."  Through
the various functions in this package, one can use randomization of 
residuals to generate empirical probability
distributions for linear model effects, for high-dimensional data or 
distance matrices.

An especially useful option of this package is to fit models with 
either ordinary or generalized
least squares estimation (OLS or GLS, respectively), using theoretic 
covariance matrices.  Mixed linear
effects can also be evaluated.
}
\seealso{
Useful links:
\itemize{
  \item \url{https://github.com/mlcollyer/RRPP}
}

}
\author{
\strong{Maintainer}: Michael Collyer \email{mlcollyer@gmail.com} (\href{https://orcid.org/0000-0003-0238-2201}{ORCID})

Authors:
\itemize{
  \item Dean Adams (\href{https://orcid.org/0000-0001-9172-7894}{ORCID})
}


Michael Collyer and Dean Adams
}
\keyword{internal}
