version 15 

/*

	Download data from multiple sources using Stata packages 

*/



// /* [1] Download zipfiles from Web link 


	global path_raw_data "$root/raw/"

	copy "https://www.imf.org/external/datamapper/GDD/GlobalDebtDatabase.zip" "$path_raw_data/gdd.dta", replace
	cd  "$path_raw_data"
	unzipfile "$path_raw_data/gdd.dta"

	rm  "$path_raw_data/gdd.dta"
	cd  "$path_raw_data/GlobalDebtDatabase"

	* Change the name of the files within the folder 
	local myfiles: dir "$path_raw_data/GlobalDebtDatabase" files "*.dta"
	foreach file of local myfiles {
		!rename "`file'" "gdd.dta"
	}

		
*/


// /* [2] Download using the sdmxuse packages 

	ssc install  sdmxuse
	cap mkdir "$root/raw/oecd_sdmx"
	global path_data "$root/raw/oecd_sdmx/"

	* Run the following to figure out structure of the data:
	// 			sdmxuse dataflow OECD, clear
	// 			sort dataflow_description
	// 			sdmxuse datastructure OECD, clear dataset(SNA_TABLE14A)	

	* Example: SNA Table 14a for OECD countries 
		cap mkdir "$root/raw/oecd_sdmx/SNA_TABLE14A"

		import delimited "$root/raw/country.csv", clear  // one column document listing country names and their iso3c codes 
		keep if oecd == 1 
		levelsof iso3c, local(countries)

		* If the loop fails because of tmp_sdmxsdatastructure.txt errors, paste the remaining iso3c codes here and restart loop
		// 	local countries "ISL"

		timer clear

		foreach country of local countries {
			timer on 1
				* Download all the variables for all years in the SNA Table 14a
				* The "C" stands for current prices. Constant prices are also available under the code "V" 
							
				sdmxuse data OECD, clear dataset(SNA_TABLE14A) dimensions(`country'...C) mergedsd
				save "$path_data/SNA_TABLE14A/`country'", replace 

				sleep 1000 // wait one second to let the operating system be done writing out the last version of the file 

			timer off 1
			timer list 1
		}
		
		timer clear

*/


// /* [3] Download World Bank data (World Development Indicators) 
	
	ssc install wbopendata
	wbopendata, indicator(ny.gdp.mktp.cn; ny.gdp.mktp.cd; ny.gdp.mktp.pp.cd) clear long

	keep countrycode year  ///
				ny_gdp_mktp_cn 		/// GDP (current LCU)
				ny_gdp_mktp_cd 		/// GDP (current US$)
				ny_gdp_mktp_pp_cd   // GDP (current PPP US$) 
	rename countrycode iso3

*/
