set graphics on 
capture log close 
set scrollbufsize 100000
set more 1

log using "R01_import_interviews.smcl", text replace 
set scrollbufsize 100000
set more 1

cd "C:\Users\amykr\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\CSVs nov216\output"
local import "C:\Users\amykr\Box Sync/DENV CHIKV project/Personalized Datasets/Amy/longitudinal_analysis_sept152016/"
local importnov15 "C:\Users\amykr\Box Sync/DENV CHIKV project/Coast Cleaned/HCC/HCC Latest/"

import excel "`importnov15'Msambweni HCC Initial 06Nov16.xls", sheet("#LN00014") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Msambweni HCC Initial 06Nov16", replace


import excel "`importnov15'Msambweni HCC Follow one 06Nov16.xls", sheet("#LN00015") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Msambweni HCC Follow one 06Nov16", replace



import excel "`importnov15'Msambweni HCC Follow two 06Nov16.xls", sheet("#LN00013") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Msambweni HCC Follow two 06Nov16", replace


import excel "`importnov15'Msambweni HCC Follow three 06Nov16.xls", sheet("#LN00028") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Msambweni HCC Follow three 06Nov16", replace

*west HCC
import excel "`import'HCC_1st Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_1st Followup", replace

import excel "`import'HCC_2nd Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_2nd Followup", replace

import excel "`import'HCC_3rd Followup.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_3rd Followup", replace

import excel "`import'HCC_Initial.xls", sheet("Sheet1") firstrow clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "west_HCC_Initial", replace



*AIC
insheet using "`import'Coast_AIC_Init-Katherine.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Coast_AIC_Init-Katherine", replace
insheet using "`import'FILE1   4 coast_aicfu_18apr16.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "FILE1   4 coast_aicfu_18apr16", replace
insheet using "`import'FILE2  AIC Ukunda Malaria...  .csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "FILE2  AIC Ukunda Malaria", replace
insheet using "`import'Western_AICFU-Katherine.csv", comma clear
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "Western_AICFU-Katherine", replace
insheet using "`import'Western_AIC_Init-Katherine.csv", comma clear case
foreach var of varlist _all{
	capture rename `var', lower
}
ds, has(type string) 
	foreach var of var `r(varlist)'{
	capture tostring `var', replace 
	capture  replace `var'=lower(`var')
		}	
save "West_AIC_INITIAL", replace

append using "Msambweni HCC Follow three 06Nov16" "Msambweni HCC Follow two 06Nov16" "Msambweni HCC Follow one 06Nov16" "Msambweni HCC Initial 06Nov16"  "west_HCC_1st Followup.dta" "west_HCC_2nd Followup.dta" "west_HCC_3rd Followup.dta" "west_HCC_Initial.dta"  "Coast_AIC_Init-Katherine.dta" "West_AIC_INITIAL.dta" "Western_AICFU-Katherine.dta" "FILE2  AIC Ukunda Malaria.dta" "FILE1   4 coast_aicfu_18apr16.dta" , gen(append) force

gen fevertemp =.
replace fevertemp = 1 if temperature >= 38
replace fevertemp = 0 if temperature < 38

foreach var of varlist *date*{
		capture gen double my`var'= date(`var',"DMY")
		capture format my`var' %td
		*drop `var'
}
foreach var of varlist my*{
	gen `var'_year = year(`var')
	gen `var'_month = month(`var')
	gen `var'_day = day(`var')

}
gen day = myinterviewdate_day
gen month = myinterviewdate_month
gen year = myinterviewdate_year
			replace studyid = subinstr(studyid, ".", "",.) 
			replace studyid = subinstr(studyid, "/", "",.)
			replace studyid = subinstr(studyid, " ", "",.)
			drop if studyid ==""
			
	bysort  studyid: gen dup_merged = _n 
	tab dup_merged
	list studyid if dup_merged>1
	list studyid if dup_merged>1
	tempfile merged
	save merged, replace
	*keep those that i dropped for duplicate and show to elysse
	keep if dup_merged >1	
	outsheet using "dupinterviews", comma replace
	use merged.dta, clear
	drop if dup_merged >1
	
tempfile merged
save merged, replace


*take visit out of id
						forval i = 1/3 { 
							gen id`i' = substr(studyid, `i', 1) 
						}
*gen id_wid without visit						 
	rename id1 id_city  
	rename id2 id_cohort  
	rename id3 id_visit 
	tab id_visit 
	gen id_childnumber = ""
	replace id_childnumber = substr(studyid, +4, .)
	order id_cohort id_city id_visit id_childnumber studyid
	egen id_wide = concat(id_city id_cohort id_childnum)

drop append
save temp, replace
	
	encode site, gen(siteint)
	drop site
	rename siteint site
save all_interviews, replace
