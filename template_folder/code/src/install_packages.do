******* 
* Originally written by : Reif Julian

* This script installs all necessary Stata packages into /libraries/stata
* To do a fresh install of all Stata packages, delete the entire /libraries/stata folder
* Note: This script should NOT be included as part of your replication materials, since these user-defined packages (or add-ons) are already available in /libraries/stata. Delete this file right before publishing the replication folder to "lock in" the libraries.
*******

* Create and define a local installation directory for the packages
cap mkdir "$root/code/src/libraries"
cap mkdir "$root/code/src/libraries/stata"
net set ado "$root/code/src/libraries/stata" // tell Stata to install any packages in this folder 


** Install SSC packages
#delimit ;
	local packages "confirmdir sdmxuse distinct wbopendata xtscc 
		valuesof labellist mdesc fs winsor2" ;
// 			local packages "winsor2" ;
#delimit cr
	
foreach p of local packages {
	local ltr = substr(`"`p'"',1,1)
	qui net from "http://fmwww.bc.edu/repec/bocode/`ltr'"
	net install `p', replace
}

** Install special packages from Github (more recent than what's on SSC)

 // FTOOLS
	 
	* Install ftools (remove program if it existed previously)
	cap ado uninstall ftools
	net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/") replace

	* Install reghdfe 6.x
	cap ado uninstall reghdfe
	net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/") replace

	* To run IV/GMM regressions with ivreghdfe, also run these lines:
	cap ado uninstall ivreg2hdfe
	cap ado uninstall ivreghdfe
	cap ssc install ivreg2 // Install ivreg2, the core package
	net install ivreghdfe, from("https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/") replace

/*
 // GTOOLS 
	 
	local github "https://raw.githubusercontent.com"
	* Gtools (may not work on Mac)
	net install gtools, from(`github'/mcaceresb/stata-gtools/master/build/) replace
