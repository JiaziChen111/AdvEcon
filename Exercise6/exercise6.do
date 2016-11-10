* Author: Sony Nghiem
* Title: Exercise 6 
* Problem 1
clear all
cd D:\Sony\Econometrics\AdvEcon\Exercise6
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

* (B) With heteroskedasticity-robust to cluster correlation within family
oprobit pctstck choice age educ female black married finc* wealth89 prftshr, nolog vce(cluster id) 

*With heteroskedasticity-robust standard errors
oprobit pctstck choice age educ female black married finc* wealth89 prftshr, nolog vce(robust) 
*(C) Obtain the estimated average marginal effects of choice on probabilities of asset allocation in defined contribution plans. Interpret the results.
margins, dydx(choice)

*(D) Estimate the marginal effect of choice on probabilities of asset allocation in defined contribution
estimates restore oprobit1
margins, dydx(choice) at (married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#1))
margins, dydx(choice) at (married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#2))
margins, dydx(choice) at (married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#3))
* (E) Expected value
predict result1, pr outcome(#1)
predict result2, pr outcome(#2)
predict result3, pr outcome(#3)
quietly summarize result1 
scalar mean1 = r(mean)
quietly summarize result2 
scalar mean2 = r(mean)
quietly summarize result3
scalar mean3 = r(mean)
* Then the mean value when choice =1
display  (mean2 * 50 + mean3 * 100)

estimates restore oprobit1
margins, dydx(choice) at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#1))
margins, dydx(choice) at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#2))
margins, dydx(choice) at (choice=0 married=0 female=1 black=1 age=60 educ=12 wealth89=150 finc50=1) predict(outcome(#3))
predict result4, pr outcome(#1)
predict result5, pr outcome(#2)
predict result6, pr outcome(#3)
quietly summarize result4 
scalar mean4 = r(mean)
quietly summarize result5 
scalar mean5 = r(mean)
quietly summarize result6
scalar mean6 = r(mean)
* Then the mean value when choice =0
display  (mean5 * 50 + mean6 * 100)

* Problem 2
infile  WAGE using vv-data.dat, clear

* Descriptive statistics
sum

*(A) Table II. Find the average marginal effects of logexper, mar, and exper
gen logexper = log(EXPER+1)
probit UNION logexper SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC* i.YEAR, nolog
estimates store probit1
margins, dydx(logexper MAR) post
estimates restore probit1
margins, expression(_b[logexper]*predict()/100) post

*(B) The random effects probit estimator
xtset NR YEAR
xtprobit UNION logexper SCHOOL MAR BLACK HISP RUR HLTH NE S NC AG MIN CON MAN TRA TRAD FIN BUS PER ENT PRO OCC* YEAR if 1981<=YEAR & YEAR<=1987, nolog

