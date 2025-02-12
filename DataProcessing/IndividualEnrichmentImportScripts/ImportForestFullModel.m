function FilteredTable = ImportForestFullModel();

%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/benfulcher/GoogleDrive/Work/CurrentProjects/GeneExpressionEnrichment/DataSets/Forest/Forest2017_TableS3-PathwayEnrichment_FullModel.xlsx
%    Worksheet: Coral
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2017/10/27 16:17:04

%% Import the data
theFile = 'Forest2017_TableS3-PathwayEnrichment_FullModel.xlsx';
[~, ~, raw] = xlsread(theFile,'Coral');
raw = raw(2:end,:);
stringVectors = string(raw(:,[1,2,6,8,9,10]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[3,4,5,7]);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
ResultsTable = table;

%% Allocate imported array to column variable names
ResultsTable.UNIQUE_ID = stringVectors(:,1);
ResultsTable.GOTERM = stringVectors(:,2);
ResultsTable.TermPValue = data(:,1);
ResultsTable.TermPValueCorrectedwithBenjaminiHochberg = data(:,2);
ResultsTable.PercentageAssociatedGenes = data(:,3);
ResultsTable.AssociatedGenesFound = stringVectors(:,3);
ResultsTable.SUID = data(:,4);
ResultsTable.GOID = stringVectors(:,4);
ResultsTable.GOLevels = stringVectors(:,5);
ResultsTable.OntologySource = categorical(stringVectors(:,6));

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Just take BPs:
isBP = ResultsTable.OntologySource=='GO_BiologicalProcess-GOA_21.10.2016_16h30';
fprintf(1,'Filtering to %u GO-BP results\n',sum(isBP));
ResultsTable = ResultsTable(isBP,:);

% Now just take the necessary columns
pValCorr = ResultsTable.TermPValueCorrectedwithBenjaminiHochberg;
GOtoNumber = @(x)str2num(x(4:end));
GOID = cellfun(GOtoNumber,ResultsTable.GOID);
FilteredTable = sortrows(table(GOID,pValCorr),'pValCorr');

end
