function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

featMap = hog(I);
[m,n,k] = size(featMap);
corrMap = zeros(m,n);

for i = 1:k
    corrMap = corrMap + imfilter(featMap(:,:,i),template(:,:,i));
end

% transform into (m*n)x3 matrix [x,y,s]
[xx, yy] = meshgrid(1:n, 1:m);
S = [(xx(:)*8-4) (yy(:)*8-4) corrMap(:)];

% sort by score
S = flipud(sortrows(S,3));

% Non-Maxima Suppression
d = 128; % for curPtBorder + otherPtBorder
res = zeros(ndet,3);
display(sprintf('Size of S = (%d, %d)', size(S,1), size(S,2)));
for i = 1:ndet
    if size(S,1) < 1
        break;
    end
    res(i,:) = S(1,:); %keep the top one
    curX = S(1,1);
    curY = S(1,2);
    
    minX = curX - d;
    maxX = curX + d;
    minY = curY - d;
    maxY = curY + d;
    sSz = size(S,1);
    keep = zeros(sSz,1);
    for j = 1:sSz
        tmpX = S(j,1);
        tmpY = S(j,2);
        keep(j) = tmpX < minX | tmpX > maxX | tmpY < minY | tmpY > maxY;
    end
    S = S(find(keep), :);
end

x = res(1:ndet,1);
y = res(1:ndet,2);
score = res(1:ndet,3);

end

