/* Author: Sony Nghiem
Problem 2: Estimating the Effect of Smoking on Birth Outcomes Using a
Matched Panel Data Approach*/

clear all
cd D:\Sony\Econometrics\AdvEcon\Exercise2
log using Exercise2_prob2.smcl, replace
* I start reading the data from Excel first since it did not import properly on Stata
import delimited birpanel.csv, delimiter("", collapse) clear 

/* (A) specify the basic econometric model employed in the paper
The paper uses panel data to estimate the causual effect of maternal smoking and birth weight
on a birth outcome like birthweight.
y = X'*beta + gamma*s + epsilon
where x is a vector of explanatory variables, s is a smoking indicator variable, and epsilon is an error disturbance
*/

* (B) Provide the summary statistics
sum dbirwt gestat smoke cigar dmage dmeduc married black adeqcode2 adeqcode3 novisit pretri2 pretri3
* all summary statistics match with those reported in Table II of Abrevaya (2006) 
* except for the number of cigarettes per day
logout, save(result2) word replace: summarize
log using Exercise2_prob2.smcl, append

* (C) Replicate the results in Table III
* Here we declare the panel data
xtset momid3 idx 

* OLS (pooled OLS) for birthweight
reg dbirwt smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3
estimates store reg1
* The results are still different from the table III

* OLS (pooled) for smoking
reg smoke dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3
estimates store reg2
* the reuslts come very close like in table III, except for age and age^2
esttab reg1 reg2 using tableIII.rtf, replace

* (D) replicate the OLS and FE results given in table IV
reg dbirwt smoke male dmage agesq hsgrad somecoll collgrad married black adeqcode2 adeqcode3 novisit pretri2 pretri3
estimates store reg3
xtreg dbirwt smoke male dmage agesq adeqcode2 adeqcode3 novisit pretri2 pretri3, fe
estimates store reg4
* In both regressions, the results come quite close to the one in table IV

* (E) Random effects specification
xtreg dbirwt smoke male dmage agesq adeqcode2 adeqcode3 novisit pretri2 pretri3, re
estimates store reg5
esttab reg3 reg4 reg5 using tableIV.rtf, replace
* from the result table, all of the statistical tests are significantly rejected.

log close
