net install st0131, from(http://www.stata-journal.com/software/sj7-3)
ssc install stmix, replace

clear
cd M:\Mixture_Model\
import delimited Task1.csv, delimiters(" ", collapse)
stset time_to_rem, failure(rem_bin)
streg s103_gender s188_positive_famhx s200_neurol_exam_result s253_seiz_febrile s383_learning_disability age_diag time_first_seiz_first_aed /*
	 */epi_diag_generalized epi_diag_unclassified /*
     */part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon other_seiz /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */pc1 pc2 pc3 pc4 pc5 /*
	 */ucl ulb ekut rcsi gla uliv aus, dist(weibull)

*generate baseline hazard from logistic regression
generate bhaz=0

*Look at mixture model with delayed and refractory...	 
	 
strsmix, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)

strsmix, k2(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
		
* k1 ll -2977; k2 ll -2974 - use k1 as simplier model

strsmix s103_gender s188_positive_famhx s200_neurol_exam_result s253_seiz_febrile s383_learning_disability age_diag time_first_seiz_first_aed /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* clins, pi + neuro, lambda - neuro

strsmix epi_diag_generalized epi_diag_unclassified /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* epi diag, pi , lambda 

strsmix part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* seiz type, pi , lambda 

strsmix eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* eeg, pi +eeg, lambda -eeg -neuro 

strsmix imag_2 imag_4 imag_nk /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* imag, pi , lambda -neuro

strsmix seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* seiz no, pi , lambda

strsmix pc1 pc2 pc3 pc4 pc5 /*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* seiz no, pi , lambda

strsmix s200_neurol_exam_result/*
	 */, k1(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibull) link(identity)
* final model of neuro as neuro + cohort did not fit

*shift times to 365+		
generate time_to_rem3 = time_to_rem + 365 if time_to_rem>0
replace time_to_rem3= runiform(1,200) if time_to_rem==0 
stset time_to_rem3, failure(rem_bin)

*test
strsmix s200_neurol_exam_result /*
	 */, bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*dist 1 is immediates and dist 2 is delayed
*logistic works, not identity

*analyse
strsmix s200_neurol_exam_result /*
	 */, k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*base model ll -6672
		
strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(s103_gender s188_positive_famhx s200_neurol_exam_result s253_seiz_febrile s383_learning_disability age_diag time_first_seiz_first_aed) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
* clins, pi - neuro, p + gender,neuro,age, lambda -imag 

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(epi_diag_generalized epi_diag_unclassified) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
* epi diag, pi - neuro, p + gender,neuro,age, lambda -imag 

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*seiz types, pi + neuro, lambda - neuro, p + genTC, monoabsTC

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(eeg_status_2 eeg_status_4 eeg_status_nk) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*eeg, pi + neuro, lambda - neuro,eeg,imag, p 

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(imag_2 imag_4 imag_nk ) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*imag, pi + neuro, lambda - neuro,eeg, p

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 ) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*seiz no, pi + neuro, lambda - neuro, p seiz no

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(pc1 pc2 pc3 pc4 pc5) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*PCs, pi + neuro, lambda - neuro,imag, p

strsmix s200_neurol_exam_result, /*
	 */k3(s200_neurol_exam_result age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(ucl ulb ekut rcsi gla uliv aus) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*cohort, pi + neuro, lambda - neuro,eeg, imag p
		
strsmix s200_neurol_exam_result, /*
	 */k3(age_diag /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */ucl ulb ekut rcsi gla uliv aus) /*
	 */ pmix(part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon age_diag s103_gender seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 pc3) /*
	 */ bhazard(bhaz) /// 
		distribution(weibexp) link(logistic)
*final model

		
predict rs, survival ci

predict cure, cure ci

predict rsu, survival uncured ci

graph twoway scatter rsu time_to_rem2 if time_to_rem2>365 & rem_bin==0

sts graph, level(95) censored(single) 

generate time_to_rem3 = time_to_rem + 365 if time_to_rem>0
replace time_to_rem3= runiformint(300,360) if time_to_rem==0 
stset time_to_rem3, failure(rem_bin)


strsmix s103_gender age_diag s188_positive_famhx, bhazard(bhaz) /// 
	    pmix(s103_gender age_diag s188_positive_famhx) /// 
		distribution(weibexp) link(logistic)
		
predict p3, pmix ci
