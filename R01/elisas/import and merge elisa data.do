/********************************************************************
 *amy krystosik                  							  		*
 *import and merge and clean elisa data 							*
 *lebeaud lab               				        		  		*
 *last updated march 21, 2017  							  			*
 ********************************************************************/ 
 
local output "C:\Users\amykr\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\elisas\march 21 2017\"
local input "C:\Users\amykr\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\elisas\march 21 2017"
local westxls "Western (Chulaimbo, Kisumu) AIC ELISA. Common sheet..xlsx"
local coastxls "COAST ELISA DATABASE.xls.xlsx"

cd "`output'"
capture log close 
log using "`output'elisa_import_merge_clean.smcl", text replace 
set scrollbufsize 100000
set more 1


*open and save files locally 
import excel "`coastxls'", sheet("Ukunda AIC") cellrange(A9:AZ1519) firstrow clear 
	save "`output'ukunda_aic", replace
import excel "`coastxls'", sheet("NGANJA HCC") cellrange(A8:BL319) firstrow clear
	save "`output'nganja_hcc", replace
import excel "`coastxls'", sheet("Msambweni  AIC") cellrange(A9:BG1488) firstrow clear
	save "`output'msambweni_aic", replace
import excel "`coastxls'", sheet("MILALANI HCC") cellrange(A8:BL589) firstrow clear
	save "`output'milalani_hcc", replace
import excel "`westxls'", sheet("KISUMU HCC") cellrange(A8:BJ829) firstrow clear
	save "`output'kisumu_hcc", replace
import excel "`westxls'", sheet("CHULAIMBO AIC") cellrange(A9:CP648) firstrow clear
	save "`output'chulaimbo_aic" , replace
import excel "`westxls'", sheet("CHULAIMBO HCC") cellrange(A8:BQ644) firstrow clear
	save "`output'chulaimbo_hcc", replace
import excel "`westxls'", sheet("KISUMU AIC") cellrange(A9:CF832) firstrow clear
	save "`output'kisuma_aic", replace
import excel "`coastxls'", sheet("Ukunda HCC") cellrange(A8:BI1128) firstrow clear
	save "`output'ukunda_hcc", replace

cd "`input'"
*import csv's
use "`output'chulaimbo_aic", clear
	dropmiss, force obs
	dropmiss, force 
	rename *, lower
	rename stford* stanford*
	gen dataset = "chulaimbo_aic" 
save "`output'chulaimbo_aic" , replace

use "`output'chulaimbo_hcc", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "chulaimbo_hcc"
save "`output'chulaimbo_hcc", replace

use "`output'kisuma_aic", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "kisuma_aic"
save "`output'kisuma_aic", replace

use "`output'kisumu_hcc", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "kisumu_hcc"
save "`output'kisumu_hcc", replace

use "`output'milalani_hcc", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "milalani_hcc"
save "`output'milalani_hcc", replace

use "`output'msambweni_aic", clear
	dropmiss, force obs
	dropmiss, force 
	egen ChikVIgGOD_db = concat(ChikVIgGOD_d  AK)
	drop ChikVIgGOD_d  AK
	rename ChikVIgGOD_db ChikVIgGOD_d 
	gen dataset = "msambweni_aic"
save "`output'msambweni_aic", replace

use "`output'nganja_hcc", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "nganja_hcc"
save "`output'nganja_hcc", replace

use "`output'ukunda_aic", clear
	use "`output'ukunda_aic", clear
	dropmiss, force obs
	dropmiss, force 
	gen dataset = "ukunda_aic"
save "`output'ukunda_aic", replace

use "`output'ukunda_hcc", clear
	dropmiss, force 
	dropmiss, force obs
	gen dataset = "ukunda_hcc"
	rename *, lower
	rename stanfordchikigg_a stanfordchikvigg_a 
save "`output'ukunda_hcc", replace
clear

