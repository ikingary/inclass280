/*=======================================


* New york City public pretrial data

This file loads in the raw pretrial 
data from NY state and produces a 
clean analysis sample


========================================*/

clear all

* load data 
import delimited using ./data/rawdata/pretrial.csv, delim(",") varn(1)

* drop desk appearance tickets
drop if arrest_type == "DAT"

* drop disposed at arraignment 
drop if releasedecisionatarraign=="Disposed at arraign"

* generate an indicator that is equal to 1 if the individual is rearrested prior to disposition
gen ror = (releasedecisionatarraign=="ROR")

* restrict to black or white defendants
keep if race == "Black" | race == "White"

* generate an indicator that is equal to 1 if the defendant is Black
gen black = (race=="Black")
label var black "Black"

* destring some variables
replace days_arraign_to_disp="" if days_arraign_to_disp=="NULL"
destring days_arraign_to_disp, replace 
destring first_bail_set_cash, replace

* generate date-time variables
foreach var in arrest offense first_arraign {
	
	gen `var'_year = year(date(`var'_date,"MDY"))
	gen `var'_month = month(date(`var'_date,"MDY"))
	
}

* generate crime types
gen assault = arraignchargecategory=="Assault"
label var assault "Assault Indicator"

gen burglary = arraignchargecategory=="Burglary"
label var burglary "Burglary Indicator"

gen conspiracy = arraignchargecategory=="Conspiracy"
label var conspiracy "Conspiracy"

gen crim_contempt = arraignchargecategory=="Criminal Contempt"
label var crim_contempt "Criminal Contempt"

gen weapon_possesion = arraignchargecategory=="Criminal Possession of a Weapon"
label var weapon_possesion "Conspiracy"

gen dwi = arraignchargecategory=="DWI"
label var dwi "Driving While Intoxicated"

gen drug = arraignchargecategory=="Drug"
label var drug "Drug Possession"

gen endanger = arraignchargecategory=="Endagering Welfare"
label var endanger "Endagering Welfare"

gen homicide_related= arraignchargecategory=="Homicide Related"
label var homicide_related "Homicide Related"

gen larceny = arraignchargecategory=="Larceny"
label var larceny "Larceny"

gen obstruction= arraignchargecategory=="Obstruction"
label var obstruction "Obstruction"

gen other= arraignchargecategory=="Other"
label var other "Other"

gen other_sex_offense = arraignchargecategory=="Other Sex Offense"
label var other_sex_offense "Other Sex Offense"

gen other_vtl = arraignchargecategory=="Other VTL"
label var other_vtl "Other Violent Offense"

gen property = arraignchargecategory=="Property"
label var property "Property Crime"

gen rape = arraignchargecategory=="Rape"
label var rape "Rape"

gen robbery = arraignchargecategory=="Robbery"
label var robbery "Robbery"

gen strangulation = arraignchargecategory=="Strangulation"
label var strangulation "Strangulation"

gen unlicensed_operation= arraignchargecategory=="Unlicensed Operation"
label var unlicensed_operation "Unlicensed Operation"

* generate 
gen male = (gender=="Male")
label var male "Male"

* drop unnecessary variables

drop internal_case_id electronic_monitoring travel_restrictions passport_surrender no_firearms_or_weapons top_arrest_article_section top_arrest_attempt_indicator top_charge_at_arrest top_charge_severity_at_arrest top_charge_weight_at_arrest top_charge_at_arrest_violent_fel case_type top_arraign_law top_arraign_article_section top_arraign_attempt_indicator top_charge_at_arraign top_severity_at_arraign top_charge_weight_at_arraign top_charge_at_arraign_violent_fe arraignchargecategory order_of_protection non_stayed_wo num_of_stayed_wo num_of_row supervision

gen caseid = _n

order caseid

compress

save ./data/cleandata/analysis_sample.dta, replace

