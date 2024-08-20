
 /*
 
	Collection of codes that generates beautiful tables for publication 
	 
 */

*************
** ESTOUT 
*************

** Typical regression table with Fixed Effects (FE) 
	
version 14 
ssc install estout
sysuse auto, clear

	local controls weight 
	eststo clear
	eststo model1: reg price mpg `controls' 	     i.foreign
	estadd local fe "\checkmark"
	estadd ysumm, replace
	eststo model2: reg price mpg `controls' length i.foreign 
	estadd local fe "\checkmark"
	estadd ysumm, replace
	#delimit ; 
	esttab model? using "regfe.tex", replace 
			nomtitles keep(`controls' length) 
			stats(fe ymean r2 N, label("State FE" "Mean Dep. Var." "\(R^2\)" "N" )) 
			label booktabs se noconstant star(* 0.10 ** 0.05 *** 0.01) compress ;
	#delimit cr
		
** Add subtitles grouping together regression specifications, export to Latex  
	// Credit: Sylvain Weber : https://www.stata.com/statalist/archive/2012-11/msg00925.html

	eststo clear
	eststo dom1: reg mpg weight if !foreign
	eststo dom2: reg mpg weight trunk if !foreign
	eststo for1: reg mpg weight if foreign
	eststo for2: reg mpg weight trunk if foreign
	#delimit ; 
	esttab dom1 dom2 for1 for2 using "regtitles.tex", replace 
			mgroups("Domestic" "Foreign", pattern(1 0 1 0) 
				prefix(\multicolumn{@span}{c}{) suffix(}) span 
				erepeat(\cmidrule(lr){@span}))
			label booktabs se noconstant nomtitles compress ;
	#delimit cr

	/* Note: the pattern above means that Domestic covers first two specifications, 
	and Foreign covers the last two. Essentially, the 1 indicates where the next subtitle 
	should start. 
	*/ 

********************************************************************************

*************
** TEXSAVE 
*************
	/* Syntax 
texsave [varlist] using filename [if] [in] [, title(string) size(string) width(string) align(string) location(string)
	label(string) autonumber hlines(numlist) footnote(footnote_options) varlabels landscape geometry(string)
	rowsep(string) decimalalign nonames nofix noendash preamble(stringlist) headlines(stringlist)
	headerlines(stringlist) footlines(stringlist) sw frag replace format_options]
	*/
			
version 14 
sysuse auto, clear

	collapse (mean) price mpg headroom, by(foreign)
	gen foreign_lbl 	= " Foreign" if foreign == 1
	replace foreign_lbl = " Domestic" if foreign == 0
	keep foreign_lbl price mpg headroom 
	order foreign_lbl price mpg headroom
	foreach var of varlist * {
		cap replace `var' = round(`var', 0.1)
	}
	texsave * using "table.tex", replace										///
		location("htp") width("0.6\linewidth") label("table")  					///
		title("Average by Foreign Status")    									///
		varlabels bold("Domestic") size("small") 								///
		decimalalign   /// requires adding siunitx package in preamble of .tex document 
		frag   		   // good when using as input in document  
	