#' Linear Model Evaluation with a Randomized Residual Permutation Procedure
#'
#' Function performs a linear model fit over many random permutations of 
#' data, using a randomized residual permutation procedure.
#'
#' The function fits a linear model using ordinary least squares (OLS) or 
#' generalized least squares (GLS) estimation of coefficients over any 
#' number of random permutations of the data.  A permutation procedure that 
#' randomizes vectors of residuals is employed.  This
#' procedure can randomize two types of residuals: residuals from null 
#' models or residuals from
#' an intercept model.  The latter is the same as randomizing full values, 
#' and is referred to as
#' as a full randomization permutation procedure (FRPP); the former uses 
#' the residuals from null
#' models, which are defined by the type of sums of squares and cross-products 
#' (SSCP) sought in an
#' analysis of variance (ANOVA), and is referred to as a randomized residual 
#' permutation procedure (RRPP).
#' Types I, II, and III SSCPs are supported.
#'
#' Users define the SSCP type, the permutation procedure type, whether a 
#' covariance matrix is included
#' (GLS estimation), and a few arguments related to computations.   
#' Results comprise observed linear model
#' results (coefficients, fitted values, residuals, etc.), random sums of 
#' squares (SS) across permutation iterations,
#' and other parameters for performing ANOVA and other hypothesis tests, 
#' using empirically-derived probability distributions.
#'
#' \code{lm.rrpp} emphasizes estimation of standard deviates of observed 
#' statistics as effect sizes
#' from distributions of random outcomes.  When performing ANOVA, using 
#' the \code{\link{anova}} function,
#' the effect type (statistic choice) can be varied.  See 
#' \code{\link{anova.lm.rrpp}} for more details.  Please
#' recognize that the type of SS must be chosen prior to running 
#' \code{lm.rrpp} and not when applying \code{\link{anova}}
#' to the \code{lm.rrpp} fit, as design matrices for the linear model 
#' must be created first.  Therefore, SS.type
#' is an argument for \code{lm.rrpp} and effect.type is an argument for 
#' \code{\link{anova.lm.rrpp}}.  If MANOVA
#' statistics are preferred, eigenvalues can be added with 
#' \code{\link{manova.update}} and statistics summarized with
#' \code{\link{summary.manova.lm.rrpp}}.  See \code{\link{manova.update}} 
#' for examples.
#' 
#' The \code{\link{coef.lm.rrpp}} function can be used to test the specific 
#' coefficients of an lm.rrpp fit.  The test
#' statistics are the distances (d), which are also standardized (Z-scores).  
#' The Z-scores might be easier to compare,
#' as the expected values for random distances can vary among coefficient 
#' vectors (Adams and Collyer 2016).
#' 
#'  \subsection{ANOVA vs. MANOVA}{ 
#'  Two SSCP matrices are calculated for each linear model effect, for 
#'  every random permutation: R (Residuals or Random effects) and
#'  H, the difference between SSCPs for "full" and "reduced" models. 
#'  (Full models contain and reduced models lack
#'  the effect tested; SSCPs are hypothesized to be the same under a 
#'  null hypothesis, if there is no effect.  The 
#'  difference, H, would have a trace of 0 if the null hypothesis were 
#'  true.)  In RRPP, ANOVA and MANOVA correspond to
#'  two different ways to calculate statistics from R and H matrices.
#'  
#'  ANOVA statistics are those that find the trace of R and H SSCP 
#'  matrices before calculating subsequent statistics,
#'  including sums of squares (SS), mean squares (MS), and F-values.  
#'  These statistics can be calculated with univariate data
#'  and provide univariate-like statistics for multivariate data.  
#'  These statistics are dispersion measures only (covariances
#'  among variables do not contribute) and are the same as "distance-based" 
#'  stats proposed by Goodall (1991) and Anderson (2001).
#'  MANOVA stats require multivariate data and are implicitly affected 
#'  by variable covariances.  For MANOVA, the inverse of R times
#'  H (invR.H) is first calculated for each effect, then eigenanalysis 
#'  is performed on these matrix products.  Multivariate
#'  statistics are calculated from the positive, real eigenvalues.  In 
#'  general, inferential
#'  conclusions will be similar with either approach, but effect sizes 
#'  might differ.
#'  
#'  ANOVA tables are generated by \code{\link{anova.lm.rrpp}} on lm.rrpp 
#'  fits and MANOVA tables are generated
#'  by \code{\link{summary.manova.lm.rrpp}}, after running manova.update 
#'  on lm.rrpp fits.
#'  
#'  Currently, mixed model effects are only possible with $ANOVA statistics, 
#'  not $MANOVA.
#'  
#'  More detail is found in the vignette, ANOVA versus MANOVA.
#' }
#'
#'  \subsection{Notes for RRPP 0.5.0 and subsequent versions}{ 
#'  The output from lm.rrpp has changed, compared to previous versions.  
#'  First, the $LM
#'  component of output no longer includes both OLS and GLS statistics, 
#'  when GLS fits are 
#'  performed.  Only GLS statistics (coefficients, residuals, fitted values) 
#'  are provided 
#'  and noted with a "gls." tag.  GLS statistics can include those calculated
#'  when weights are input (similar to the \code{\link[stats]{lm}} argument).  
#'  Unlike previous 
#'  versions, GLS and weighted LS statistics are not labeled differently, 
#'  as weighted
#'  LS is one form of generalized LS estimation.  Second, a new object, 
#'  $Models, is included
#'  in output, which contains the linear model fits (\code{\link[stats]{lm}} 
#'  attributes ) for
#'  all reduced and full models that are possible to estimate fits.
#'  
#' }
#' 
#'  \subsection{Notes for RRPP 0.3.1 and subsequent versions}{ 
#'  F-values via RRPP are calculated with residual SS (RSS) found uniquely 
#'  for any model terms, as per
#'  Anderson and ter Braak (2003).  This method uses the random pseudo-data 
#'  generated by each term's
#'  null (reduced) model, meaning RSS can vary across terms.  Previous 
#'  versions used an intercept-only 
#'  model for generating random pseudo-data.  This generally has appropriate 
#'  type I error rates but can have
#'  elevated type I error rates if the observed RSS is small relative 
#'  to total SS.  Allowing term by term
#'  unique RSS alleviates this concern.
#' }
#'
#' @param f1 A formula for the linear model (e.g., y~x1+x2).  Can also 
#' be a linear model fit
#' from \code{\link{lm}}.
#' @param iter Number of iterations for significance testing
#' @param turbo A logical value that if TRUE, suppresses coefficient estimation 
#' in every random permutation.  This will affect subsequent analyses that 
#' require random coefficients (see \code{\link{coef.lm.rrpp}})
#' but might be useful for large data sets for which only ANOVA is needed.
#' @param seed An optional argument for setting the seed for random 
#' permutations of the resampling procedure.
#' If left NULL (the default), the exact same P-values will be found 
#' for repeated runs of the analysis (with the same number of iterations).
#' If seed = "random", a random seed will be used, and P-values will vary.  
#' One can also specify an integer for specific seed values,
#' which might be of interest for advanced users.
#' @param int.first A logical value to indicate if interactions of first 
#' main effects should precede subsequent main effects
#' @param RRPP A logical value indicating whether residual randomization 
#' should be used for significance testing
#' @param full.resid A logical value for whether to use the full model residuals, only 
#' (sensu ter Braak, 1992). This only works if RRPP = TRUE and SS.type = III.  
#' Rather than permuting reduced model residuals,
#' this option permutes only the full model residuals in every random permutation of RRPP.
#' @param block An optional factor for blocks within which to restrict resampling
#' permutations.
#' @param SS.type A choice between type I (sequential), type II 
#' (hierarchical), or type III (marginal)
#' sums of squares and cross-products computations.
#' @param Cov An optional argument for including a covariance matrix 
#' to address the non-independence
#' of error in the estimation of coefficients (via GLS).  If included, 
#' any weights are ignored.
#' @param data A data frame for the function environment, see 
#' \code{\link{rrpp.data.frame}}
#' @param print.progress A logical value to indicate whether a progress 
#' bar should be printed to the screen.
#' This is helpful for long-running analyses.
#' @param Parallel Either a logical value to indicate whether parallel processing 
#' should be used, a numeric value to indicate the number of cores to use, or a predefined
#' socket cluster.  This argument defines parallel processing via the \code{parallel} library. 
#' If TRUE, this argument invokes forking or socket cluster assignment of all processor cores, 
#' except one.  If FALSE, only one core is used. A numeric value directs the number of cores to 
#' use, but one core will always be spared.  If a predefined socket cluster (Windows) is provided,
#' the cluster information will be passed to \code{parallel}.
#' @param verbose A logical value to indicate if all possible output from an analysis 
#' should be retained.  Generally this should be FALSE, unless one wishes to extract, e.g.,
#' all possible terms, model matrices, QR decomposition, or random permutation schemes.
#' @param ... Arguments typically used in \code{\link{lm}}, such as 
#' weights or offset, passed on to
#' \code{LM.fit} (an internal RRPP function) for estimation of coefficients.  
#' If both weights and 
#' a covariance matrix are included,
#' weights are ignored (since inverses of weights are the diagonal elements 
#' of weight matrix, used in lieu
#' of a covariance matrix.)
#' @keywords analysis
#' @export
#' @author Michael Collyer
#' @return An object of class \code{lm.rrpp} is a list containing the 
#' following
#' \item{call}{The matched call.}
#' \item{LM}{Linear Model objects, including data (Y), coefficients, 
#' design matrix (X), sample size
#' (n), number of dependent variables (p), dimension of data space (p.prime),
#' QR decomposition of the design matrix, fitted values, residuals,
#' weights, offset, model terms, data (model) frame, random coefficients 
#' (through permutations),
#' random vector distances for coefficients (through permutations), 
#' whether OLS or GLS was performed, 
#' and the mean for OLS and/or GLS methods. Note that the data returned 
#' resemble a model frame rather than 
#' a data frame; i.e., it contains the values used in analysis, which 
#' might have been transformed according to 
#' the formula.  The response variables are always labeled Y.1, Y.2, ..., 
#' in this frame.}
#' \item{ANOVA}{Analysis of variance objects, including the SS type, 
#' random SS outcomes, random MS outcomes,
#' random R-squared outcomes, random F outcomes, random Cohen's f-squared 
#' outcomes, P-values based on random F
#' outcomes, effect sizes for random outcomes, sample size (n), number of 
#' variables (p), and degrees of freedom for
#' model terms (df).  These objects are used to construct ANOVA tables.}
#' \item{PermInfo}{Permutation procedure information, including the number 
#' of permutations (perms), The method
#' of residual randomization (perm.method), and each permutation's sampling 
#' frame (perm.schedule), which
#' is a list of reordered sequences of 1:n, for how residuals were 
#' randomized.}
#' \item{Models}{Reduced and full model fits for every possible model 
#' combination, based on terms
#' of the entire model, plus the method of SS estimation.}
#' @references Anderson MJ. 2001. A new method for non-parametric 
#' multivariate analysis of variance.
#'    Austral Ecology 26: 32-46.
#' @references Anderson MJ. and C.J.F. ter Braak. 2003. Permutation 
#' tests for multi-factorial analysis of variance. Journal of Statistical 
#' Computation and Simulation 73: 85-113.
#' @references Collyer, M.L., D.J. Sekora, and D.C. Adams. 2015. A method 
#' for analysis of phenotypic change for phenotypes described
#' by high-dimensional data. Heredity. 115:357-365.
#' @references Adams, D.C. and M.L. Collyer. 2016.  On the comparison of 
#' the strength of morphological integration across morphometric
#' datasets. Evolution. 70:2623-2631.
#' @references Adams, D.C and M.L. Collyer. 2018. Multivariate phylogenetic 
#' anova: group-clade aggregation, biological 
#' challenges, and a refined permutation procedure. Evolution. 72:1204-1215.
#' @seealso \code{procD.lm} and \code{procD.pgls} within \code{geomorph}; 
#' @references ter Braak, C.J.F. 1992. Permutation versus bootstrap significance tests in 
#' multiple regression and ANOVA. pp .79–86 In Bootstrapping and Related Techniques. eds K-H. Jockel, 
#' G. Rothe & W. Sendler.Springer-Verlag, Berlin.
#' \code{\link[stats]{lm}} for more on linear model fits.
#' @examples
#' \dontrun{
#' 
#' # Examples use geometric morphometric data
#' # See the package, geomorph, for details about obtaining such data
#'
#' data("PupfishHeads")
#' names(PupfishHeads)
#' 
#' # Head Size Analysis (Univariate)-------------------------------------------------------
#'
#' fit <- lm.rrpp(log(headSize) ~ sex + locality/year, SS.type = "I", 
#' data = PupfishHeads, print.progress = FALSE, iter = 999)
#' summary(fit)
#' anova(fit, effect.type = "F") # Maybe not most appropriate
#' anova(fit, effect.type = "Rsq") # Change effect type, but still not 
#' # most appropriate
#'
#' # Mixed-model approach (most appropriate, as year sampled is a random 
#' # effect:
#' 
#' anova(fit, effect.type = "F", error = c("Residuals", "locality:year", 
#' "Residuals"))
#'
#' # Change to Type III SS
#' 
#' fit <- lm.rrpp(log(headSize) ~ sex + locality/year, SS.type = "III", 
#' data = PupfishHeads, print.progress = FALSE, iter = 999,
#' verbose = TRUE)
#' summary(fit)
#' anova(fit, effect.type = "F", error = c("Residuals", "locality:year", 
#' "Residuals"))
#'
#' # Coefficients Test
#' 
#' coef(fit, test = TRUE)
#'
#' # Predictions (holding alternative effects constant)
#' 
#' sizeDF <- data.frame(sex = c("Female", "Male"))
#' rownames(sizeDF) <- c("Female", "Male")
#' sizePreds <- predict(fit, sizeDF)
#' summary(sizePreds)
#' plot(sizePreds)
#' 
#' # Diagnostics plots of residuals
#' 
#' plot(fit)
#' 
#' # Body Shape Analysis (Multivariate) -----------
#' 
#' data(Pupfish)
#' names(Pupfish)
#' 
#' # Note:
#' 
#' dim(Pupfish$coords) # highly multivariate!

