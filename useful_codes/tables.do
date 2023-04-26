
 /*
 
	Collection of codes that generates beautiful tables for publication 
	 
 */

*************
** ESTOUT 
*************

** Add subtitles grouping together regression specifications, export to Latex  
	// Credit: Sylvain Weber : https://www.stata.com/statalist/archive/2012-11/msg00925.html

version 14 
ssc install estout
sysuse auto, clear
	eststo clear
	eststo dom1: reg mpg weight if !foreign
	eststo dom2: reg mpg weight trunk if !foreign
	eststo for1: reg mpg weight if foreign
	eststo for2: reg mpg weight trunk if foreign
	esttab dom1 dom2 for1 for2 using text.tex, replace label booktabs nomtitles mgroups("Domestic" "Foreign", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
	
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

foreach var of varlist * {
	cap replace `var' = round(`var', 0.1)
}

texsave * using "C:\Users\ts2934\Desktop\table.tex", ///
	replace  decimalalign varlabels location("htp") width("0.6\linewidth") ///
	label("table") ///
	title("Average by Foreign Status")
	
  