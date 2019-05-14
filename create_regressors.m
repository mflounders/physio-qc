function [regressors, pulse, resp] = create_regressors(outDir,dicomDir, pulsdir)
%outputs physio regressors
[pulsMatch, dicomStart, dicomEnd] = matchPulsFile_SYNC(dicomDir, pulsdir);
if ~isempty(pulsMatch)
    [output, pulse, resp] = PulseRespSYNC_Graph(dicomDir, pulsMatch, outDir, dicomStart, dicomEnd);
    %Run PulsResp
    %Save PulsResp output 
    regressors = sprintf('%d\t%d\t\t',output.Highrate,output.Lowrate);
else
    regressors = 'No puls match\t\t\t';
    output.all = [];
    pulse.data = [];
    resp.data = [];
end
output.all = detrend(output.all);
dlmwrite(fullfile(outDir,'pulse_params.txt'),output.all,'delimiter',' ','precision','%10.5f')

end