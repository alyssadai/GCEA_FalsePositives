function distanceMat = GiveMeDistanceMatrix(whatSpecies,structFilter)
% Gives a pairwise distance matrix
%-------------------------------------------------------------------------------
if nargin < 2
    structFilter = 'all';
end

%-------------------------------------------------------------------------------
switch whatSpecies
case 'mouse'
    % Pairwise ipsilateral Euclidean distance data:
    % warning('Distances only work at the moment for whole-brain data')
    load('Mouse_Connectivity_Data.mat','Dist_Matrix','regionAcronyms');
    distanceMat = Dist_Matrix{1,1}/1000;
    acronym = regionAcronyms;
    % Map to division labels:
    dataFile = GiveMeFile('AllenMouseGene');
    load(dataFile,'structInfo');

case 'human'
    % Latest data processed by Aurina
    dataFile = '100DS220scaledRobustSigmoidNSGDSQC1LcortexSubcortexSEPARATE_ROI_NOdistCorrSurfaceANDEuclidean.mat';
    % dataFile = '100DS220scaledRobustSigmoidNSGDSQC1LcortexSubcortex_ROI_NOdistCorrSurfaceANDEuclidean.mat';
    load(dataFile,'averageDistance');
    distanceMat = averageDistance;

case 'human2017'
    % Results using data provided by Aurina in 2017
    warning('ASSUMING HCP LEFT CORTICAL PARCELLATION!!! :-O')
    fileName = '360parcellationLcortex_ProbeMean.mat';
    fprintf(1,'Loading data from ''%s''\n',fileName);
    load(fileName,'coordinatesROI');
    fprintf(1,'%u ROIs\n',size(coordinatesROI,1));
    ROIIDs = coordinatesROI(:,1);
    % Check that they match the expression data
    load(fileName,'geneROI');
    expression_ROI_IDs = geneROI(:,1);
    if ~all(ROIIDs==expression_ROI_IDs)
        error('Error matching ROI IDs for %s',fileName);
    end
    coOrds = coordinatesROI(:,2:end);
    distanceMat = squareform(pdist(coOrds,'Euclidean'));
end

%-------------------------------------------------------------------------------
% Filter structures:
if ~strcmp(structFilter,'all')
    [~,~,~,keepStruct] = filterStructures(structFilter,structInfo);
    distanceMat = distanceMat(keepStruct,keepStruct);
end

%-------------------------------------------------------------------------------

fprintf(1,'%u x %u pairwise distance matrix\n',...
                size(distanceMat,1),size(distanceMat,2));

end
