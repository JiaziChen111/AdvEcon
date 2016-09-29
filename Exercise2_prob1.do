/* Problem 1: the Minimum Drinking Age and Zero Tolerance laws

Tzu-Chun Kuo, "Evaluating Californian Under-Age Drunk Driving Laws:
Endogenous Policy Lags", Journal of Applied Econometrics, Vol. 27, No. 7,
2012, pp. 1100-1115.

Information on traffic mortality during 1984 and 2002 was obtained from 
the National Highway Traffic Safety Administration's Fatal Accident 
Report System (http://www.nhtsa.gov/FARS). The fatality rates were 
defined per 10,000 persons in the Californian population, including both 
alcohol and non-alcohol-related crashes. The Californian population can 
be found at 
(http://www.cdph.ca.gov/data/statistics/Documents/VSC-2005-0101.pdf).

The dependent variable for the evaluation of under-age driving laws is 
the fatality rate of people under the age of 21 and is held in a 
variable named "FR_Y". The fatality rate for people between 22 and 24 
years old was introduced as the control group and is held in a variable 
named "FR_O". This study analyzed the policy effects using both 
quarterly and monthly fatality rates. Therefore, two files are included.

The fatality rates for the two groups exhibit substantial seasonal 
variation. Therefore, a seasonal adjustment has been applied. The 
seasonal adjustment was done by using EVIEWS 3.1 Version with Census 
X-11 approach.

There are two data files. The monthly data are in tck-data-m.txt, and 
the quarterly data are in tck-data-q.txt. These are both ASCII files in 
DOS format. They are zipped in the file tck-data.zip. Unix/Linux users 
should use "unzip -a".

Tzu-Chun Kuo
tkuo [AT] veriskhealth.com*/


clear all
cd D:\Sony\Econometrics\AdvEcon
*log using Exercise2_prob1.smcl, replace
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

* Summary statistics
sum fr_y fr_o first second

* Replicate Figure 1
replace t=t+95
tsset t, format(%tq)
twoway (tsline fr_y) (tsline fr_o, lpattern(dash)), ytitle(Fatality Rate) ttitle() legend(on)

* Replicate the result in Table I
reg fr_y first second  fr_o 

* Replicate the result in Table VII
clear all
import delimited D:\Sony\Econometrics\AdvEcon\data\tck-data-m.txt
encode time, gen(t)
gen first = 0
replace first =1 if t >= 125
gen second = 0
replace second =1 if t >= 161
reg fr_y first second fr_o
