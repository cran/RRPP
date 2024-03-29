% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RRPP.utils.r
\name{getANOVAStats}
\alias{getANOVAStats}
\title{Utility Function for RRPP}
\usage{
getANOVAStats(fit, stat = c("SS", "MS", "Rsq", "F", "cohenf", "all"))
}
\arguments{
\item{fit}{Object from \code{\link{lm.rrpp}}.}

\item{stat}{The ANOVA statistic to extract.  Returns every RRPP permutation of 
the statistic.  If "all", a list of each statistic is returned.}
}
\description{
A function mostly for internal processing but can be used to extract
ANOVA statistics for other uses, such as plotting histograms
}
\examples{
\dontrun{
data(Pupfish)
fit <- lm.rrpp(coords ~ log(CS) + Sex*Pop, SS.type = "I", 
data = Pupfish, print.progress = FALSE, iter = 999) 
anova(fit)
Fstats <- getANOVAStats(fit, stat = "F")
par(mfrow = c(2, 2))
hist(Fstats$Fs[1,], breaks = 50, main = "log(CS)", xlab = "F")
abline(v = Fstats$Fs[1, 1])
hist(Fstats$Fs[2,], breaks = 50, main = "Sex", xlab = "F")
abline(v = Fstats$Fs[2, 1])
hist(Fstats$Fs[3,], breaks = 50, main = "Pop", xlab = "F")
abline(v = Fstats$Fs[3, 1])
hist(Fstats$Fs[4,], breaks = 50, main = "Sex:Pop", xlab = "F")
abline(v = Fstats$Fs[4, 1])
}
}
\author{
Michael Collyer
}
\keyword{utilities}
