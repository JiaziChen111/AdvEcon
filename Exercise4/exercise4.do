/* Author: Sony Nghiem
Problem 1: "Incentive Effects in the Demand for Health Care: 
A Bivariate Panel Count Data Estimation"*/
clear all
cd D:\Sony\Econometrics\AdvEcon\Exercise4
log using Exercise4.smcl, replace
infile id female year age hsat handdum handper hhninc hhkids educ married haupts reals fachhs abitur univ working bluec whitec self beamt docvis hospvis public addon using "D:\Sony\Econometrics\AdvEcon\Exercise4\rwm.data" 

label var id "person - identification number"
label var female "female = 1; male = 0"
label var year "calendar year of the observation"
label var age	     "age in years"
label var hsat	     "health satisfaction, coded 0 (low) - 10 (high)"
label var handdum	     "handicapped = 1; otherwise = 0"
label var handper	     "degree of handicap in percent (0 - 100)"
label var hhninc	     "household nominal monthly net income in German marks / 1000"
label var hhkids	     "children under age 16 in the household = 1; otherwise = 0"
label var educ	     "years of schooling"
label var married	     "married = 1; otherwise = 0"
label var haupts	     "highest schooling degree is Hauptschul degree = 1; otherwise = 0"
label var reals	     "highest schooling degree is Realschul degree = 1; otherwise = 0"
label var fachhs	     "highest schooling degree is Polytechnical degree = 1; otherwise = 0"
label var abitur	     "highest schooling degree is Abitur = 1; otherwise = 0"
label var univ	     "highest schooling degree is university degree = 1; otherwise = 0"
label var working	     "employed = 1; otherwise = 0"
label var bluec	     "blue collar employee = 1; otherwise = 0"
label var whitec	     "white collar employee = 1; otherwise = 0"
label var self	     "self employed = 1; otherwise = 0"
label var beamt	     "civil servant = 1; otherwise = 0"
label var docvis	     "number of doctor visits in last three months"
label var hospvis	     "number of hospital visits in last calendar year"
label var public	     "insured in public health insurance = 1; otherwise = 0"
label var addon	     "insured by add-on insurance = 1; otherswise = 0"

save data, replace
use data, clear

*(A) Replicate the descriptive statistics for Hospital visits and Doctor visits reported in Table I
sum docvis hospvis if female
sum docvis hospvis if !female

tab docvis if female
tab docvis if !female
tab hospvis if female
tab hospvis if !female


*(B) Obtain the means and standard deviations for the list of variables given in Table II
* First, I am going to create dummy variables for years 1985, 1986, 1987, 1988, 1991, 1994
gen y1985 = (year==1985)
gen y1986 = (year==1986)
gen y1987 = (year==1987)
gen y1988 = (year==1988)
gen y1991 = (year==1991)
gen y1994 = (year==1994)

logout, save(table2) word replace: by female, sort: summarize docvis hospvis age hsat handdum handper married educ hhninc hhkids self public addon y1985 y1986 y1987 y1988 y1991 y1994
log using Exercise4.smcl, append

*(C) Obtain the mean health care utilization by selected characteristics given in Table I
* There exists non-integer values of handdum. I decide to drop those.
drop if handdum!=0 & handdum!=1

* New dummy age variables for some certain intervals of age
gen age25_35 = (25<=age) & (age<35)
gen age35_45 = (35<=age) & (age<45)
gen age45_55 = (45<=age) & (age<55)
gen age55_65 = (55<=age) & (age<65)

* New dummy income variables for some certain intervals of age
gen inc2400 = hhninc<2400
gen inc2400_3200 = 2400<=hhninc & hhninc<3200
gen inc3200_4300 = 3200<=hhninc & hhninc<4300
gen inc4300 = 4300<=hhninc


by female, sort: tabulate public, sum(docvis)
by female, sort: tab addon, sum(docvis)
by female, sort: tab handdum, sum(docvis)
by female, sort: tab self, sum(docvis)
by female, sort: tab married, sum(docvis)
by female, sort: tab hhkids, sum(docvis)
by female, sort: tab age25_35, sum(docvis)
by female, sort: tab age35_45, sum(docvis)
by female, sort: tab age45_55, sum(docvis)
by female, sort: tab age55_65, sum(docvis)
by female, sort: tab inc2400, sum(docvis)
by female, sort: tab inc2400_3200, sum(docvis)
by female, sort: tab inc2400_3200, sum(docvis)
by female, sort: tab inc3200_4300, sum(docvis)
by female, sort: tab inc4300, sum(docvis)

by female, sort: tabulate public, sum(hospvis)
by female, sort: tab addon, sum(hospvis)
by female, sort: tab handdum, sum(hospvis)
by female, sort: tab self, sum(hospvis)
by female, sort: tab married, sum(hospvis)
by female, sort: tab hhkids, sum(hospvis)
by female, sort: tab age25_35, sum(hospvis)
by female, sort: tab age35_45, sum(hospvis)
by female, sort: tab age45_55, sum(hospvis)
by female, sort: tab age55_65, sum(hospvis)
by female, sort: tab inc2400, sum(hospvis)
by female, sort: tab inc2400_3200, sum(hospvis)
by female, sort: tab inc2400_3200, sum(hospvis)
by female, sort: tab inc3200_4300, sum(hospvis)
by female, sort: tab inc4300, sum(hospvis)

* (D) estimate a pooled Poisson regression model for Doctor visits by gender 
poisson docvis i.year c.age c.age#c.age hsat handdum handper married educ hhninc hhkids self beamt bluec working public addon if !female
estimates store poisson1male
outreg2 using tableIVa_male, title(Pooled Poisson regression male - no robust) word replace

poisson docvis i.year c.age c.age#c.age hsat handdum handper married educ hhninc hhkids self beamt bluec working public addon if female
estimates store poisson1female
outreg2 using tableIVa_female, title(Pooled Poisson regression for female- no robust) word replace

* (E) Find AME for the regression above
estimates restore poisson1male
margins, dydx(*) post
outreg2 using tableIVaAME_male, title(Marginal Effects for male) word replace

estimates restore poisson1female
margins, dydx(*) post
outreg2 using tableIVaAME_female, title(Marginal Effects for female) word replace

* (F) Re-estimate using the heteroskedasticity-robust standard errors.
poisson docvis i.year c.age c.age#c.age hsat handdum handper married educ hhninc hhkids self beamt bluec working public addon if !female,vce(robust)
estimates store poisson2male
outreg2 using tableIVb_male, title(Pooled Poisson regression for male - with robust) word replace

poisson docvis i.year c.age c.age#c.age hsat handdum handper married educ hhninc hhkids self beamt bluec working public addon if !female,vce(robust)
estimates store poisson2female
outreg2 using tableIVb_female, title(Pooled Poisson regression for female- with robust) word replace

* (G) Esimate the AMEs
estimates restore poisson2male
margins, dydx(*) post
outreg2 using tableIVbAME_male, title(Marginal Effects for male with robust) word replace

estimates restore poisson2female
margins, dydx(*) post
outreg2 using tableIVbAME_female, title(Marginal Effects for female with robust) word replace

log close
