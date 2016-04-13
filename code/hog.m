function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orientation histograms for each block. ohist is of dimension (H/8)x(W/8)x9

% TODO:
% normalize the histogram so that sum over orientation bins is 1 for each block
% NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0.


% General vars
numBins = 9;
cellSz = 8;

[mag, ori] = mygradient(I);
[m, n] = size(I);

numHorzCell = floor(n/cellSz);
numVertCell = floor(m/cellSz);

magThres = 0.1*max(mag(:));
ohist = zeros(numVertCell, numHorzCell, numBins);

%orientation bin limits
lowerBound = -pi;
upperBound = pi;
angle_stride = (upperBound - lowerBound)/(numBins - 1);
binBounds = lowerBound:angle_stride:upperBound;

% Scan the cells and build histogram
for row = 0:(numVertCell-1)
    rowOffset = (row*cellSz)+1;
    for col = 0:(numHorzCell - 1)
        colOffset = (col*cellSz)+1;
        % Get indices of cell(row, col)
        rowIdx = rowOffset : (rowOffset + cellSz-1);
        colIdx = colOffset : (colOffset + cellSz-1);
        % Get the values of the cell
        cellMag = mag(rowIdx, colIdx);
        cellOri = ori(rowIdx, colIdx);
        % Fill up with the bin histograms
        filterOri = cellOri(cellMag > magThres);
        for k = 1:numBins
            histo = hist(filterOri(:),binBounds);
            if sum(histo) > 0
                histo = histo / sum(histo);
            end
            ohist(row+1, col+1, :) = reshape(histo, [1, 1, numel(histo)]);
        end
    end
end

ohist(isnan(ohist)) = 0;

end
