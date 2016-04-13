function [x, y, score, scale] = multiscale_detect(I, template, ndet, pyramid_ratio)
% input:
%     image - test image.
%     template - [16 x 16x 9] matrix.
%     ndet - the number of return values.
%     pyramid_ratio - image scale resize ratio
% output:
%      det_res - [ndet x 3] matrix
%                column one is the x coordinate
%                column two is the y coordinate
%                column three is the scale, i.e. 1, 0.7 or 0.49 ..
filter_size =128;
allS=[];
curScale=1;
while(size(I,1)>filter_size)
    featMap = hog(I);
    [m,n,k] = size(featMap);
    corrMap = zeros(m,n);
    for i = 1:k
        corrMap = corrMap + imfilter(featMap(:,:,i),template(:,:,i));
    end
    [xx, yy] = meshgrid(1:n, 1:m);
    S = [(xx(:).*8-4)/curScale (yy(:).*8-4)/curScale corrMap(:)];
    S = [S ones(size(S,1),1)*curScale];
    allS=[allS; S];
    I = imresize(I, pyramid_ratio);
    curScale=curScale*pyramid_ratio
end
% transform into (m*n)x3 matrix [x,y,s]


% sort by score
allS = flipud(sortrows(allS,3));

% Non-Maxima Suppression
d = 128;
res = zeros(ndet,4);

for i = 1:ndet
    res(i,:) = allS(1,:); %keep the top one
    curX = allS(1,1);%/ allS(1,4);%apply ratio
    curY = allS(1,2);%/ allS(1,4);%apply ratio
    minX = curX - d;
    maxX = curX + d;
    minY = curY - d;
    maxY = curY + d;
    sSz = size(allS,1)
    keep = zeros(sSz,1);
    for j = 1:sSz
        tmpX = allS(j,1);%/ allS(1,4);%apply ratio
        tmpY = allS(j,2);%/ allS(1,4);%apply ratio
        keep(j) = tmpX < minX | tmpX > maxX | tmpY < minY | tmpY > maxY;
    end
    allS = allS(find(keep), :);
end

x = res(1:ndet,1);
y = res(1:ndet,2);
score = allS(1:ndet,3);
scale =allS(1:ndet,4);

end