cd "`output'"
foreach dataset in "kisumu_hcc.dta"  "kisuma_aic.dta" "chulaimbo_aic.dta" "msambweni_aic.dta" "nganja_hcc.dta" "chulaimbo_hcc.dta" "milalani_hcc.dta" "ukunda_aic.dta" "ukunda_hcc.dta" {
			use `dataset', clear
			*use kisumu_hcc, clear
			rename *, lower
			dropmiss, force obs
			dropmiss, force 
			capture drop villhouse_a
			capture destring personid_a, replace
			
capture tostring stanforddenvod_*, replace force
capture  tostring chikviggod_*, replace force

			capture replace datesamplecollected_a ="." if datesamplecollected_a=="n/a"
			capture destring datesamplecollected_a, replace
			capture recast int datesamplecollected_a
			
			foreach var in chikviggod_a denviggod_a stanfordchikvod_a stanforddenvod_a chikviggod_b denviggod_b stanfordchikvod_b stanforddenvod_b chikviggod_c denviggod_c chikviggod_d denviggod_d{			
					capture gen `var' = .
					gen value_igg`var' = `var'
					tostring value_igg`var', replace force
					replace value_igg`var' =itrim(trim(value_igg`var'))
					replace value_igg`var' = lower(value_igg`var')
					replace value_igg`var' = subinstr(value_igg`var', "pos", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "neg", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "rpt", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "no sample", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "no serum", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "pending", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "not followed", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "not enough serum", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "refused", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "no aic serum", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "-", "", .)
					replace value_igg`var' = subinstr(value_igg`var', " ", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "_", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "retest", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "repeat", "", .)
					replace value_igg`var' = subinstr(value_igg`var', "equivocal", "", .)					 
					destring value_igg`var', replace force
					}			 
			
             
						foreach var in  denviggod_b  denvigg_f  studyid_a denviggod_b chikviggod_a  chikviggod_a denviggod_a denviggod_a  denviggod_b chikviggod_b chikviggod_c denviggod_c denviggod_e denviggod_f stanfordchikvod_d stanfordchikvod_d n datesamplecollected stanforddenvod_a p s u w ab stanforddenvigg_f stanfordchikvod_a  stanfordchikvod_b  chikvigg_e  denvigg_e followupaliquotid_f  antigenused_d chikvigg_d  chikviggod_d chikvigg_f chikviggod_f stanfordchikvigg_d  stanforddenvigg_d antigenused_e initialaliquotid_e chikvpcr_e stanforddenvod_b{
						capture tostring `var', replace 						
						}

			foreach var in chikviggod_a denviggod_b {
			capture drop `var'
			}
			
				foreach var in datesamplecollected_a datesamplecollected_f datesamplecollected_b datesamplerun_a datesamplecollected_{
					capture gen `var'1 = date(`var', "mdy" ,2050)
					capture  format %td `var'1 
					capture drop `var'
					capture rename `var'1 `var'
					capture recast int `var'
						capture drop denviggod_a 
				}

					ds, has(type string) 
							foreach v of varlist `r(varlist)' { 
							replace `v' = lower(`v') 
							} 

capture rename stanfordchikigg_a stanfordchikvigg_a
capture rename stanfordchikviggresult_a stanfordchikvigg_a
capture rename stanfordchikviggresult_b stanfordchikvigg_b
capture rename stforddenvigg_a stanforddenvigg_a
capture rename stfrddenvigg_b stanforddenvigg_b
capture rename igg_kenya_denv denvigg_ 
capture rename chikviggresult_a  chikvigg_a 
capture rename igg_kenya_chikv chikvigg_ 


 capture rename stanforddenvreading_* stanforddenvigg_* 
 lookfor chikviggod_ denviggod_
  foreach visit in a b c d e f g h i{
	 capture egen chikvigg_od`visit' = concat(chikvigg_`visit' chikviggod_`visit')
	 capture drop chikvigg_`visit' chikviggod_`visit'
	 capture rename chikvigg_od`visit' chikvigg_`visit'   
 }
 
 foreach visit in a b c d e f g h i{
	 capture egen denvigg_od`visit' = concat(denvigg_`visit' denviggod_`visit')
	 capture drop denvigg_`visit' denviggod_`visit'
	 capture rename denvigg_od`visit' denvigg_`visit'   
 }

 capture rename igg_kenya_chikv* chikvigg_*  
 capture rename igg_kenya_denv* denvigg_* 
 capture rename kenyachikvreading_a chikvigg_a  
 capture rename kenyadenvreading_a denvigg_a 
							
