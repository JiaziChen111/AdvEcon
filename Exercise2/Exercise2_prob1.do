/* Author: Sony Nghiem
Problem 1: the Minimum Drinking Age and Zero Tolerance laws*/
clear all
cd D:\Sony\Econometrics\AdvEcon\Exercise2
log using Exercise2_prob1.smcl, replace
import delimited tck-data-q.txt

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
logout, save(result1) word replace: summarize
log using Exercise2_prob1.smcl, append

* (B) Replicate Figure 1
replace t=t+95
tsset t, format(%tq)
twoway (tsline fr_y) (tsline fr_o, lpattern(dash)), ytitle(Fatality Rate) ttitle() legend(on)

* (C) Replicate the result in Table I
reg fr_y first second  fr_o
outreg2 using table1, title(Table I) bdec(4) word  replace 
* The policy effects are not statistically significant
nlcom (_b[first]/_b[_cons]) (_b[second]/(_b[_cons]+_b[first])), post
outreg2 using table1_post, title(Table1 - post estimation) bdec(4) word  replace 

* (D) Replicate the result in Table VII
clear all
import delimited tck-data-m.txt
encode time, gen(t)
gen first = 0
replace first =1 if t >= 125
gen second = 0
replace second =1 if t >= 161
reg fr_y first second fr_o
* The policy effects are significant now.
outreg2 using tableVII, title (TableVII) bdec(4) word replace

log close
