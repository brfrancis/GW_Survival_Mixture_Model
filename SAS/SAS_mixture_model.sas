proc import datafile='M:\Mixture_Model\Task1.csv' dbms=dlm out=msurv replace;
	getnames=yes;
run;

ods graphics on;
proc lifetest data=msurv plots=(survival(nocensor));
	time TIME_TO_REM*rem_bin(0);
run;

data msurvnoz;
	set msurv;
	if TIME_TO_REM<>0;
run;

proc lifetest data=msurvnoz plots=(survival(nocensor));
	time TIME_TO_REM*rem_bin(0);
run;

proc phreg data=msurv;
	model TIME_TO_REM*rem_bin(0)=S103_GENDER S188_POSITIVE_FAMHX S200_NEUROL_EXAM_RESULT S253_SEIZ_FEBRILE S383_LEARNING_DISABILITY AGE_DIAG TIME_FIRST_SEIZ_FIRST_AED 
				     EPI_DIAG_GENERALIZED EPI_DIAG_UNCLASSIFIED 
				     PART_ONLY GEN_TONCLON ABS_SEIZ MONOABS_TONCLON UNCLA_TONCLON OTHER_SEIZ
				     EEG_status_2 EEG_status_4 EEG_status_NK
				     Imag_2 Imag_4 Imag_NK
				     Seiz_4 Seiz_8 Seiz_16 Seiz_21 Seiz_998
				     PC1 PC2 PC3 PC4 PC5
				     UCL ULB EKUT RCSI GLA ULIV AUS;
	baseline covariates=msurv;
run;

proc phreg data=msurvnoz;
	model TIME_TO_REM*rem_bin(0)=S103_GENDER S188_POSITIVE_FAMHX S200_NEUROL_EXAM_RESULT S253_SEIZ_FEBRILE S383_LEARNING_DISABILITY AGE_DIAG TIME_FIRST_SEIZ_FIRST_AED 
				     EPI_DIAG_GENERALIZED EPI_DIAG_UNCLASSIFIED 
				     PART_ONLY GEN_TONCLON ABS_SEIZ MONOABS_TONCLON UNCLA_TONCLON OTHER_SEIZ
				     EEG_status_2 EEG_status_4 EEG_status_NK
				     Imag_2 Imag_4 Imag_NK
				     Seiz_4 Seiz_8 Seiz_16 Seiz_21 Seiz_998
				     PC1 PC2 PC3 PC4 PC5
				     UCL ULB EKUT RCSI GLA ULIV AUS;
	baseline covariates=msurvnoz;
run;

%pspmcm(DATA= msurvnoz, ID= ID_1, CENSCOD= rem_bin, TIME= TIME_TO_REM,
VAR= S103_GENDER(IS, 1) AGE_DIAG(IS, 18) S188_POSITIVE_FAMHX(IS,0),
INCPART= logit,
SURVPART= Cox,
TAIL= zero, SU0MET= pl,
MAXITER= 200, CONVCRIT= 1e-5, ALPHA= 0.05,
FAST= Y,BOOTSTRAP= Y, NSAMPLE= 2000, BOOTMET= ALL,
GESTIMATE= Y,
BASELINE=Y,
SPLOT=Y);
run;