save `dataset', replace
}


use "kisumu_hcc.dta", clear
append using "kisuma_aic.dta" "chulaimbo_aic.dta" "msambweni_aic.dta" "nganja_hcc.dta" "chulaimbo_hcc.dta" "milalani_hcc.dta" "ukunda_aic.dta" "ukunda_hcc.dta" 
save temp, replace
dropmiss, force obs

save "appended_$S_DATE", replace

save temp, replace
	use temp, clear
	preserve
		tostring *, replace force
		gen pos = 0
		gen neg = 0
			ds, has(type string) 
				foreach var of varlist `r(varlist)' { 
					count if strpos(`var', "pos")
						replace pos = pos + r(N)
						sum `var'

					count if strpos(`var', "neg")
						replace neg = neg + r(N)
						sum  `var'
				}
			*36387  neg and 6792  pos
restore
sort studyid_a
use "appended_$S_DATE", clear
foreach visit in a b c d e f g h i j{
	capture replace studyid_a = studyid_`visit' if studyid_a ==""
}					

				replace studyid_a =lower(studyid_a)
				replace studyid_a= subinstr(studyid_a, ".", "",.) 
				replace studyid_a= subinstr(studyid_a, "/", "",.)
				replace studyid_a= subinstr(studyid_a, " ", "",.)
				count if studyid_a==""

*make sure this doesn't create duplicates. also make the same changes to the demographic data.
				list studyid_a dataset if strpos(studyid_a, "cmb") 
				replace studyid_a= subinstr(studyid_a, "cmb", "cf",.) 
		
duplicates tag studyid_a , gen(dup_studyida)
tab dup_studyida
preserve
	*keep those that i dropped for duplicate and show to elysse
		count if studyid_a==""
		duplicates report studyid_a 
		duplicates list studyid_a 
		tab dup_studyida, nolab
		keep if dup_studyida> 0
		outsheet studyid_a dup_studyida using dup_studyida.csv, replace comma names
restore
		drop if  dup_studyida>0
save merged, replace
isid studyid_a
*take visit out of id
						forval i = 1/3 { 
							gen id`i' = substr(studyid_a, `i', 1) 
						}
*gen id_wid without visit						 
	rename id1 id_city 
	rename id2 id_cohort  
	rename id3 id_visit 
	gen city = id_city  
	gen id_childnumber  = ""
	replace id_childnumber  = substr(studyid_a, +4, .)
gen byte notnumeric = real(id_childnumber)==.	/*makes indicator for obs w/o numeric values*/
tab notnumeric	/*==1 where nonnumeric characters*/
list dataset studyid_a id_childnumber if notnumeric==1	/*will show which have nonnumeric*/

gen suffix = "" 	
local suffix a 
foreach suffix in a b c d e f g h {
	replace suffix = "`suffix'" if strpos(id_childnumber, "`suffix'")
	replace id_childnumber = subinstr(id_childnumber, "`suffix'","", .)
	}
destring id_childnumber, replace 	 
tostring id_childnumber, replace
egen id_childnumber2 = concat(id_childnumber suffix)
drop id_childnumber
rename id_childnumber2 id_childnumber
	order id_cohort city id_visit id_childnumber studyid_a
	egen id_wide = concat(city id_cohort id_childnum)
drop suffix
drop if id_visit =="?"

duplicates tag id_wide id_visit, gen(id_wide_id_visit_dup)
outsheet id_wide_id_visit_dup studyid_a id_wide id_visit using "C:\Users\amykr\Box Sync\Amy Krystosik's Files\duplicates dropped\elisa_wide_id_visit_dup.csv" if id_wide_id_visit_dup>0, comma names replace
drop if id_wide_id_visit_dup>0
isid id_city id_cohort  id_childnumber id_visit 
isid id_wide id_visit

