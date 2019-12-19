#' MANOVA update for lm.rrpp model fits
#' 
#' @description 
#' Function updates a lm.rrpp fit to add $MANOVA, which like $ANOVA, provides statistics
#' or matrices typically associated with multivariate analysis of variance (MANOVA).
#' 
#' MANOVA statistics or sums of squares and cross-products (SSCP) matrices
#' are calculated over the random permutations of a \code{\link{lm.rrpp}} fit.  SSCP matrices are 
#' computed, as are the inverse of R time H (invR.H), where R is a SSCP for the residuals or random effects and H is
#' the difference between SSCP matrices of full and reduced models (see below).   From invR.H,
#' MANOVA statistics are calculated, including Roy's maximum root (eigen value), Pillai trace, Hotelling-Lawley trace,
#' and Wilks lambda (via \code{\link{summary.manova.lm.rrpp}}).
#' 
#' The manova.update to add $MANOVA to \code{\link{lm.rrpp}} fits requires more computation time than the $ANOVA
#' statistics that are computed automatically in \code{\link{lm.rrpp}}.  Generally, the same inferential conclusions will
#' be found with either approach, when observations outnumber response variables.  For high-dimensional data (more variables
#' than observations) data are projected into a Euclidean space of appropriate dimensions (rank of residual covariance matrix).  
#' One can vary the tolerance for eigenvalue decay or specify the number of PCs, if a smaller set of PCs than the maximum is desired.  
#' This is advised if there is strong correlation among variables (the data space could be simplified to fewer dimensions), as spurious
#' results are possible.  When observations outnumber variables, projection of data onto PCs yields the same results as the original 
#' variables.  Because distributions of MANOVA stats can be generated from the random permutations,
#' there is no need to approximate F-values, like with parametric MANOVA. By restricting analysis to the real, positive eigen values calculated,
#' all statistics can be calculated (but Wilks lambda, as a product but not a trace, might be less reliable as variable number approaches
#' the number of observations).
#' 
#'  \subsection{ANOVA vs. MANOVA}{ 
#'  Two SSCP matrices are calculated for each linear model effect, for every random permutation: R (Residuals or Random effects) and
#'  H, the difference between SSCPs for "full" and "reduced" models. (Full models contain and reduced models lack
#'  the effect tested; SSCPs are hypothesized to be the same under a null hypothesis, if there is no effect.  The 
#'  difference, H, would have a trace of 0 if the null hypothesis were true.)  In RRPP, ANOVA and MANOVA correspond to
#'  two different ways to calculate statistics from R and H matrices.
#'  
#'  ANOVA statistics are those that find the trace of R and H SSCP matrices before calculating subsequent statistics,
#'  including sums of squares (SS), mean squares (MS), and F-values.  These statistics can be calculated with univariate data
#'  and provide univariate-like statistics for multivariate data.  These statistics are dispersion measures only (covariances
#'  among variables do not contribute) and are the same as "distance-based" stats proposed by Goodall (1991) and Anderson (2001).
#'  MANOVA stats require multivariate data and are implicitly affected by variable covariances.  For MANOVA, the inverse of R times
#'  H (invR.H) is first calculated for each effect, then eigenanalysis is performed on these matrix products.  Multivariate
#'  statistics are calculated from the positive, real eigenvalues.  In general, inferential
#'  conclusions will be similar with either approach, but effect sizes might differ.
#'  
#'  ANOVA tables are generated by \code{\link{anova.lm.rrpp}} on lm.rrpp fits and MANOVA tables are generated
#'  by \code{\link{summary.manova.lm.rrpp}}, after running manova.update on lm.rrpp fits.
#'  
#'  Currently, mixed model effects are only possible with $ANOVA statistics, not $MANOVA.
#'  
#'  More detail is found in the vignette, ANOVA versus MANOVA.  
#' }
#' 
#' @references Goodall, C.R. 1991. Procrustes methods in the statistical analysis of shape. Journal of the 
#'    Royal Statistical Society B 53:285-339.
#' @references Anderson MJ. 2001. A new method for non-parametric multivariate analysis of variance.
#'    Austral Ecology 26: 32-46.
#' @param fit Linear model fit from \code{\link{lm.rrpp}}
#' @param error An optional character string to define R matrices used to calculate invR.H.
#' (Currently only Residuals can be used and this argument defaults to NULL.  Future versions
#' will update this argument.)
#' @param tol A tolerance value for culling data dimensions to prevent spurious results.  The distribution
#' of eigenvalues for the data will be examined and if the decay becomes less than the tolerance,
#' the data will be truncated to principal components ahead of this point.  This will possibly prevent spurious results
#' calculated from eigenvalues near 0.  If tol = 0, all possible PC axes are used, which is likely
#' not a problem if observations outnumber variables.
#' @param PC.no A value that, if not NULL,  overrides the tolerance argument, and forces a desired number of 
#' data PCs to use for analysis.  If a value larger than the possible number of PCs is chosen, the full compliment of PCs
#' (the full data space) will be used.  
#' @param print.progress A logical value to indicate whether a progress bar should be printed to the screen.
#' This is helpful for long-running analyses.
#' @keywords analysis
#' @export
#' @author Michael Collyer
#' @return An object of class \code{lm.rrpp} is updated to include class \code{manova.lm.rrpp}, and the object,
#' $MANOVA, which includes
#' \item{SSCP}{Terms and Model SSCP matrices.}
#' \item{invR.H}{The inverse of the residuals SSCP times the H SSCP.}
#' \item{eigs}{The eigenvalues of invR.H.}
#' \item{e.rank}{Rank of the error (residuals) covariance matrix.  Currently NULL only.}
#' \item{PCA}{Principal component analysis of data, using either tol or PC.no.}
#' \item{manova.pc.dims}{Resulting number of PC vectors in teh analysis.}
#' \item{e.rank}{Rank of the residual (error) covariance matrix, irrespective of the number of dimensions 
#'  used for analysis.}
#' 
#' @examples 
#'    
#' # Body Shape Analysis (Multivariate) ----------------------------------------------------
#' 
#' data(Pupfish)
#' 
#' # Although not recommended as a practice, this example will use only
#' # three principal components of body shape for demonstration.  A larger
#' # number of random permutations should also be used.
#' 
#' Pupfish$shape <- prcomp(Pupfish$coords)$x[, 1:3]
#' 
#' Pupfish$logSize <- log(Pupfish$CS) # better to not have functions in formulas
#' 
#' fit <- lm.rrpp(shape ~ logSize + Sex, SS.type = "I", 
#' data = Pupfish, print.progress = FALSE, iter = 499) 
#' summary(fit, formula = FALSE)
#' anova(fit) # ANOVA table
#' 
#' # MANOVA
#' 
#' fit.m <- manova.update(fit, print.progress = FALSE, tol = 0.001)
#' summary(fit.m, test = "Roy")
#' summary(fit.m, test = "Pillai")
#' 
#' fit.m$MANOVA$eigs$logSize[1:3] # eigenvalues first three iterations
#' fit.m$MANOVA$eigs$Sex[1:3] # eigenvalues first three iterations
#' 
#' fit.m$MANOVA$invR.H$logSize[1:3] # invR.H first three iterations
#' fit.m$MANOVA$invR.H$Sex[1:3] # invR.H first three iterations
#' 
#' # Distributions of test statistics
#' 
#' summ.roy <- summary(fit.m, test = "Roy")
#' dens <- apply(summ.roy$rand.stats, 2, density)
#' par(mfcol = c(1, length(dens)))
#' for(i in 1:length(dens)) {
#'      plot(dens[[i]], xlab = "Roy max root", ylab = "Density",
#'      type = "l", main = names(dens)[[i]])
#'      abline(v = summ.roy$rand.stats[1, i], col = "red")
#' }
#' par(mfcol = c(1,1))
#' 

