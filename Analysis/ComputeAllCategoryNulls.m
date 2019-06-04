function GOTable = ComputeAllCategoryNulls(params,numNullSamples,whatNullType,whatCorr,aggregateHow,saveOut,beVerbose)
% Computes and saves null distribution for all GO categories
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Settings:
if nargin < 1
    params = 'mouse';
end
if ischar(params)
    params = GiveMeDefaultParams(params);
end
whatSpecies = params.g.humanOrMouse;
if nargin < 2
    numNullSamples = 1000;
end
if nargin < 3
    whatNullType = 'randomMap';
end
if nargin < 4
    whatCorr = 'Spearman';
end
% How to aggregate scores across genes in a category
if nargin < 5
    aggregateHow = 'mean';
end
if nargin < 6
    saveOut = true;
end
if nargin < 7
    beVerbose = true;
end

%-------------------------------------------------------------------------------
% Get real data:
[geneData,geneInfo,structInfo] = LoadMeG(params.g);
numGenes = height(geneInfo);
numAreas = height(structInfo);

%-------------------------------------------------------------------------------
% Get a generic GO Table:
GOTable = GiveMeGOData(params,geneInfo.entrez_id);
numAreas = height(structInfo);
numGOCategories = height(GOTable);
numGenesReal = height(geneInfo);

%-------------------------------------------------------------------------------
% Get random vectors from real genes to use as null spatial maps:
if ischar(whatNullType)
    switch whatNullType
    case 'randomMap'
        % Generate as many random maps as null samples:
        nullMaps = rand(numAreas,numNullSamples);
    case 'spatialLag'
        % Get the pre-computed surrogate data:
        switch whatSpecies
        case 'mouse'
            if strcmp(params.g.structFilter,'cortex')
                fprintf(1,'Spatial maps for mouse cortex\n');
                dataFileSurrogate = 'mouseCortexSurrogate_N20000_rho8_d040.csv';
            else
                fprintf(1,'Spatial maps for mouse whole brain\n');
                dataFileSurrogate = 'mouseSurrogate_N20000_rho8_d040.csv';
            end
        case 'human'
            fprintf(1,'Spatial maps for human cortex\n');
            dataFileSurrogate = 'humanSurrogate_N20000_rho8_d02000.csv';
        end
        nullMaps = dlmread(dataFileSurrogate,',',1,1);
    otherwise
        error('Unknown null type: ''%s''',whatNullType);
    end
else
    % Hack to specify a custom phenotype
    nullMaps = whatNullType;
    numNullSamples = 1;
end

%-------------------------------------------------------------------------------
% Enrichment of genes with a given null spatial map
categoryScores = cell(numGOCategories,1);
for i = 1:numGOCategories
    if beVerbose
        fprintf(1,'\n\n\nCategory %u/%u\n',i,numGOCategories);

        fprintf(1,'Looking in at %s:%s (%u)\n',GOTable.GOIDlabel{i},...
                            GOTable.GOName{i},GOTable.size(i));
    end

    % Match genes for this category:
    theGenesEntrez = GOTable.annotations{i};
    matchMe = find(ismember(geneInfo.entrez_id,theGenesEntrez));
    geneDataCategory = geneData(:,matchMe);
    numGenesCategory = length(matchMe);

    if beVerbose
        fprintf(1,'%u/%u genes from this GO category have matching records in the expression data\n',...
                            length(matchMe),length(theGenesEntrez));
    end

    % Compute the distribution of gene category scores for correlation with the null maps:
    scoresHere = nan(numGenesCategory,numNullSamples);
    for k = 1:numGenesCategory
        expressionVector = geneDataCategory(:,k);
        if numNullSamples==1
            scoresHere(k) = corr(nullMaps(:,1),expressionVector,'type',whatCorr,'rows','pairwise');
        else
            parfor j = 1:numNullSamples
                scoresHere(k,j) = corr(nullMaps(:,j),expressionVector,'type',whatCorr,'rows','pairwise');
            end
        end
    end

    % Aggregate gene-wise scores into an overall score for the GO category
    switch aggregateHow
    case 'mean'
        categoryScores{i} = nanmean(scoresHere,1);
    end
end

%-------------------------------------------------------------------------------
GOTable.categoryScores = categoryScores;

%-------------------------------------------------------------------------------
% Save out
if saveOut
    fileNameOut = sprintf('RandomNull_%u_%s-%s_%s_%s_%s.mat',numNullSamples,whatSpecies,...
                                                params.g.structFilter,whatNullType,whatCorr,aggregateHow);
    fileNameOut = fullfile('DataOutputs',fileNameOut);
    save(fileNameOut,'GOTable','params','-v7.3');
    fprintf(1,'Results of %u iterations saved to %s\n',numNullSamples,fileNameOut);
end

end
