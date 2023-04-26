version 14

/*

	Compute the first and last nonmissing years of a variable. 
	Arguments:
	- space variable : e.g. country 
	- time variable : e.g. year 
	
	Note: Credit to Nick Cox for proposing parts of this code. 
	
*/

cap program drop first_last_nonmiss_year
program define first_last_nonmiss_year
	
	syntax varlist(min=1 numeric) [, SPACEvar(varlist max=1) TIMEvar(varlist max=1)]
	
	if "`spacevar'" == "" local spacevar country
	if "`timevar'"  == "" local timevar year
	
	foreach var in `varlist' {
		cap drop *missing  
		cap drop obsno
	
		sort `spacevar' `timevar', stable
		by `spacevar' : gen long obsno = _n
		by `spacevar' : gen countnonmissing = sum(!missing(`var')) if !missing(`var')
		bysort `spacevar' (countnonmissing) : gen double firstnonmissing = `var'[1]
		gsort `spacevar' -countnonmissing
		bysort `spacevar' : gen double lastnonmissing  = `var'[1]
		bysort `spacevar' : gen check_firstnonmissing = (`var' == firstnonmissing & !missing(`var'))
		bysort `spacevar' : gen check_lastnonmissing  = (`var' == lastnonmissing & !missing(`var'))
		bysort `spacevar' : gen `timevar'_firstnonmissing = `timevar' if check_firstnonmissing == 1
		bysort `spacevar' : gen `timevar'_lastnonmissing  = `timevar' if check_lastnonmissing  == 1
		
		* Compute the first and last non-missing years
		bysort `spacevar' : egen `var'_yr0 = min(`timevar'_firstnonmissing)
		bysort `spacevar' : egen `var'_yr1 = min(`timevar'_lastnonmissing)
		
		* Compute the values associated with these years 
		gen temp0 = `var' if `timevar' == `var'_yr0 
		gen temp1 = `var' if `timevar' == `var'_yr1 
		bysort `spacevar': egen `var'0 = max(temp0) 
		bysort `spacevar': egen `var'1 = max(temp1)
		drop temp0 temp1 

		drop *missing  obsno
		sort `spacevar' `timevar'
		
		local lbl: variable label `var'
		label var `var'_yr0 "First `timevar' non-missing `lbl'"
		label var `var'_yr1  "Last `timevar' non-missing `lbl'"
		label var `var'0  "First non-missing `lbl'"
		label var `var'1  "Last non-missing `lbl'"		
	}
end