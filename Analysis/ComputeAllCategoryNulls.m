function ComputeAllCategoryNulls(params,numNullSamples,whatNullType,whatCorr,aggregateHow)
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
switch whatNullType
case 'randomMap'
    % Generate as many random maps as null samples:
    nullMaps = rand(numAreas,numNullSamples);
case 'spatialLag'
    % Get the pre-computed surrogate data:
    switch whatSpecies
    case 'mouse'
        dataFileSurrogate = 'mouseSurrogate_N10000_rho8_d040.csv';
    case 'human'
        dataFileSurrogate = 'humanSurrogate_N10000_rho8_d02000.csv';
    end
    nullMaps = dlmread(dataFileSurrogate,',',1,1);
otherwise
    error('Unknown null type: ''%s''',whatNullType);
end

%-------------------------------------------------------------------------------
% Enrichment of genes with a given null spatial map
categoryScores = cell(numGOCategories,1);
for i = 1:numGOCategories
    fprintf(1,'\n\n\nCategory %u/%u\n',i,numGOCategories);

    fprintf(1,'Looking in at %s:%s (%u)\n',GOTable.GOIDlabel{i},...
                        GOTable.GOName{i},GOTable.size(i));

    % Match genes for this category:
    theGenesEntrez = GOTable.annotations{i};
    matchMe = find(ismember(geneInfo.entrez_id,theGenesEntrez));
    geneDataCategory = geneData(:,matchMe);
    numGenesCategory = length(matchMe);

    fprintf(1,'%u/%u genes from this GO category have matching records in the expression data\n',...
                            length(matchMe),length(theGenesEntrez));

    % Compute the distribution of gene category scores for correlation with the null maps:
    scoresHere = nan(numGenesCategory,numNullSamples);
    for k = 1:numGenesCategory
        expressionVector = geneDataCategory(:,k);
        parfor j = 1:numNullSamples
            scoresHere(k,j) = corr(nullMaps(:,j),expressionVector,'type',whatCorr,'rows','pairwise');
        end
    end
    switch aggregateHow
    case 'mean'
        categoryScores{i} = nanmean(scoresHere,1);
    end
end

%-------------------------------------------------------------------------------
GOTable.categoryScores = categoryScores;

%-------------------------------------------------------------------------------
% Save out
fileNameOut = sprintf('RandomNull_%u_%s_%s_%s_%s.mat',numNullSamples,whatSpecies,whatNullType,whatCorr,aggregateHow);
fileNameOut = fullfile('DataOutputs',fileNameOut);
save(fileNameOut,'GOTable','-v7.3');
fprintf(1,'Results of %u iterations saved to %s\n',numNullSamples,fileNameOut);

end
