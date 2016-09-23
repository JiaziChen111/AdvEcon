/* This .do portrays the difference-in-difference method on the example 6.5 in 
Woolridge (2010): examine the effect of the policy change on the lengh of time (in weeks)
that an injured worker receives compensation.
*/

clear all
cd D:\Sony\Econometrics\AdvEcon
log using DID.smcl, replace
use D:\Sony\Econometrics\AdvEcon\data\injury.dta
* the data are for Kentucky and Michigan, here I will work on Michigan

describe
sum

* summary stats for Michigan
sum if mi==1 
* so there are about 1,524 observations

* summary stats for duration and log(duration) for treatment and control groups
* here treatment group includes high income workers
* control group includes low income workers
* since I want to test if more compensation makes people to stay out of work longer, all else fixed
* and also I have before and after-change time periods: afchnge
bysort highearn afchnge: sum durat ldurat if mi==1

* linear regression using DID framework
reg ldurat afchnge highearn afhigh if mi==1
*outreg2 using table1, title(Table 1. DID) ctitle(Spec 1) bdec(4) word label replace 

*So the average length of time on workers' compensation on high earners increased by about 
* 19.2% due to the increased earnings cap (the coefficient of the interaction term).
* but here p-value is so big, so it's not significant

* let's include additional controls (male, married,..)
reg ldurat afchnge highearn afhigh male married occdis manuf construc head neck upextr trunk lowback lowextr if mi==1
*outreg2 using table1, ctitle(Spec 2) bdec(4) word label append 

* now I get .1426902 * 100% = 14.26% increase in the average length of time on workers' compensation for high
* earners due to the increased earnings, but p-value is not that small
* so I can assume that this increase is not that significant or
* there would be no effect of the policy at all.

log close
