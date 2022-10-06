
************* MASTER FILE **********
clear all 
macro drop _all 
program drop _all

*** USER MUST FIRST DEFINE PATH TO THIS DIRECTORY ****
global root "C:\Users\[user]\git\princecon\stata\template_folder"
global vintage "2021-10"
******************************************************

** Check directory above exists
assert !missing("$root")  
cap cd "$root"
assert _rc==0

** Log 
cap log using "$root/master.log", replace
	if _rc != 0 { // Close and re-open log (useful when code breaks)
		quietly log close 
		log using "$root/master.log", replace
	}
	

** Some useful information 
di "Begin date and time: $S_DATE $S_TIME"
di "Stata version: `c(stata_version)'"
di "Updated as of: `c(born_date)'"
di "Variant:       `=cond( c(MP),"MP",cond(c(SE),"SE",c(flavor)) )'"
di "Processors:    `c(processors)'"
di "OS:            `c(os)' `c(osdtl)'"
di "Machine type:  `c(machine_type)'"


** Remove Stata paths except for BASE and ./libraries/stata (to revert this, restart Stata session)
tokenize `"$S_ADO"', parse(";")
while `"`1'"' != "" {
  if `"`1'"'!="BASE" cap adopath - `"`1'"' // Do not remove path to BASE
  macro shift
}
adopath ++ "$root/code/src/libraries/stata"
// adopath + "C:\Users\ts2934\ado\personal"
// set scheme custom, perm // this file exists in the C:/Users/user/ado/personal folder and NOT in the current repo 
// adopath - "C:\Users\ts2934\ado\personal"

** Common settings
set more off          // window output not interrupted
set varabbrev off     // do not allow variable abbreviations
pause on              // for debugging purposes
set trace off
set maxvar 100000

if c(os) == "MacOSX" {
	graph set window fontface "Arial Rounded MT Bold"  // set common color font Mac 
} 
else {
	graph set window fontface "Arial Rounded MT Bold"  // set common color font Windows
}

** Install all required packages locally (delete this line at the very end of the project, when preparing the replication package)
// do "$root/code/src/install_packages.do"  
do "$root/code/src/define_colors.do"

** Create base folders 
cap mkdir "$root/output/data"
cap mkdir "$root/output/fig"
cap mkdir "$root/output/table"
cap mkdir "$root/raw/proprietary"  // Only proprietary data 
cap mkdir "$root/raw/vintages"     // Public data that needs frequent updates 
cap mkdir "$root/raw/original"     // Public data that does not need updates (e.g. replication packages, large files) 


** Run all do files from here 
// do file.do


quietly log close 

