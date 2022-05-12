
version 14 

/*

	

*/	
	
global purple  		" 68   1  84"
global green   		" 33 145 140"
global blue    		" 59  82 139"
global red     		"202   0  32"
global light_green  "115 208  85"
global yellow  		"253 231  37"
	
*** Line graph with confidence bands *** 
sysuse tsline2, clear 

	#delimit ;
	twoway rarea     ucalories lcalories 
					 day , fcolor(gs12%50) lcolor(gs12%50) lw(none) lpattern(solid) ||
		   connected calories
					 day , color("$red") lp(solid) lw(thin) m(o) 
							 yline(0, lcolor(black) lpattern(solid) lwidth(thin)) 
							 ytitle("", color(black) size(medsmall)) 
							 xtitle("", size(medsmall)) 
							 name(g1, replace)
							 graphregion(color(white)) plotregion(color(white))	
							 legend(
									order(
										   1 "Confidence interval"
										   2 "Calories"
									)
									rows(1)
						 	  region(lstyle(none)) // no legend margin
							  bmargin(zero)) // no legend margin
						  ;
							 
	graph export "fig1.png", replace
	
	
	