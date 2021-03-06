% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prep.lda.r
\name{prep.lda}
\alias{prep.lda}
\title{Linear discriminant function for lm.rrpp model fits}
\usage{
prep.lda(
  fit,
  tol = 1e-07,
  PC.no = NULL,
  newdata = NULL,
  inherent.groups = FALSE,
  ...
)
}
\arguments{
\item{fit}{A linear model fit using \code{\link{lm.rrpp}}.}

\item{tol}{A tolerance used to decide if the matrix of data is singular.
This value is passed onto both
\code{\link[MASS]{lda}} and \code{\link[stats]{prcomp}}, internally.}

\item{PC.no}{An optional argument to define the specific number of 
principal components (PC) used in analysis.
The minimum of this value or the number of PCs resulting from the tol 
argument will be used.}

\item{newdata}{An optional matrix (or object coercible to a matrix) for 
classification.  If NULL,
all observed data are used.}

\item{inherent.groups}{A logical argument in case one wishes to have the 
inherent groups in the model fit revealed.  If 
TRUE, no other analysis will be done than to reveal the groups.  This 
argument should always be FALSE to perform 
a classification analysis.}

\item{...}{Arguments passed to \code{\link[MASS]{lda}}.
See \code{\link[MASS]{lda}} for details}
}
\value{
A list of arguments that can be passed to \code{\link[MASS]{lda}}.  
As a minimum, these arguments include
$x, $grouping, and $tol.  If newdata is not NULL, $newdata, using the same 
transformation and PCs as for the data,
will also be included.
}
\description{
Function creates arguments for \code{\link[MASS]{lda}} 
or \code{\link[MASS]{qda}} from a \code{\link{lm.rrpp}} fit.
}
\details{
This function uses a \code{\link{lm.rrpp}} fit to produce the 
data and the groups to use in \code{\link[MASS]{lda}} or
\code{\link[MASS]{qda}}.There are two general purposes of this 
function that are challenging when using \code{\link[MASS]{lda}}, directly.
First, this function finds the inherent groups in the \code{\link{lm.rrpp}} 
fit, based on factor levels.  Second,
this function find pseudodata - rather than the observed data - 
that involve either or both a principal component projection
with appropriate (or user-prescribed) dimensions and a transformation.  
The principal component projection incorporates GLS 
mean-centering, where appropriate.  Transformation involves holding 
non-grouping model terms constant.  This is accomplished by using
the fitted values from the \code{\link{lm.rrpp}} fit and the residuals 
of a \code{\link{lm.rrpp}} fit with grouping factors, alone.  When,
the \code{\link{lm.rrpp}} fit contains only grouping factors, this 
function produces raw data projected on principal components.

Regardless of variables input, data are projected onto PCs.  The 
purpose of this function is to predict 
group association, and working in PC space facilitates this objective.

This is a new function and not all limits and scenarios have been 
tested before its release.  Please report 
any issues or limitations or strange results to the maintainer.  

 \subsection{Notes for RRPP 0.5.0 and subsequent versions}{ 
 Prior to version 0.5.0, the function, \code{\link{classify}}, was 
 available.  This function has been deprecated.
 It mimicked \code{\link[MASS]{lda}} with added features that are 
 largely retained with \code{prep.lda}.  However,
 \code{prep.lda} facilitates the much more diverse options available 
 with \code{\link[MASS]{lda}}.
 
}
}
\examples{

# Using the Pupfish data (see lm.rrpp help for more detail)

data(Pupfish)
Pupfish$logSize <- log(Pupfish$CS) 
fit <- lm.rrpp(coords ~ logSize + Sex * Pop, SS.type = "I", 
data = Pupfish, print.progress = FALSE, iter = 0)

prep.lda(fit, inherent.groups = TRUE) # see groups available
lda.args <- prep.lda(fit, CV = TRUE, PC.no = 6)
lda.args$x
lda.args$grouping

# not run:
# library(MASS)
# LDA <- do.call(lda, lda.args)
# LDA$posterior
# table(lda.args$grouping, LDA$class)

}
\seealso{
\code{\link[MASS]{lda}}, \code{\link[MASS]{predict.lda}}, 
\code{\link[MASS]{qda}},
\code{\link[MASS]{predict.qda}}
}
\author{
Michael Collyer
}
\keyword{analysis}
