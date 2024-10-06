
************* MASTER FILE **********
clear all 
macro drop _all 
program drop _all

*** USERS MUST FIRST DEFINE PATH TO THIS DIRECTORY ****
if  "`c(username)'" == "schl"   global root "/Users/schl/Dropbox (Personal)/projects/"
*** USERS MUST FIRST DEFINE PATH TO THE OVERLEAF DIRECTORY ****
if  "`c(username)'" == "schl"   global overleaf "/Users/schl/Dropbox (Personal)/Apps/Overleaf/"

	
	************** SETTINGS ***************
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
	adopath + "$root/code/src/libraries/stata"
	adopath + "$root/code/src/programs"
	set scheme custom, perm

	** Common settings
	set more off          // window output not interrupted
	set varabbrev off     // do not allow variable abbreviations
	pause on              // for debugging purposes
	if c(os) == "MacOSX" {
		graph set window fontface "Palatino"  // set common color font Mac 
	} 
	else {
		graph set window fontface "Arial Rounded MT Bold"  // set common color font Windows
	}

	
	************** INSTALL & DEFINE THINGS ***************
	** Install all required packages locally 
	** NOTE: delete the line below in the replication package (the idea is that the current set of packages will be fixed in time)
	do "$root/code/src/install_packages.do"  

	** Set API keys 
	set fredkey "030dacac32647f169b142f30fcdab33a", permanently

	** Define colors 
	do "$root/code/src/define_colors.do"

	** Create all folders
	cap mkdir "$root/output"
	cap mkdir "$root/output/data"
	cap mkdir "$root/output/fig"
	cap mkdir "$root/output/table"
	cap mkdir "$root/raw/public"       // Public data 
	cap mkdir "$root/raw/proprietary"  // Proprietary data 

	** Add paths
	global code        "$root/code"
	global raw_pub     "$root/raw/public"			
	global raw_prop    "$root/raw/proprietary"		
	global output_data "$root/output/data/"		
	
	** Note: All figs and tables go directly to the Overleaf folder for this project
	global output_fig   "$overleaf/fig/"
	global output_table "$overleaf/table"

	
	************** RUN CODES ***************
	** Pull the vintage data (World Bank, BIS, ...)
	// do "$root/code/pull_data/master_pull.do"

	** Merge and describe your data 
	do "$code/build_raw_data.do"
	do "$code/build_analysis_data.do"
	do "$code/data_description.do"

	** Analysis


cap graph close 
quietly log close 
