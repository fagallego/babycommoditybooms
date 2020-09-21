
set matsize 1000
set more off


/***
This do file replicates the results presented in the Figures and Tables of the paper. It uses two datasets: 
(i) the main dataset, which replicates all the results except Table 8
(ii) the dataset used in Table 8.

The first part of the do file uses (i) and at the end we add (ii)

***/

use main_dataset_final.dta, clear


*Figure 1, Panel A

tsline instrument_pindex1 instrument_pindex10 instrument_pindex15 instrument_pindex20 instrument_pindex25 instrument_pindex30 instrument_pindex35 instrument_pindex40 instrument_pindex45 instrument_pindex50 instrument_pindex55 instrument_pindex60 instrument_pindex65 instrument_pindex70 instrument_pindex75 instrument_pindex80 instrument_pindex85 instrument_pindex90 instrument_pindex95 instrument_pindex100 instrument_pindex105 instrument_pindex110 instrument_pindex115 instrument_pindex120 instrument_pindex125 instrument_pindex130 instrument_pindex135 instrument_pindex140 instrument_pindex145 instrument_pindex150 instrument_pindex155 instrument_pindex160 instrument_pindex165 instrument_pindex170 instrument_pindex175 instrument_pindex180 instrument_pindex185 instrument_pindex190 instrument_pindex195 instrument_pindex200 instrument_pindex205 instrument_pindex210 instrument_pindex215 instrument_pindex220 instrument_pindex225 instrument_pindex230 instrument_pindex235 instrument_pindex240 instrument_pindex245 instrument_pindex250 instrument_pindex255 instrument_pindex260 instrument_pindex265 instrument_pindex270 instrument_pindex275 instrument_pindex280 instrument_pindex285 instrument_pindex290 instrument_pindex295 instrument_pindex300 instrument_pindex305 instrument_pindex310 instrument_pindex315 instrument_pindex320 instrument_pindex325 instrument_pindex330 instrument_pindex335, legend(off)	   

*Figure 1, Panel B

tsline resid1 resid10 resid15 resid20 resid25 resid30 resid35 resid40 resid45 resid50 resid55 resid60 resid65 resid70 resid75 resid80 resid85 resid90 resid95 resid100 resid105 resid110 resid115 resid120 resid125 resid130 resid135 resid140 resid145 resid150 resid155 resid160 resid165 resid170 resid175 resid180 resid185 resid190 resid195 resid200 resid205 resid210 resid215 resid220 resid225 resid230 resid235 resid240 resid245 resid250 resid255 resid260 resid265 resid270 resid275 resid280 resid285 resid290 resid295 resid300 resid305 resid310 resid315 resid320 resid325 resid330 resid335, legend(off)

*Table 1

preserve
gen d=1


