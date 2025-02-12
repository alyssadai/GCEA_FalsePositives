function VisualizeSurrogateMaps(whatSpecies)
% Visualizations of phenotype maps in space, when d0 is varying across a range
%-------------------------------------------------------------------------------

if nargin < 1
    whatSpecies = 'mouse';
end
%-------------------------------------------------------------------------------

switch whatSpecies
case 'human'
    params = GiveMeDefaultParams(whatSpecies);
    distMat = GiveMeDistanceMatrix(params);
    fileName = 'humanSurrogate_rho8.csv';
case 'mouse'
    params = GiveMeDefaultParams(whatSpecies);
    distMat = GiveMeDistanceMatrix(params);
    fileName = 'mouseSurrogate_rho10.csv';
end

% Read in the data from the surrogate method:
M = dlmread(fileName,',',1);
d0 = M(:,1);
maps = M(:,2:end);

% Filter out bad maps:
isBadMap = all(maps==0,2);
if any(isBadMap)
    maps = maps(~isBadMap,:);
    d0 = d0(~isBadMap);
    fprintf(1,'Removed %u bad map\n',sum(isBadMap));
else
    fprintf(1,'All good maps!\n');
end

% Compute 2-d projection of data:
coOrdsXY = mdscale(distMat,2);

% Plot each surrogate spatial map:
numMaps = min(size(maps,2),10);
for j = 1:numMaps
    subplot(2,ceil(numMaps/2),j)
    mapNorm = zscore(maps(:,j));
    scatter(coOrdsXY(:,1),coOrdsXY(:,2),25,mapNorm,'filled')
    colormap([flipud(BF_getcmap('blues',9));1,1,1;BF_getcmap('reds',9)])
    xlabel('spatialAxis1')
    ylabel('spatialAxis2')
    title(sprintf('d0 = %.3f',d0(j)))
end

cB = colorbar;
cB.Label.String = 'Surrogate map';

end
