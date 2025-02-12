function dataFileSurrogate = FindNullFile(params)
% Setting for the ensemble enrichment parameters
%-------------------------------------------------------------------------------

if params.e.useAutoSpatial
    if strcmp(params.humanOrMouse,'human')
        dataFileSurrogate = sprintf('%s_%s-%s_Surrogate_N%u.mat',params.humanOrMouse,...
            params.g.whatParcellation,params.structFilter,params.e.numNullSamples);
    else
        dataFileSurrogate = sprintf('%s_%s_Surrogate_N%u.mat',params.humanOrMouse,...
                            params.structFilter,params.e.numNullSamples);
    end
else
    if strcmp(params.humanOrMouse,'human')
        dataFileSurrogate = sprintf('%s_%s-%s_Surrogate_N%u_manual.mat',params.humanOrMouse,...
                params.g.whatParcellation,params.structFilter,params.e.numNullSamples);
    else
        dataFileSurrogate = sprintf('%s_%s_Surrogate_N%u_manual.mat',params.humanOrMouse,...
                            params.structFilter,params.e.numNullSamples);
    end
end

dataFileSurrogate = fullfile('SurrogateMaps',dataFileSurrogate);

%===============================================================================
% OLD PYTHON VERSION:
%===============================================================================
%
% %-------------------------------------------------------------------------------
% % In the case of some custom spatially constrained ensemble, can specify the file
% % containing the info:
% dataFileSurrogate = '';
% switch whatSpecies
% case 'mouse'
%     if strcmp(structFilter,'cortex')
%         fprintf(1,'Spatial maps for mouse cortex\n');
%         switch numNullSamples
%         case 20000
%             dataFileSurrogate = 'mouseCortexSurrogate_N20000_rho8_d040.csv';
%         case 40000
%             dataFileSurrogate = 'mouseCortexSurrogate_N40000_rho8_d0270.csv';
%         end
%     else
%         fprintf(1,'Spatial maps for mouse whole brain\n');
%         switch numNullSamples
%         case 20000
%             dataFileSurrogate = 'mouseSurrogate_N20000_rho8_d040.csv';
%         case 40000
%             dataFileSurrogate = 'mouseSurrogate_N40000_rho8_d078.csv';
%         end
%     end
% case 'human'
%     fprintf(1,'Spatial maps for human cortex\n');
%     switch numNullSamples
%     case 20000
%         dataFileSurrogate = 'humanSurrogate_N20000_rho8_d02000.csv';
%     case 40000
%         dataFileSurrogate = 'humanSurrogate_N40000_rho8_d03500.csv';
%     end
% end
%
% if isempty(dataFileSurrogate)
%     warning('No file found containing custom surrogate phenotypes')
% end

end
