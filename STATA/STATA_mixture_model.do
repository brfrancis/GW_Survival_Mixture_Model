clear
cd M:\Mixture_Model\
import delimited Task1.csv, delimiters(" ", collapse)
stset time_to_rem, failure(rem_bin)
stcox s103_gender s188_positive_famhx s200_neurol_exam_result s253_seiz_febrile s383_learning_disability age_diag time_first_seiz_first_aed /*
	 */epi_diag_generalized epi_diag_unclassified /*
     */part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon other_seiz /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */pc1 pc2 pc3 pc4 pc5 /*
	 */ucl ulb ekut rcsi gla uliv aus
	 
stmix s103_gender s188_positive_famhx s200_neurol_exam_result s253_seiz_febrile s383_learning_disability age_diag time_first_seiz_first_aed /*
	 */epi_diag_generalized epi_diag_unclassified /*
     */part_only gen_tonclon abs_seiz monoabs_tonclon uncla_tonclon other_seiz /*
	 */eeg_status_2 eeg_status_4 eeg_status_nk /*
	 */imag_2 imag_4 imag_nk /*
	 */seiz_4 seiz_8 seiz_16 seiz_21 seiz_998 /*
	 */pc1 pc2 pc3 pc4 pc5 /*
	 */ucl ulb ekut rcsi gla uliv aus, distribution(weibweib) nolog
