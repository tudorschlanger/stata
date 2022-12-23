version 15 

/*

	This program checks if the first argument equals the sum of the other args 

*/


cap program drop checkequals
program define checkequals 
	syntax varlist(min=2 numeric) [, Tolerance(numlist max=1) ]
	
	* Retrieve the first and other variables 
	gettoken firstvar othervars : varlist 

	if "`tolerance'" == "" local tolerance 10^-5
	
	cap drop error 
	cap drop sumvars 
	
	egen sumvars = rowtotal(`othervars'), missing
	
	* Calculate error 
	gen error = sumvars / `firstvar' - 1   
	cap assert round(error, `tolerance') == 0 if !missing(error)
	if _rc == 0 {
		disp "The first variable equals the sum of the others (tolerance = `tolerance')"
	}
	else {
    	twoway line error year 
	    disp as error "The first variable does not equal the sum of the other variables (tolerance = `tolerance')"
		exit(999)
	}



end