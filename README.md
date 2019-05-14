# physio-qc
physio analysis for fMRI analysis (pulse ox and respiration), wrapping RETROICOR functions with quality control pipeline 

Flow:
1.	subj_batch_TNI.m
  a.	process_subj_TNI.m
    i.	create_regressors_GS.m
      1.	matchPulsFile_SYNC
          a.	listdir.m
      2.	pulseRespSYNC_Graph
          a.	read_PULS_log_fileSYNC
          b.	read_PMU_file
          c.	filter_signalNODISP
          d.	smooth_kernel.m
          e.	detpeaks.m
 2.	Physio_QC.m
