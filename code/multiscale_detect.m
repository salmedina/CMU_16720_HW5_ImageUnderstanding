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

allS=[];
curScale=1;
while(size(I,1) > 128)
    display(sprintf('Calculating for scale %0.5f',curScale));    
    % scale image accordingly
    scaledI = imresize(I, curScale);
    display(size(scaledI)); %PRINT image size
    curS = detect(I, template, ndet);
    allS=[allS; curS(1:min(100,size(curS,1)),:)];
    curScale = curScale * pyramid_ratio;
end

% sort by score
allS = flipud(sortrows(allS,3));

% Non-Maxima Suppression
display('Removing overlap by Non-Maxima Supression');
res = zeros(ndet,4);
d = 64;
for i = 1:ndet
    res(i,:) = allS(1,:); %keep the top one
    curX = allS(1,1);%/ allS(1,4);%apply ratio
    curY = allS(1,2);%/ allS(1,4);%apply ratio
    curD = d*allS(1,4);
    leftX = curX - d*curScale;
    rightX = curX + d*curScale;
    bottomY = curY - d*curScale;
    topY = curY + d;
    sSz = size(allS,1)
    keep = zeros(sSz,1);
    for j = 1:sSz
        tmpX = allS(j,1);%/ allS(1,4);%apply ratio
        tmpY = allS(j,2);%/ allS(1,4);%apply ratio
        tmpD = d * allS(j,4);
        keep(j) = tmpX < (leftX-tmpD) | ...
                  tmpX > (rightX+tmpD) | ...
                  tmpY < (bottomY-tmpD) | ...
                  tmpY > (topY+tmpD);
    end
    allS = allS(find(keep), :);
end

x = res(:,1);
y = res(:,2);
score = allS(:,3);
scale =allS(:,4);

end

