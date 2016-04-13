function [x,y,score] = detection(I,template,ndet)
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
S = [(xx(:).*8-4) (yy(:).*8-4) corrMap(:)];

% sort by score
S = flipud(sortrows(S,3));

% Non-Maxima Suppression
d = size(template,2) / 2;
res = zeros(ndet,3);

for i = 1:ndet
    res(i,:) = S(1,:); %keep the top one
    curX = S(1,1);
    curY = S(1,2);
    minX = curX - d;
    maxX = curX + d;
    minY = curY - d;
    maxY = curY + d;
    sSz = size(S,1)
    keep = zeros(sSz);
    for i = 1:sSz
        tmpX = S(i,1);
        tmpY = S(i,2);
        keep(i) = tmpX < minX | tmpX > maxX | tmpY < minY | tmpY > maxY;
    end
    S = S(find(keep), :);
end

x = res(1:ndet,1);
y = res(1:ndet,2);
score = S(1:ndet,3);

end