#' fit <- lm.rrpp(coords ~ log(CS) + Sex*Pop, SS.type = "I", 
#' data = Pupfish, print.progress = FALSE, iter = 999,
#' verbose = TRUE) 
#' summary(fit, formula = FALSE)
#' anova(fit) 
#' coef(fit, test = TRUE)
#'
#' # Predictions (holding alternative effects constant)
#' 
#' shapeDF <- expand.grid(Sex = levels(Pupfish$Sex), 
#' Pop = levels(Pupfish$Pop))
#' rownames(shapeDF) <- paste(shapeDF$Sex, shapeDF$Pop, sep = ".")
#' shapeDF
#' 
#' shapePreds <- predict(fit, shapeDF)
#' summary(shapePreds)
#' summary(shapePreds, PC = TRUE)
#' 
#' # Plot prediction
#' 
#' plot(shapePreds, PC = TRUE)
#' plot(shapePreds, PC = TRUE, ellipse = TRUE)
#' 
#' # Diagnostics plots of residuals
#' 
#' plot(fit)
#' 
#' # PC-plot of fitted values
#' 
#' groups <- interaction(Pupfish$Sex, Pupfish$Pop)
#' plot(fit, type = "PC", pch = 19, col = as.numeric(groups))
#' 
#' # Regression-like plot
#' 
#' plot(fit, type = "regression", reg.type = "PredLine", 
#'     predictor = log(Pupfish$CS), pch=19,
#'     col = as.numeric(groups))
#'
#' # Body Shape Analysis (Distances) ----------
#' 
#' D <- dist(Pupfish$coords) # inter-observation distances
#' length(D)
#' Pupfish$D <- D
#' 
#' fitD <- lm.rrpp(D ~ log(CS) + Sex*Pop, SS.type = "I", 
#' data = Pupfish, print.progress = FALSE, iter = 999) 
#' 
#' # These should be the same:
#' summary(fitD, formula = FALSE)
#' summary(fit, formula = FALSE) 
#'
#' # GLS Example (Univariate) -----------
#' 
#' data(PlethMorph)
#' fitOLS <- lm.rrpp(TailLength ~ SVL, data = PlethMorph, 
#' print.progress = FALSE, iter = 999)
#' fitGLS <- lm.rrpp(TailLength ~ SVL, data = PlethMorph, Cov = PlethMorph$PhyCov, 
#' print.progress = FALSE, iter = 999)
#' 
#' anova(fitOLS)
#' anova(fitGLS)
#' 
#' sizeDF <- data.frame(SVL = sort(PlethMorph$SVL))
#' 
#' # Prediction plots
#' 
#' # By specimen
#' plot(predict(fitOLS, sizeDF)) # Correlated error
#' plot(predict(fitGLS, sizeDF)) # Independent error
#' 
#' # With respect to independent variable (using abscissa)
#' plot(predict(fitOLS, sizeDF), abscissa = sizeDF) # Correlated error
#' plot(predict(fitGLS, sizeDF), abscissa = sizeDF) # Independent error
#' 
#' 
#' # GLS Example (Multivariate) -----------
#' 
#' Y <- as.matrix(cbind(PlethMorph$TailLength,
#' PlethMorph$HeadLength,
#' PlethMorph$Snout.eye,
#' PlethMorph$BodyWidth,
#' PlethMorph$Forelimb,
#' PlethMorph$Hindlimb))
#' PlethMorph$Y <- Y
#' fitOLSm <- lm.rrpp(Y ~ SVL, data = PlethMorph, 
#' print.progress = FALSE, iter = 999)
#' fitGLSm <- lm.rrpp(Y ~ SVL, data = PlethMorph, 
#' Cov = PlethMorph$PhyCov,
#' print.progress = FALSE, iter = 999)
#' 
#' anova(fitOLSm)
#' anova(fitGLSm)
#' 
#' # Prediction plots
#' 
#' # By specimen
#' plot(predict(fitOLSm, sizeDF)) # Correlated error
#' plot(predict(fitGLSm, sizeDF)) # Independent error
#' 
#' # With respect to independent variable (using abscissa)
#' plot(predict(fitOLSm, sizeDF), abscissa = sizeDF) # Correlated error
#' plot(predict(fitGLSm, sizeDF), abscissa = sizeDF) # Independent error
#' }

lm.rrpp <- function(f1, iter = 999, turbo = FALSE, seed = NULL, int.first = FALSE,
                     RRPP = TRUE, full.resid = FALSE, block = NULL,
                     SS.type = c("I", "II", "III"),
                     data = NULL, Cov = NULL,
                     print.progress = FALSE, Parallel = FALSE, 
                     verbose = FALSE, ...) {
  
  L <- c(as.list(environment()), list(...))
  L$SS.type <- match.arg(SS.type)
  L$subjects <- NULL
  out <- do.call(.lm.rrpp, L)
  out$call <- match.call()
  out
}