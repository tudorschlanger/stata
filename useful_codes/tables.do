
 /*
 
	Collection of codes that generates beautiful tables for publication 
	 
 */


********************************************************************************
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
	