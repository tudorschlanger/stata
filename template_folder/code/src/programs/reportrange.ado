version 14 

/*

	Report number of observations and range of observations (minyear-maxyear)

*/

cap program drop reportrange 
	program define reportrange 
		syntax varlist(min=1 numeric) [, SPACEvar(varlist max=1) TIMEvar(varlist max=1)]
	/*
		* Arglist: List of variables, have to be numeric 
		* Space and time vars are optional. They are asumed to be called "country" and "year"
	
	*/

		if "`spacevar'" == "" local spacevar country
		if "`timevar'"  == "" local timevar year
		
		tab `spacevar'

		local min`timevar'  
		local max`timevar' 
		local nobs	
		foreach m in `varlist' {
			gen `timevar'_`m'=`timevar' if `m'!=.
			local min`timevar' `min`timevar'' min`timevar'_`m'=`timevar'_`m'
			local max`timevar' `max`timevar'' max`timevar'_`m'=`timevar'_`m'
			local nobs	`nobs'	    n_`m'=`timevar'_`m'
		}
		collapse (min) `min`timevar'' (max) `max`timevar'' (count) `nobs' , by(`spacevar')

		order `spacevar'
		reshape long n_ min`timevar'_ max`timevar'_, i(`spacevar') j(var) string
		tostring min`timevar'_ max`timevar'_, replace
		gen range_=min`timevar'_+"-"+max`timevar'_
		replace range_="" if range_==".-."
		drop min`timevar'_ max`timevar'_
		reshape wide n_ range_, i(`spacevar') j(var) string

		foreach m in `varlist' {
				replace range_`m' = "-" if missing(range_`m') // no data here 
				lab var n_`m' 	   "N"
				lab var range_`m'  "`timevar'"
				order 	range_`m' n_`m'
		}
		
		order `spacevar' 
		drop if missing(`spacevar')
	end