* Summary Statistics
local mlist ""
local sdlist ""
local Nlist ""
foreach stat in m sd N {
  foreach var in birth ln_birth birth_rate  first_born num_children num_births weeks_less28 gestational_age lbw vlbw doctor_birth midwife_birth hospital_birth single_birth  mom_single mom_working ocupa_m_2 p_activo ocupa_p_2 mom_univ mom_hs mom_lhs mom_age dad_univ dad_hs dad_lhs {
    local `stat'list "``stat'list' `stat'`var' = `var'"
  }
}

di "collapse (mean) `mlist' (sd) `sdlist' (count) `Nlist'"
collapse (mean) `mlist' (sd) `sdlist' (count) `Nlist', by(d)
reshape long m sd N, i(d) j(var) string

gen orden=.
replace orden=1 if var=="birth"
replace orden=2 if var=="ln_birth"
replace orden=3 if var=="birth_rate"
replace orden=4 if var=="first_born"
replace orden=5 if var=="num_children"
replace orden=6 if var=="num_births"
replace orden=7 if var=="weeks_less28" 
replace orden=8 if var=="gestational_age" 
replace orden=9 if var=="lbw" 
replace orden=10 if var=="vlbw"
replace orden=11 if var=="doctor_birth"
replace orden=12 if var=="midwife_birth"
replace orden=13 if var=="hospital_birth"
replace orden=14 if var=="single_birth"
replace orden=15 if var=="mom_single"
replace orden=16 if var=="mom_working"
replace orden=17 if var=="ocupa_m_2"
replace orden=18 if var=="mom_univ" 
replace orden=19 if var=="mom_hs" 
replace orden=20 if var=="mom_lhs" 
replace orden=21 if var=="mom_age"
replace orden=22 if var=="p_activo"
replace orden=23 if var=="ocupa_p_2"
replace orden=24 if var=="dad_univ" 
replace orden=25 if var=="dad_hs" 
replace orden=26 if var=="dad_lhs"

format m %9.3f
format sd %9.3f
format N %9.0fc
sort orden

reshape wide m sd N, i(orden) j(d)

*sum areact0 indct0 areact1 indct1

export excel var N m sd using means.xls, replace firstrow(var)

restore

xi i.quarter

*Table 2
estimates clear

areg employment_rate instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_comuna

areg employ_rate instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_c_comuna

areg employment_rate instrument_pindex _I*, absorb(comuna) cluster(comuna), if quarter<=200209
estimates store E_comuna_early

areg employment_rate instrument_pindex _I*, absorb(comuna) cluster(comuna), if quarter>=200300
estimates store E_comuna_late

areg employment_rate instrument_pindex _I*, absorb(comuna) cluster(comuna), if region~=13
estimates store E_comuna_noRM

areg employment_rate instrument_pindex _I*, absorb(comuna) cluster(comuna), if region>=5
estimates store E_comuna_noNorth


esttab *, keep(instrument_pindex ) b(3) star(* 0.1 ** 0.05 *** 0.01)


* Table 3
estimates clear
areg employ_rate instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_all
areg employ_rate_agr instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_agr
areg employ_rate_manu instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_manu
areg employ_rate_min instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_min
areg employ_rate_ser instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_ser
areg employ_rate_male instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_male
areg employ_rate_female instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store E_female

esttab E_*, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))



*Table 4
estimates clear
areg birth_rate instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store birt 

areg ln_birth instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store ln
areg first_born instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store y_1st
areg num_children instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store y_chi
areg mom_single instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store y_bir

esttab *, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Table 5: See at the end of this file


*Table 6
estimates clear
areg birth_rate cycle_index trend_index  _I*, absorb(comuna) cluster(comuna)

areg ln_birth cycle_index trend_index  _I*, absorb(comuna) cluster(comuna)
estimates store ln
areg first_born cycle_index trend_index  _I*, absorb(comuna) cluster(comuna)
estimates store y_1st
areg num_children cycle_index trend_index  _I*, absorb(comuna) cluster(comuna)
estimates store y_chi
areg mom_single cycle_index trend_index  _I*, absorb(comuna) cluster(comuna)
estimates store y_bir

esttab *, keep(cycle_index trend_index )  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Table 7

estimates clear

areg doctor_birth instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store a
areg midwife_birth instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store b
areg hospital_birth instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store c
areg weeks_28to36 instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store e
areg gestational_age instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store i
areg lbw instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store g
areg vlbw instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store f


esttab *, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Table 8
estimates clear
areg mom_univ instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store m1

areg mom_hsd instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store m2

areg mom_lhs instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store m3

areg ocupa_m_2 instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store m4



areg dad_univ instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store p1

areg dad_hsd instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store p2

areg dad_lhs instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store p3

areg ocupa_p_2 instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store p4

*Panel A: Mothers
esttab m*, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))
*Panel B: Fathers
esttab p*, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))


*Table 9
*Columns 1 and 2, see at the end of this do file
* Columns 3 to 5
estimates clear
areg first_born_lhs instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store a_l
areg num_children_lhs instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store b_l
areg mom_single_lhs instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store d_l

areg first_born_hsd instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store a_h
areg num_children_hsd instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store b_h
areg mom_single_hsd instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store d_h

areg first_born_univ instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store a_u
areg num_children_univ instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store b_u
areg mom_single_univ instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store d_u

*Panel A: Less than High School
esttab *_l, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Panel B: High School Degrees
esttab *_h, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Panel C: University
esttab *_u, keep(instrument_pindex)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))



*Appendix Table 1
estimates clear
areg birth_rate instrument_pindex  instrument_pindex_lag1 _I*, absorb(comuna) cluster(comuna)
estimates store birt1 
areg ln_birth instrument_pindex instrument_pindex_lag1 _I*, absorb(comuna) cluster(comuna)
estimates store ln1

esttab *, keep(instrument_pindex*)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Appendix Table 2
estimates clear
areg ln_pop instrument_pindex _I* , absorb(comuna) cluster(comuna)
estimates store pop1
areg ln_pop instrument_pindex _I* if employ_rate~=., absorb(comuna) cluster(comuna)
estimates store pop2
areg sex_ratio_r instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store pop3

esttab *, keep(instrument_pindex )  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Appendix Table 3
estimates clear
areg ln_birth_fb instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store fs
areg ln_birth_nfb instrument_pindex _I*, absorb(comuna) cluster(comuna)
estimates store ns


esttab *s, keep(instrument_pindex )  b(3) se star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))



*Table 5

use dataset_table5.dta, clear
estimates clear
areg birth_rate instrument_pindex instrument_pindex_birth i.quarter i.quarter_b, absorb(comuna) cluster(comuna)
estimates store birt 
areg ln_birth instrument_pindex instrument_pindex_birth i.quarter i.quarter_b, absorb(comuna) cluster(comuna)
estimates store ln
areg first_born instrument_pindex instrument_pindex_birth i.quarter i.quarter_b, absorb(comuna) cluster(comuna)
estimates store y_1st
areg num_children instrument_pindex instrument_pindex_birth i.quarter i.quarter_b, absorb(comuna) cluster(comuna)
estimates store y_chi
areg mom_single instrument_pindex instrument_pindex_birth i.quarter i.quarter_b, absorb(comuna) cluster(comuna)
estimates store y_bir

esttab *, keep(instrument_pindex instrument_pindex_birth)  b(3) star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Table 9, columns 1 and 2

use dataset_table9.dta, clear
estimates clear
xi: areg micro_employed instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & lhs==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pE_women1545_lhs 
sum micro_employed if women1540==1 & lhs==1 & micro_partner==1

xi: areg micro_employed_others instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & lhs==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pEo_women1545_lhs 
sum micro_employed_others if women1540==1 & lhs==1 & micro_partner==1

xi: areg micro_employed instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & hsd==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pE_women1545_hsd
sum micro_employed if women1540==1 & hsd==1 & micro_partner==1

xi: areg micro_employed_others instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & hsd==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pEo_women1545_hsd
sum micro_employed_others if women1540==1 & hsd==1 & micro_partner==1

xi: areg micro_employed instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & uni==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pE_women1545_uni
sum micro_employed if women1540==1 & uni==1 & micro_partner==1

xi: areg micro_employed_others instrument_pindex _I*   i.micro_edad i.micro_esc i.quarter   if women1540==1 & uni==1 & micro_partner==1, absorb(comuna) cluster(comuna_quarter)
estimates store pEo_women1545_uni
sum micro_employed_others if women1540==1 & uni==1 & micro_partner==1

*Panel A: Less than high school diploma
esttab *_lhs, keep(instrument_pindex )  b(3) se star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Panel B: High school diploma
esttab *_hsd, keep(instrument_pindex )  b(3) se star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))

*Panel C: University
esttab *_uni, keep(instrument_pindex )  b(3) se star(* 0.1 ** 0.05 *** 0.01) stats(r2 rmse N , fmt(%9.3f %9.3f %9.0gc))



