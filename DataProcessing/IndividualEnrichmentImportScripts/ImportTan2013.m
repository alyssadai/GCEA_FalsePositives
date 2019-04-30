function FilteredTable = ImportTan2013()
%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/benfulcher/GoogleDrive/Work/CurrentProjects/GeneExpressionEnrichment/DataSets/Tan2013-table-s6-david-200pos-transport.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/10/27 16:47:53

%% Initialize variables.
filename = 'Tan2013-table-s6-david-200pos-transport.csv';
delimiter = '\t';
startRow = 2;

%% Format for each line of text:
%   column1: categorical (%C)
%	column2: text (%s)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: categorical (%C)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%C%s%f%f%f%C%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
ResultsTable = table(dataArray{1:end-1}, 'VariableNames', {'Category','Term','Count','VarName4','PValue','Genes','ListTotal','PopHits','PopTotal','FoldEnrichment','Bonferroni','Benjamini','FDR'});

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Just take BPs:
isBP = ResultsTable.Category=='GOTERM_BP_FAT';
fprintf(1,'Filtering to %u GO-BP results\n',sum(isBP));
ResultsTable = ResultsTable(isBP,:);

% Now just take the necessary columns
pValCorr = ResultsTable.Benjamini;
GOtoNumber = @(x)str2num(x(4:10));
GOID = cellfun(GOtoNumber,ResultsTable.Term);
FilteredTable = sortrows(table(GOID,pValCorr),'pValCorr');


end
