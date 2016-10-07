* The panel data comes from Baltagi and Khanti-Akom (1990, Journal of Applied Econometrics) 
clear all
cd "D:\Sony\Econometrics\AdvEcon"
use panel, clear
describe
sum

* set panel data
xtset id t

* examine overall, between, and within variations
xtsum
* here I have 595 observations, 7 time periods, this is a balanced dataset

* describe the pattern of this panel data
xtdes 

tab south ind
tab south
tab ind

* Report transition probabilities (the change in one categorical variable over time)
xttrans south, freq
*For the 28.99% of the sample ever in the south,
*99.23% remained in the south the next period.

xttrans ind, freq

* time series plots of log wage for first 10 people
xtline lwage if id<=10, overlay

* First-order autocorrelation in log wage
sort id t
correlate lwage L.lwage L2.lwage L3.lwage L4.lwage L5.lwage L6.lwage 
* it's a high serial correlation, between t and t-6 is about .8033

* Pooled OLS
reg lwage exp exp2 ed wks  

* Pooled OLS with cluster-robust standard errors
reg lwage exp exp2 ed wks, vce(cluster id)
* now I have bigger standard errors, adjusted for cluster effect
* Need to use cluster-robust standard errors if use pooled OLS

* population-averaged (pooled feasible GLS) estimator with AR(1)
xtreg lwage exp exp2 ed wks, pa corr(ar 1)
xtreg lwage exp exp2 ed wks, pa corr(ar 1) vce(robust)

* Population-averaged (pooled feasible GLS) estimator with Ar(2)
xtreg lwage exp exp2 ed wks, pa corr(ar 2) vce(robust)
* check the working correlation matrix
matrix list e(R)

* here is where e(R) comes from
ereturn list

* pooled FGLS (fixed effect GLS) estimator with AR(2) error and cluster-robust se's
xtgee lwage exp exp2 wks ed, corr(ar 2) vce(robust)

* for within estimator, education (ed) is not included since it is time-constant
xtreg lwage exp exp2 wks, fe
* store the above result
est store within

* between estimator
xtreg lwage exp exp2 ed wks, be
est store between

* randome effect GLS
xtreg lwage exp exp2 ed wks, re
est store random_effect
* LM test for random effects (H.0: Var(alpha.i) =0, alpha =mu in Stata)
* or Breusch and Pagan Lagrangian multiplier test for random effects
xttest0
* for this low p-value, we can reject the null hypothesis

* Random effect GLS estimator with theta 
* note that under Hausman-Taylor test, theta (in Stata) = 1 - sigma.epsilon * sqrt(sigma.epsilon^2+T*sigma.alpha^2)
xtreg lwage exp exp2 ed wks, re theta

* Random effect GLS estimator with robust standard errors
xtreg lwage exp exp2 ed wks, re vce(robust)
* ML random effect estimator
xtreg lwage exp exp2 ed wks, mle

* First-difference, education is time-constant, so opt out
reg D.(lwage exp exp2 wks), noconstant
reg D.(lwage exp exp2 wks), noconstant vce(cluster id)

*Hausman test
hausman within random_effect, sigmamore
* reject the null, so we use the fixed effect

*regresion with year effects
global year2to7 "tdum2 tdum3 tdum4 tdum5 tdum6 tdum7"
global year3to7 "tdum3 tdum4 tdum5 tdum6 tdum7"
sum $year*

reg lwage exp exp2 ed wks $year2to7, vce(robust)
reg lwage exp exp2 ed wks $year3to7, vce(robust)
