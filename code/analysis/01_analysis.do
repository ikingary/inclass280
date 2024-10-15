/*=======================================


* New york City public pretrial data

This file estimates disparities in ROR
rates for white vs. Black defendants


========================================*/

clear all

* graphical parameters
set scheme plotplainblind

* set variable list macros
global controlvars = "assault burglary conspiracy crim_contempt weapon_possesion dwi drug homicide_related larceny obstruction other other_sex_offense other_vtl property strangulation unlicensed_operation male felony"

* load data
use ./data/cleandata/analysis_sample.dta, replace

/***************************

Figures 

****************************/

* generate judgeid variable
egen judgeid = group(judge_name)

* restrict to New York City
keep if county_name == "Bronx" | county_name=="Kings" | county_name == "New York" | county_name == "Queens" | county_name == "Richmond"

* drop judges with fewer than 100 observations
bys judgeid: gen obs=_N
drop if obs<100
drop obs

* drop strata with few observations
bys court_ori: gen obs=_N
drop if obs<100
drop obs 

* drop strata without multiple judges
bys court_ori: egen unique=nvals(judgeid)
drop if unique<2
drop unique

* drop judges with fewer than 20 black and 20 white cases
bys judgeid: egen count_black=total(black)
gen white = 1-black
bys judgeid: egen count_white = total(white)
drop if count_black<20 | count_white<20
drop count_black count_white

* Paper: Do judges vary in their treatment of race
areg ror i.judgeid i.judgeid#i.black, a(court_ori)

gen ror_gap = . 
gen se_ror_gap = . 

levelsof judgeid

foreach i in `r(levels)' {
	
	replace ror_gap = _b[`i'.judgeid#1.black] if judgeid == `i'
	replace se_ror = _se[`i'.judgeid#1.black] if judgeid == `i'
	
	display "Saving Coefficient for Judge `i' "
	
	
}

collapse ror_gap se_ror_gap, by(judge_name)

sum ror_gap

hist ror_gap, ///
	color(sea%40) ///
	title("New Better Title") ///
	xtitle("ROR Disparity (Black-White)") ///
	ylabel(0(2)10, nogrid) ///
	xlabel(-0.3(0.1)0.2, nogrid) ///
	xline(`r(mean)', lp(dash) lc(black)) /// 
	text(9 `r(mean)' "Average ROR Disparity", place(e))
	
gr export ./output/ror_disparity.pdf, replace 







	

	
