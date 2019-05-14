function subj_batch_TNI(subjID)

if strfind(subjID,'TNI')
    % outDir = '/data/jux/oathes_group/projects/gavi/TNI_output';
    outDir = '/data/jux/oathes_group/projects/floum/phys_testing/TNI_output';
elseif strfind(subjID, 'R01')
    outDir = '/data/jux/oathes_group/projects/floum/phys_testing/ZAPR01_output';
end
cd(outDir)
baseFile = fopen(sprintf('%s_baseline.txt',subjID),'w');
scanFile = fopen(sprintf('%s_TMS.txt',subjID),'w');

process_subj_TNI_2(subjID, baseFile, scanFile, outDir)

end