manova.update <- function(fit, error = NULL, 
                              tol = 0.01, PC.no = NULL,
                              print.progress = TRUE) {
  if(inherits(fit, "manova.lm.rrpp")) stop("\nlm.rrpp object has already been updated for MANOVA.\n", 
                                           call. = FALSE)
  if(!inherits(fit, "lm.rrpp")) stop("\nOnly an lm.rrpp object can be updated for MANOVA.\n", 
                                     call. = FALSE)
  p <- fit$LM$p
  if(p < 2) stop("\n Multiple responses are required for this analysis.\n", call. = FALSE)
  p.prime <- fit$LM$p.prime
  n <- fit$LM$n
  gls <- fit$LM$gls
  w <- if(!is.null(fit$LM$weights)) fit$LM$weights else NULL
  Pcov <- if(!is.null(fit$LM$Pcov)) fit$LM$Pcov else NULL
  
  perm.method <- fit$PermInfo$perm.method
  if(perm.method == "RRPP") RRPP = TRUE else RRPP = FALSE
  ind <- fit$PermInfo$perm.schedule
  perms <- length(ind)
  
  reduced <- fit$Models$reduced
  full <- fit$Models$full
  Terms <- fit$LM$Terms
  trms <- attr(Terms, "term.labels")
  k <- length(trms)
  if(k == 0) stop("\nNo model terms from which to calculate SSCPs.\n",
                  call. = FALSE)
  int <- attr(Terms, "intercept")
  
  E.rank <- qr(var(full[[k]]$residuals))$rank
  
  Y <- fit$LM$Y
  
  d <- svd(var(fit$LM$Y))$d
  SS.tot <- sum(d)
  d <- cumsum(d/sum(d))
  dd <- rep(0, length(d) - 1)
  for(i in 2:length(d)) dd[i - 1] <- (d[i] - d[i - 1])
  dd <- c(1, dd)
  if(tol > 0) d <- which(dd >= tol) else d <- 1:p.prime
  if(!is.null(PC.no)) {
    d <- 1:PC.no
    if(PC.no > p.prime) d <- 1:p.prime
  }
  PCA <- prcomp(fit$LM$Y, tol = tol)
  dd <- zapsmall(PCA$sdev^2)
  dd <- dd[dd > 0]
  if(length(dd) < length(d)) d <- 1:length(dd) else d <- 1:length(d)
  PCA$sdev <- PCA$sdev[d]
  PCA$rotation <- PCA$rotation[, d]
  Y <- PCA$x[, d]
  p.prime <- length(d)
  
  if(!is.null(Pcov)) Y <- Pcov %*% Y
  if(!is.null(w)) Y <- Y * sqrt(w)
  
  if(!is.null(error)) {
    if(!inherits(error, "character")) stop("The error description is illogical.  It should be a string of character values matching ANOVA terms.",
                                           call. = FALSE)
    kk <- length(error)
    if(kk != k) stop("The error description should match in length the number of ANOVA terms (not including Residuals)",
                     call. = FALSE)
    Ematch <- match(error, c(trms, "Residuals"))
    if(any(is.na(Ematch))) stop("At least one of the error terms is not an ANOVA term",
                                call. = FALSE)
  } else Ematch <- NULL
  
  # Until a better solution is found, this must be forced
  error <- Ematch <- NULL
  
  Qr <- lapply(reduced, function(q) q$qr)
  Qf <- lapply(full, function(q) q$qr)
  
  Ur <- lapply(Qr, qr.Q)
  Uf <- lapply(Qf, qr.Q)
  
  if(is.null(w) && !is.null(Pcov)) {
    Unull <- qr.Q(qr(crossprod(Pcov, rep(int, n))))
  } else if(gls){
    Unull <- qr.Q(qr(rep(int, n) * sqrt(w)))
  } else Unull <- qr.Q(qr(rep(int, n)))
  
  Ufull <- Uf[[k]]
  if(!is.null(Pcov)) yh0 <- fastFit(Unull, Pcov %*% Y, n, p) else
    if(!is.null(w)) yh0 <- fastFit(Unull, Y * sqrt(w), n, p) else
      yh0 <- fastFit(Unull, Y, n, p)
  
  r0 <- Y - yh0
  
  fitted <- Map(function(u) fastFit(u, Y, n, p.prime), Ur)
  res <- Map(function(u) Y - fastFit(u, Y, n, p.prime), Ur)
  
  sscp <- function(Uf, Ur, Ufull, Unull, Y, n, p, Yt) {
    ss <- Map(function(uf, ur, y) crossprod(fastFit(uf, y, n, p.prime) -
                                              fastFit(ur, y, n, p.prime)), Uf, Ur, Y)
    tss <- crossprod(Yt) - crossprod(fastFit(Unull, Yt, n, p.prime)) 
    rss <- crossprod(Yt) - crossprod(fastFit(Ufull, Yt, n, p.prime)) 
    result <- c(ss, list(tss - rss, rss))
    names(result)[-(1:k)] <- c("Full.Model","Residuals")
    result
    
  }
  
  rrpp <- function(fitted, residuals, ind.i) {
    if(k > 0) Map(function(f, r) f + r[ind.i,], fitted, residuals) else
      fitted + residuals[ind.i,]
  }
  
  sscp.args <- list(Uf = Uf, Ur = Ur, 
                    Ufull = Ufull, Unull = Unull,
                    Y = rrpp(fitted, res, ind[[1]]), 
                    n = n, p = p.prime,
                    Yt = Y)
  
  
  invR.H <- function(ss){
    k <- length(ss) - 2
    rss <- ss[[k+2]]
    rss.inv <- fast.solve(rss)
    result <- lapply(1:(k+1), function(j){
      rss.inv %*% ss[[j]]
    })
    names(result)[1:k] <- names(ss)[1:k]
    result
  }
  
  getEigs <- function(x)
    Re(eigen(x, symmetric = FALSE, only.values = TRUE)$values)
  
  getEigsL <- function(L) t(sapply(L, getEigs))
  
  rrpp.args <- list(fitted = fitted, 
                    residuals = res,
                    ind.i = NULL)
  
  if(print.progress){
    cat(paste("\nCalculation of SSCP matrix products:", perms, "permutations.\n")) 
    pb <- txtProgressBar(min = 0, max = perms+1, initial = 0, style=3)
  }
  
  result <- lapply(1: perms, function(j){
    step <- j
    if(print.progress) setTxtProgressBar(pb,step)
    x <- ind[[j]]
    rrpp.args$ind.i <- x
    sscp.args$Y <- do.call(rrpp, rrpp.args)
    sscp.args$Yt <- yh0 + r0[x, ]
    ss <- do.call(sscp, sscp.args)
    invRH <- invR.H(ss)
    eigs <- getEigsL(invRH)
    list(SSCP = ss, invR.H = invRH, eigs = eigs)
    
  })
  
  
  if(print.progress) {
    step <- perms + 1
    setTxtProgressBar(pb,step)
    close(pb)
  }
  
  names(result) <- c("obs", paste("iter", 1:(perms - 1), sep = "."))
  SSCP <- lapply(result, function(x) x$SSCP)
  invR.H <- lapply(result, function(x) x$invR.H)
  eigs <- lapply(result, function(x) x$eigs)
  
  out <- fit
  out$MANOVA <- list(SSCP = SSCP, invR.h = invR.H, eigs = eigs,
                     error = error, PCA = PCA, manova.pc.dims = d, 
                     e.rank = E.rank, SS.tot = SS.tot)
  
  class(out) <- c("manova.lm.rrpp", class(fit))
  out
}