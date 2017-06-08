structureFilter = 'cortex';

[geneData,geneInfo,structInfo] = LoadMeG({'none','none'},'energy');
if strcmp(structureFilter,'cortex')
    keepStruct = strcmp(structInfo.divisionLabel,'Isocortex');
    geneData = geneData(keepStruct,:);
    structInfo = structInfo(keepStruct,:);
end
geneDataNorm = BF_NormalizeMatrix(geneData,'scaledSigmoid');
fprintf(1,'Computing PCs for %ux%u matrix...',size(geneDataNorm,1),size(geneDataNorm,2));
[pcCoeff, pcScore, ~, ~, ~] = pca(geneDataNorm,'NumComponents',2,'algorithm','als');
fprintf(1,'\n');

RegionScatterPlot(structInfo,pcScore(:,1),pcScore(:,2),'geneExp-PC1','geneExp-PC2','Pearson',true);

%-------------------------------------------------------------------------------
% Enrichment?
%-------------------------------------------------------------------------------
gScore = zeros(height(geneInfo),1);
for i = 1:height(geneInfo)
    gScore(i) = corr(pcScore(:,1),geneData(:,i),'type','Pearson','rows','pairwise');
end
[GOTable,geneEntrezAnnotations] = SingleEnrichment(gScore,geneInfo.entrez_id,'biological_process',[5,200],20000);
