/* Author: Sony Nghiem
Problem 1: "Incentive Effects in the Demand for Health Care: 
A Bivariate Panel Count Data Estimation"*/
clear all
cd D:\Sony\Econometrics\AdvEcon\Exercise4
log using Exercise4.smcl, replace
infile id female year age hsat handdum handper hhninc hhkids educ married haupts reals fachhs abitur univ working bluec whitec self beamt docvis hospvis public addon using "D:\Sony\Econometrics\AdvEcon\Exercise4\rwm.data" 

* (A) Replicate the descriptive statistics for Hospital visits and Doctor visits reported in Table I
tab docvis if female ==0
tab docvis, sum(female) 
tab hospvis if female ==0
sum docvis if female ==0

log close