ds, has(type string) 
foreach v of varlist `r(varlist)' { 
	replace `v' = lower(`v') 
} 
save wide, replace

duplicates tag id_wide id_visit, gen (dup_id_wide_visit_int) 
tab dup_id_wide_visit_int 
outsheet using "C:\Users\amykr\Box Sync\Amy Krystosik's Files\duplicates dropped\elisa_dup_id_wide_visit_int.csv" if dup_id_wide_visit_int>0, comma names replace 
drop if dup_id_wide_visit_int > 0
isid id_wide id_visit

duplicates tag id_wide, gen (dup_id_wide) 
tab dup_id_wide
outsheet using "C:\Users\amykr\Box Sync\Amy Krystosik's Files\duplicates dropped\elisa_dup_id_wide.csv" if dup_id_wide_visit_int>0, comma names replace 
drop if dup_id_wide > 0
isid id_wide 


	dropmiss, force
	dropmiss, force obs
foreach var in chikviggod_* stanfordchikvod_a  stanforddenvigg_f   stanforddenviggod_c antigenused_e  {
tostring `var', replace 
}
tostring chikviggod_* , replace force
	dropmiss, force
	dropmiss, force obs
	
	capture tostring stanforddenviggod_e , replace
	capture tostring chikviggod_e, replace
capture tostring stanforddenviggod_f , replace force

isid id_wide
duplicates tag id_wide, gen(id_wide_visit)
outsheet using "C:\Users\amykr\Box Sync\Amy Krystosik's Files\duplicates dropped\elisa_dup_id_wide.csv" if id_wide_visit>0, comma names replace 
drop if id_wide_visit>0
tab id_wide_visit
isid studyid_a

replace antigenused_d = antigenused_b_d if antigenused_d ==""
drop antigenused_b_d 
 
reshape long  value_iggchikviggod_ value_iggdenviggod_ value_iggstanfordchikvod_ value_iggstanforddenvod_ stanfordchikvigg2_ chikvigg_ denvigg_  stanforddenvigg_  datesamplecollected_ datesamplerun_ studyid_ followupaquotid_ chikviggod_ denviggod_ stanfordchikvod_  stanfordchikvigg_ stanforddenvod_ aliquotid_  chikvpcr_ chikvigm_ denvpcr_ denvigm_ stanforddenviggod_ followupid_ antigenused_  initialaliquotid_ correctsampleid_ duplicateid_ followupaliquotid_ stanfordchikvod2_ stanfordchikod_,  i(id_wide) j(VISIT) string

foreach var in value_iggchikviggod_ value_iggdenviggod_ value_iggstanfordchikvod_ value_iggstanforddenvod_ {
	replace `var' = `var'/10 if `var' >10
	replace `var' = `var'/10 if `var' >10
}

encode id_wide, gen(id_wide_int)
drop id_visit id_wide_visit
rename VISIT visit
encode visit, gen(visit_int)
xtset id_wide_int visit_int
by id_wide_int : carryforward id_childnumber id_cohort id_city city, replace
isid id_wide_int visit_int

egen stanfordchikvigg_all = concat(stanfordchikvigg2_ stanfordchikvigg_ stanfordchikvod_ )
drop stanfordchikvigg2_  stanfordchikvigg_
rename stanfordchikvigg_all stanfordchikvigg_
order stanfordchikvigg_
outsheet using stanfordchikvigg_discordat.xls if strpos(stanfordchikvigg_, "negpos")| strpos(stanfordchikvigg_, "posneg") , replace

order  chikvigg_ denvigg_ stanforddenvigg_ chikviggod_ denviggod_ stanfordchikvigg_ stanforddenviggod_ 
 
egen chikvigg_all = concat(chikviggod_ chikvigg_ )
drop chikviggod_ chikvigg_ 
rename chikvigg_all chikvigg_ 

egen stanforddenviggall = concat(stanforddenvigg_ stanforddenviggod_ stanforddenvod_ )
drop stanforddenvigg_ stanforddenviggod_ stanforddenvod_ 
rename stanforddenviggall stanforddenvigg_ 

egen denviggall = concat(denvigg_ denviggod_)
drop denvigg_ denviggod_
rename denviggall  denvigg_ 
order denvigg_ 


	foreach var in stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_ {
	gen `var'b=.
	tostring `var', replace force
	replace `var'b =  0 if strpos(`var', "neg")
	replace `var'b =  1 if strpos(`var', "pos")
	destring `var', replace
	drop `var'
	rename `var'b `var'
}
order stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_ 
sum stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_ 
	tempfile long
	save long, replace
	
