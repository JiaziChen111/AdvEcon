/* Author: Sony Nghiem
Problem 1: the Minimum Drinking Age and Zero Tolerance laws
Tzu-Chun Kuo, "Evaluating Californian Under-Age Drunk Driving Laws:
Endogenous Policy Lags", Journal of Applied Econometrics, Vol. 27, No. 7,
2012, pp. 1100-1115.
*/
clear all
cd D:\Sony\Econometrics\AdvEcon
log using Exercise2_prob1.smcl, replace
import delimited D:\Sony\Econometrics\AdvEcon\data\tck-data-q.txt

encode time, gen(t)

gen first = 0
replace first =1 if t > 41
gen second = 0
replace second =1 if t > 54

label var fr_y "Treatment Group"
label var fr_o "Control Group"
label var first "the first post-program dummy variable"
label var second "the second post-program dummy variable"

* (A) Summary statistics
sum fr_y fr_o first second

* (B) Replicate Figure 1
replace t=t+95
tsset t, format(%tq)
twoway (tsline fr_y) (tsline fr_o, lpattern(dash)), ytitle(Fatality Rate) ttitle() legend(on)

* (C) Replicate the result in Table I
reg fr_y first second  fr_o 
* The policy effects are not statistically significant

* (D) Replicate the result in Table VII
clear all
import delimited D:\Sony\Econometrics\AdvEcon\data\tck-data-m.txt
encode time, gen(t)
gen first = 0
replace first =1 if t >= 125
gen second = 0
replace second =1 if t >= 161
reg fr_y first second fr_o
* The policy effects are significant

log close
