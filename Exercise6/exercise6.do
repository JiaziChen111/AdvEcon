* Author: Sony Nghiem
* Title: Exercise 6 
* Problem 1
clear all
set seed 1234
cd D:\Sony\Econometrics\AdvEcon\Exercise6
log using Exercise6.smcl, replace
*cd C:\sony\github\AdvEcon\Exercise6
infile id  pyears    prftshr   choice    female    married   age  educ finc25    finc35    finc50    finc75    finc100   finc101   wealth89  black stckin89  irain89   pctstck   using "pension.raw", clear 

label var id 								"family identifier"
label var pyears                            "years in pension plan"
label var prftshr                           "=1 if profit sharing plan"
label var choice                            "=1 if can choose method invest"
label var female                            "=1 if female"
label var married                           "=1 if married"
label var age                               "age in years"
label var educ                              "highest grade completed"
label var finc25                            "$15,000 < faminc92 <= $25,000"
label var finc35                            "$25,000 < faminc92 <= $35,000"
label var finc50                            "$35,000 < faminc92 <= $50,000"
label var finc75                            "$50,000 < faminc92 <= $75,000"
label var finc100                           "$75,000 < faminc92 <= $100,000"
label var finc101                           "$100,000 < faminc92"
label var wealth89                          "net worth, 1989, $1000"
label var black                             "=1 if black"
label var stckin89                          "=1 if owned stock in 1989"
label var irain89                           "=1 if had IRA in 1989"
label var pctstck                           "0=mstbnds,50=mixed,100=mststcks"

* (A)Estimate an ordered probit model for pctstk, where the explanatory variables are as identified above.
oprobit pctstck choice age educ female black married finc* wealth89 prftshr, nolog
estimates store oprobit1 
outreg2 using oprobit1_table, title(Ordered probit model for pctstk) word replace

* (B) With heteroskedasticity-robust to cluster correlation within family
oprobit pctstck choice age educ female black married finc* wealth89 prftshr, nolog vce(cluster id) 
outreg2 using oprobit1_table2, title(Ordered probit model for pctstk with heteroskedasticity-robust to cluster correlation within family) word replace

*With heteroskedasticity-robust standard errors
oprobit pctstck choice age educ female black married finc* wealth89 prftshr, nolog vce(robust) 
outreg2 using oprobit1_table3, title(Ordered probit model with heteroskedasticity-robust standard errors) word replace

*(C) Obtain the estimated average marginal effects of choice on probabilities of asset allocation in defined contribution plans. Interpret the results.
margins, dydx(choice) post

*(D) Estimate the marginal effect of choice on probabilities of asset allocation in defined contribution
estimates restore oprobit1
margins, dydx(choice) at (married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) post

* (E) Expected value
* Then the mean value when choice =1
estimates restore oprobit1
margins, at (choice=1 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#1))
margins, at (choice=1 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#2))
margins, at (choice=1 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#3))
display  .3742912 * 50 +  .2831549 * 100

* Then the mean value when choice =0
estimates restore oprobit1
margins, at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#1))
margins, at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#2))
margins, at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#3))
display    .3440748  * 50 + .1774666 * 100

* Problem 2
infile  NR YEAR AG BLACK BUS CON ENT EXPER FIN HISP HLTH HOURS MAN MAR MIN NC NE OCC1 OCC2 OCC3 OCC4 OCC5 OCC6 OCC7 OCC8 OCC9 PER PRO PUB RUR S SCHOOL TRA TRAD UNION WAGE  using vv-data.dat, clear

* Descriptive statistics
logout, save(problem2_summary) word replace: sum
log using Exercise6.smcl, append

*(A) Table II. Find the average marginal effects of logexper, mar, and exper
gen logexper = log(EXPER+1)
probit UNION logexper SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC1 OCC2 OCC3 OCC4 OCC5 OCC6 OCC7 OCC8 i.YEAR, nolog
outreg2 using pooledprobit1_table1, title(Pooled probit model) word replace
estimates store probit1
margins, dydx(logexper MAR) post
estimates restore probit1
margins, expression(_b[logexper]*predict()/100) post

*(B) The random effects probit estimator
xtset NR YEAR
xtprobit UNION logexper SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC1 OCC2 OCC3 OCC4 OCC5 OCC6 OCC7 OCC8 YEAR if 1981<=YEAR & YEAR<=1987, nolog
estimates store probit2
margins, dydx(logexper MAR) post
estimates restore probit2
margins, expression(_b[logexper]*predict()/100) post

*(C) The correlated random effects probit estimator
xtprobit UNION logexper SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC1 OCC2 OCC3 OCC4 OCC5 OCC6 OCC7 OCC8 YEAR if 1981<=YEAR & YEAR<=1987, vce(robust) nolog 
margins, dydx(logexper) post

*(D) Test for state dependence in unionism.
* create the lagged variable
by NR: gen lagged_union = UNION[_n-1] if YEAR==YEAR[_n-1]+1 

xtprobit UNION logexper lagged_union SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC1 OCC2 OCC3 OCC4 OCC5 OCC6 OCC7 OCC8 YEAR if 1981<=YEAR & YEAR<=1987, vce(robust) nolog 
* very low p-value with a highly statistical significance. There is state dependence.

log close