use long.dta, clear
count if id_wide==""
capture drop _merge

*clean var city
replace city ="c" if city =="r" 
replace city ="c" if city =="h" 

	   					replace city  = "Chulaimbo" if city == "c"
						replace city  = "Msambweni" if city == "m"
						replace city  = "Kisumu" if city == "k"
						replace city  = "Ukunda" if city == "u"
						replace city  = "Milani" if city == "l"
						replace city  = "Nganja" if city == "g"
					gen site= "." 
						replace site= "coast" if city =="Msambweni"|city =="Ukunda"|city =="Milani"|city =="Nganja"
						replace site= "west" if city =="Chulaimbo"|city =="Kisumu"
					
					replace city = "" if city =="?"

*clean results

ds, has(type string)
	foreach var of var `r(varlist)'{
		replace `var' =trim(itrim(lower(`var')))
		rename `var', lower
	}	
	
/*
		foreach var of varlist stanford* *igm* *igg* { 
			tostring `var', replace
			replace `var' =trim(itrim(lower(`var')))
			gen `var'_result =""
			replace `var'_result = "neg" if strpos(`var', "neg")
			replace `var'_result = "pos" if strpos(`var', "pos") 
			drop `var'
			rename `var'_result `var'
			tab `var'
		}
*/		
rename visit VISIT 
save pcr, replace
drop *pcr*
dropmiss, force obs
dropmiss, force
isid id_wide_int visit_int

		ds, has(type string) 
			foreach v of varlist `r(varlist)' { 
				replace `v' = lower(`v') 
			}
		rename VISIT visit		
destring id_childnumber  , replace

replace antigenused_  = antigenused if antigenused_  =="" 
egen antigenused2  = concat(antigenused antigenused_) if antigenused_  !="" |antigenused_  =="."  & antigenused !="" | antigenused =="."
gen and = " & "
replace antigenused_  = antigenused2  if antigenused2  =="" 
drop antigenused2   antigenused

format %td datesamplecollected_
gen sampleyear=year( datesamplecollected_)


save elisas, replace

		gen prevalentchikv = .
		gen prevalentdenv = .
		

		replace prevalentdenv = 1 if  stanforddenvigg_==1 & visit =="a"
		replace prevalentchikv = 1 if  stanfordchikvigg_==1 & visit =="a"
		gen cohort = id_cohort
		replace cohort= "HCC" if id_cohort == "c"|cohort== "d"
		replace cohort= "AIC" if cohort== "f"|cohort== "m" 
				
		encode cohort, gen(cohort_s)
		drop cohort
		rename cohort_s cohort				
		bysort cohort  city: sum stanforddenvigg_ stanfordchikvigg_ 

		replace city = "Chulaimbo" if city =="c"
		replace city = "Kisumu" if city =="u"
		replace city = "Ukunda" if city =="k"

		save prevalent, replace
isid id_wide_int visit_int

preserve 
	keep if id_cohort =="HCC"
	save prevalent_hcc, replace
restore


