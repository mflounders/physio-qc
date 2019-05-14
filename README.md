# physio-qc
physio analysis for fMRI analysis (pulse ox and respiration), wrapping RETROICOR functions with quality control pipeline 

Flow:
1.	subj_batch_TNI.m
2.	process_subj_TNI.m
3.	create_regressors_GS.m
4.	matchPulsFile_SYNC
    5.	listdir.m
5.	pulseRespSYNC_Graph
    1.	read_PULS_log_fileSYNC
    2.	read_PMU_file
    3.	filter_signalNODISP
    4.	smooth_kernel.m
    5.	detpeaks.m
6.	Physio_QC.m
