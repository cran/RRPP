#' Scaling of a Covariance Matrix
#'
#' Function performs linear and exponential scaling of a covariance, 
#' either including or excluding diagonals or off-diagonal elements.  
#' 
#' The function scales covariances as scale * cov ^exponent, where cov is any 
#' covariance or variance in the covariance matrix.  Arguments allow inclusion
#' or exclusion or either the diagonal or off-diagonal elements to be scaled.  It is 
#' assumed that a covariance matrix is scaled, but any square matrix will work.
#' @param Cov Square matrix to be scaled.
#' @param scale. The linear scaling parameter.  Values are multiplied by this numeric value.
#' @param exponent The exponentiation scaling parameter.  Values are raised to this power.
#' @param scale.diagonal Logical to indicate if diagonal should be included.
#' @param scale.only.diagonal Logical to indicate if only the diagonal should be scaled.
#' 
#' @keywords analysis
#' @export
#' @author Michael Collyer
#' @return A square matrix.
#' @examples 
#' \dontrun{
#' data(Pupfish)
#' Pupfish$logSize <- log(Pupfish$CS)
#' fit1 <- lm.rrpp(coords ~ logSize, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' fit2 <- lm.rrpp(coords ~ Pop, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' fit3 <- lm.rrpp(coords ~ Sex, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' fit4 <- lm.rrpp(coords ~ logSize + Sex, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' fit5 <- lm.rrpp(coords ~ logSize + Pop, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' fit6 <- lm.rrpp(coords ~ logSize + Sex * Pop, data = Pupfish, iter = 0, 
#' print.progress = FALSE)
#' 
#' modComp1 <- model.comparison(fit1, fit2, fit3, fit4, fit5, 
#' fit6, type = "cov.trace")
#' modComp2 <- model.comparison(fit1, fit2, fit3, fit4, fit5, 
#' fit6, type = "logLik", tol = 0.01)
#' 
#' summary(modComp1)
#' summary(modComp2)
#' 
#' par(mfcol = c(1,2))
#' plot(modComp1)
#' plot(modComp2)
#' 
#' # Comparing fits with covariance matrices
#' # an example for scaling a phylogenetic covariance matrix with
#' # the scaling parameter, lambda
#' 
#' data("PlethMorph")
#' Cov <- PlethMorph$PhyCov
#' lambda <- seq(0, 1, 0.1)
#' 
#' Cov1 <- scaleCov(Cov, scale. = lambda[1])
#' Cov2 <- scaleCov(Cov, scale. = lambda[2])
#' Cov3 <- scaleCov(Cov, scale. = lambda[3])
#' Cov4 <- scaleCov(Cov, scale. = lambda[4])
#' Cov5 <- scaleCov(Cov, scale. = lambda[5])
#' Cov6 <- scaleCov(Cov, scale. = lambda[6])
#' Cov7 <- scaleCov(Cov, scale. = lambda[7])
#' Cov8 <- scaleCov(Cov, scale. = lambda[8])
#' Cov9 <- scaleCov(Cov, scale. = lambda[9])
#' Cov10 <- scaleCov(Cov, scale. = lambda[10])
#' Cov11 <- scaleCov(Cov, scale. = lambda[11])
#' 
#' 
#' fit1 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov1)
#' fit2 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov2)
#' fit3 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov3)
#' fit4 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov4)
#' fit5 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov5)
#' fit6 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov6)
#' fit7 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov7)
#' fit8 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov8)
#' fit9 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov9)
#' fit10 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov10)
#' fit11 <- lm.rrpp(SVL ~ 1, data = PlethMorph, Cov = Cov11)
#' 
#' par(mfrow = c(1,1))
#' 
#' MC1 <- model.comparison(fit1, fit2, fit3, fit4, fit5, fit6,
#' fit7, fit8, fit9, fit10, fit11,
#' type = "logLik")
#' MC1
#' plot(MC1)
#' 
#' MC2 <- model.comparison(fit1, fit2, fit3, fit4, fit5, fit6,
#' fit7, fit8, fit9, fit10, fit11,
#' type = "logLik", predictor = lambda)
#' MC2
#' plot(MC2)
#' 
#' 
#' MC3 <- model.comparison(fit1, fit2, fit3, fit4, fit5, fit6,
#' fit7, fit8, fit9, fit10, fit11,
#' type = "Z", predictor = lambda)
#' MC3
#' plot(MC3)
#' }
scaleCov <- function(Cov, scale. = 1, exponent = 1, 
                     scale.diagonal = FALSE, 
                     scale.only.diagonal = FALSE) {
  
  dims <- dim(Cov)
  if(length(dims) != 2)
    stop("Cov must be a matrix", call. = FALSE)
  if(dims[1] != dims[2])
    stop("Cov must be a square matrix", call. = FALSE)
  if(length(scale.) != 1)
    stop("The scale. argument must be a single numeric value.", 
         call. = FALSE)
  if(length(exponent) != 1)
    stop("The exponent argument must be a single numeric value.", 
         call. = FALSE)
  if(!is.numeric(scale.) || !is.numeric(exponent))
    stop("Scaling parameters must be numeric.", 
         call. = FALSE)
  
  D <- diag(diag(Cov))
  C <- Cov - D
  if(scale.only.diagonal) {
    D <- scale. * D^(exponent)
  } else {
    C <- scale. * C^(exponent)
    if(scale.diagonal) D <- scale. * D^(exponent)
  }
  
  C + D
}