function process_subj_TNI(subjID, baseFile, scanFile, outDir, site_list,filter)
%This script creates regressors for an entire subject and prints them to a
%.txt

%% Basic setup
cd(outDir)

mkdir(subjID)
graphDir = sprintf('%s/%s',outDir,subjID);

baseDir = '/data/jag/cnds/TNI_ZapR01/SubjectsData';


subjDir = sprintf('%s/%s', baseDir, subjID);
base_scans = ['Rest_AP'; 'Rest_PA'];

sites{1} = 'IFG';
sites{2} = '*gACC';
sites{3} = 'FP';
sites{4} = 'M1';
sites{5} = 'LPFC';

if ~exist('site_list','var')
    site_list = 1:size(sites,2);
end

if ~exist('filter','var')
    filter =0;
end

scans{1} = 'Rest_Pre';
scans{2} = 'sp80_Pre';
scans{3} = 'sp100_Pre';
scans{4} = 'sp120_Pre';
scans{5} = 'TBS';
scans{6} = 'sp120_Post';
scans{7} = 'Rest_Post';

if exist(subjDir, 'dir')
%% Get regressors and graphs for baseline
    dataDir = sprintf('%s/Baseline', subjDir);
    if exist(dataDir, 'dir')
        fprintf(baseFile, '%s\tBaseline\t', subjID);
        physioDir = sprintf('%s/Physio', dataDir);
        pulsdir = sprintf('%s/pulsdir', dataDir);
        if exist(physioDir, 'dir') && exist(pulsdir,'dir')
            for i = 1:2
                siteDir = sprintf('%s/%s', dataDir, base_scans(i,:));
                if exist(siteDir, 'dir')
                    dicomDir = sprintf('%s/Dicom', siteDir);
                    %check to make sure there actually are dicoms
                    dicoms = dir(sprintf('%s/*.dcm',dicomDir));
                    if ~isempty(dicoms)
                        session_dir = sprintf('%s/Nifti', siteDir);
                        [regressors, pulse, resp] = create_regressors_3(session_dir, dicomDir, pulsdir);
                        fprintf(baseFile, regressors);

                        %make graphs
                        cd(graphDir)
                        if ~isempty(pulse.data) && ~filter
                            figure
                            plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.data)
                            title(sprintf('%s_Baseline_%s_PULS',subjID,base_scans(i,:)),'Interpreter','none')
                            saveas(gcf,sprintf('%s_Baseline_%s_PULS',subjID, base_scans(i,:)),'fig')
                            saveas(gcf,sprintf('%s_Baseline_%s_PULS',subjID, base_scans(i,:)),'bmp')
                            close(gcf)
                        end
                        
                        if ~isempty(resp.data) && ~filter
                            figure
                            plot((resp.AT_ms-resp.AT_ms(1))/1000,resp.data)
                            title(sprintf('%s_Baseline_%s_RESP',subjID,base_scans(i,:)),'Interpreter','none')
                            saveas(gcf,sprintf('%s_Baseline_%s_RESP',subjID, base_scans(i,:)),'fig')
                            saveas(gcf,sprintf('%s_Baseline_%s_RESP',subjID, base_scans(i,:)),'bmp')
                            close(gcf)
                        end
                        
                        if filter && ~isempty(pulse.data)
                            figure
                            plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.Hsignal)
                            title(sprintf('%s_Baseline_%s_Hsignal',subjID,base_scans(i,:)),'Interpreter','none')
                            saveas(gcf,sprintf('%s_Baseline_%s_Hsignal',subjID, base_scans(i,:)),'fig')
                            saveas(gcf,sprintf('%s_Baseline_%s_Hsignal',subjID, base_scans(i,:)),'bmp')
                            close(gcf)
                        end
                           
                        if ~isempty(resp.data) && filter
                            figure
                            plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.Lsignal)
                            title(sprintf('%s_Baseline_%s_Lsignal',subjID,base_scans(i,:)),'Interpreter','none')
                            saveas(gcf,sprintf('%s_Baseline_%s_Lsignal',subjID, base_scans(i,:)),'fig')
                            saveas(gcf,sprintf('%s_Baseline_%s_Lsignal',subjID, base_scans(i,:)),'bmp')
                            close(gcf)
                        end
                        cd(outDir)
                        
                    else
                        fprintf(baseFile, '\t\tDicom folder has no .dcms');
                    end
                else
                    fprintf(baseFile, '\t\tFolder does not exist');
                end
            end
            fprintf(baseFile, '\n');
        else
            fprintf(baseFile, 'Subj %s has no physio for baseline\n', subjID);
        end
    else
        fprintf(baseFile, 'Subj %s has no baseline folder\n', subjID);
    end
    
    %% Regressors and graphs for sites
    %get regressors for the real sites
    TMS_fMRI = dir(sprintf('%s/TMS_fMRI*',subjDir));
    if ~isempty(TMS_fMRI)
        for q = 1:length(TMS_fMRI)
            dataDir = sprintf('%s/%s',subjDir,TMS_fMRI(q).name);
            %check to make sure there is Physio
            physioDir = sprintf('%s/Physio', dataDir);
            pulsdir = sprintf('%s/pulsdir', dataDir);
            if exist(physioDir, 'dir') && exist(pulsdir,'dir')
                %check which sites
                for i = site_list
                    x = dir(sprintf('%s/%s*',dataDir,sites{i}));
                    if ~isempty(x)
                    for z = 1:length(x)
                        site= x(z).name;
                        %if subj has that site
                        siteDir = sprintf('%s/%s', dataDir, x(z).name);
                        fprintf(scanFile, '%s\t%s\t', subjID, x(z).name); %print site name
                        %flip through scan options
                        for n = 1:size(scans,2) 
                            y = dir(sprintf('%s/%s*%s*', siteDir, scans{n}, sites{i}));
                            if ~isempty(y)
                                dicomDir = sprintf('%s/%s/Dicom', siteDir, y.name);
                                %check to make sure dico dir has dicoms
                                dicoms = dir(sprintf('%s/*.dcm',dicomDir));
                                if ~isempty(dicoms)
                                    session_dir = sprintf('%s/%s/Nifti', siteDir, y.name);
                                    [regressors, pulse, resp] = create_regressors_3( session_dir, dicomDir, pulsdir);
                                    fprintf(scanFile,'%s', regressors);

                                    cd(graphDir)
                                    if ~isempty(pulse.data) && ~filter
                                        figure
                                        plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.data)
                                        title(sprintf('%s_%s_%s_PULS',subjID,site,scans{n}),'Interpreter','none')
                                        saveas(gcf,sprintf('%s_%s_%s_PULS',subjID, site, scans{n}),'fig')
                                        saveas(gcf,sprintf('%s_%s_%s_PULS',subjID, site, scans{n}),'bmp')
                                        close(gcf)
                                    end

                                    if ~isempty(resp.data) && ~filter
                                        figure
                                        plot((resp.AT_ms-resp.AT_ms(1))/1000,resp.data)
                                        title(sprintf('%s_%s_%s_RESP',subjID,site,scans{n}),'Interpreter','none')
                                        saveas(gcf,sprintf('%s_%s_%s_RESP',subjID, site, scans{n}),'fig')
                                        saveas(gcf,sprintf('%s_%s_%s_RESP',subjID, site, scans{n}),'bmp')
                                        close(gcf)
                                        cd(outDir)
                                    end

                                    if filter
                                        figure
                                        plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.Hsignal)
                                        title(sprintf('%s_%s_%s_Hsignal',subjID,site,scans{n}),'Interpreter','none')
                                        saveas(gcf,sprintf('%s_%s_%s_Hsignal',subjID, site, scans{n}),'fig')
                                        saveas(gcf,sprintf('%s_%s_%s_Hsignal',subjID, site, scans{n}),'bmp')
                                        close(gcf)

                                        figure
                                        plot((pulse.AT_ms-pulse.AT_ms(1))/1000,pulse.Lsignal)
                                        title(sprintf('%s_%s_%s_Lsignal',subjID,site,scans{n}),'Interpreter','none')
                                        saveas(gcf,sprintf('%s_%s_%s_Lsignal',subjID, site, scans{n}),'fig')
                                        saveas(gcf,sprintf('%s_%s_%s_Lsignal',subjID, site, scans{n}),'bmp')
                                        close(gcf)
                                    end
                                else
                                    fprintf(scanFile, '\t\tNo .dcm files in  Dicom folder');
                                end
                            else
                                fprintf(scanFile,'\t\t\t');
                            end
                        end
                        fprintf(scanFile, '\n');
                    end
                    end
                end
        
            else
            fprintf(scanFile, 'Subj %s does not have physio for TMS/fMRI\n', subjID);
            end
        end
    else 
        fprintf(scanFile, 'Subj %s has no TMS/fMRI folder\n', subjID);
    end
else
    fprintf(scanFile, 'Subject %s does not exist.', subjID);
end


end