*chikv matched prevalence
	use prevalent, clear
		ds, has(type string) 
			foreach v of varlist `r(varlist)' { 
				replace `v' = lower(`v') 
			}

		keep if visit == "a" & stanfordchikvigg_ !=. 
		save visit_a_chikv, replace
	use prevalent, clear
		keep if visit == "b" & stanfordchikvigg_ !=.
		save visit_b_chikv, replace
		merge 1:1 id_wide using visit_a_chikv
		rename _merge abvisit
		keep abvisit visit id_wide
		merge 1:1 id_wide visit using prevalent
		keep if abvisit ==3 & stanfordchikvigg_ !=.
		keep value* studyid  id_wide site visit visit_int antigenused_ id_city city stanforddenvigg_ stanfordchikvigg_  cohort id_cohort datesamplecollected_ datesamplecol~_ *od*
		export excel using "prevalent_visitab_chikv", firstrow(variables) replace
	
	*denv matched prevalence
	use prevalent, clear
		keep if visit == "a" & stanforddenvigg_ !=.
		save visit_a_denv, replace
	use prevalent, clear
		keep if visit == "b" & stanforddenvigg_ !=.
		save visit_b_denv, replace

		merge 1:1 id_wide using visit_a_denv
		rename _merge abvisit
		keep abvisit id_wide visit
		
		merge 1:1 id_wide visit using prevalent		
		keep if abvisit ==3 & stanforddenvigg_ !=.
		keep value* visit_int  id_cohort id_city studyid  id_wide site visit antigenused_ city cohort  datesamplecollected_   stanforddenvigg_ stanfordchikvigg_  visit datesamplecol~_
		export excel using "prevalent_visitab_denv", firstrow(variables) replace
		
		*denv prevlanece
use prevalent, clear		
foreach var in stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_ {
	preserve
		keep if `var'!=. 
		rename `var' `var'march2017
		order `var'march2017
		tab `var'march2017
		save "C:\Users\amykr\Box Sync\DENV CHIKV project\Personalized Datasets\Amy\elisas\compare july 16 and marhc 17\prevalent`var'march2017", replace
	restore
}		

replace city = "msambweni" if city =="milani"
replace city = "msambweni" if city =="nganja"

save  prevalent, replace

keep value* id_city id_cohort visit_int studyid id_wide visit city cohort site stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_ datesamplecollected_   antigenused_ 
keep if stanforddenvigg_	!= .|stanfordchikvigg_	!= .|chikvigg_	!= .|denvigg_!= .
encode city, gen(city_int)

by city, sort : ci stanforddenvigg_, binomial 
by city, sort : ci stanfordchikvigg_, binomial 


by cohort, sort : ci stanforddenvigg_, binomial 
by cohort, sort : ci stanfordchikvigg_, binomial 

bysort id_wide: carryforward id_wide, gen(id_wide2)

cd "`input'"
duplicates tag id_wide visit_int, gen(dups)
isid id_wide visit_int
compare  visit_int visit
rename visit id_visit 
save "C:\Users\amykr\Box Sync\DENV CHIKV project\Lab Data\ELISA Database\ELISA Latest\elisa_merged", replace

outsheet id* studyid id_wide id_visit stanforddenvigg_ stanfordchikvigg_ chikvigg_ denvigg_  using "elisas_merged.csv", comma names replace


*************
gen anna_seroc_denv=.
*	foreach studyid in "cfa0313" "cfa0327" "cfa0328" "cfa0332" "rfa0427" "rfa0428" "cfa0285" "mfa0537" "mfa0598" "mfa0703" "mfa0933" "ufa0570"{
	foreach id_wide in "cf313" "cf327" "cf328" "cf332" "rf427" "rf428" "cf285" "mf537" "mf598" "mf703" "mf933" "uf570"{
	replace anna_seroc_denv= 1 if id_wide == "`id_wide'"
}

bysort id_visit: tab anna_seroc_denv stanforddenvigg_ 


gen jimmy_seroc_chikv=.
replace studyid = lower(studyid)
list studyid if strpos(studyid, "ufa0572")
foreach id_wide in "uf572" "uf599" "uf840" "mf563" "kf433"{
	replace jimmy_seroc_chikv= 1 if id_wide == "`id_wide'"
}

bysort id_visit: tab jimmy_seroc_chikv stanfordchikvigg_, m
