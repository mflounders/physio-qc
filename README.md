# physio-qc
physio analysis for fMRI analysis (pulse ox and respiration), wrapping RETROICOR functions with quality control pipeline 

Flow:

1.	subj_batch_TNI.m
-	process_subj_TNI.m
-	create_regressors.m
-	matchPulsFile_SYNC
    1.	listdir.m
-	PulseRespSYNC_Graph.m
    1.	read_PULS_log_fileSYNC.m
    2.	filter_signalNODISP.m
    3.	smooth_kernel.m
    4.	detpeaks.m

2.	Physio_QC.m
