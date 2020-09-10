function downloadComputedData()
% Download the computed files to the right directories
%-------------------------------------------------------------------------------

url = 'https://ndownloader.figshare.com/files/6294366';
fileName = 'HCTSA.mat';
outFileName = websave(fileName,url);
fprintf(1,['hctsa results for Drosophila melanogaster movement phenotyping ',...
            'downloaded from figshare to:\n%s\n'],outFileName);

end
