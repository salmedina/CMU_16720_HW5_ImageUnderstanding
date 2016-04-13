function select_patches()

numPos = 1;
numNeg = 100;

posImgList = {'../data/maneki-neko.jpg' ...
              '../data/maneki-neko.jpg' ...
              '../data/maneki-neko.jpg' ...
              '../data/maneki-neko.jpg' ...
              '../data/maneki-neko.jpg' };
negImgList = {'../data/test0.jpg' ...
              '../data/test1.jpg' ...
              '../data/test2.jpg' ...
              '../data/test3.jpg' ...
              '../data/test4.jpg'};

posPatches = cell(numPos);
negPatches = cell(numNeg);

% User selects all the positive patches from positive images
for posIdx = 1:numPos
    tmpImg = rgb2gray(imread(posImgList{posIdx}));
    imshow(tmpImg);
    selRect = getrect();
    posPatches{posIdx} = imcrop(tmpImg, selRect);
end

% Randomly extract patches from negative images
numRandPerImg = numNeg / length(negImgList);
for negImgPos = 1:length(negImgList)
    tmpImg = rgb2gray(imread(negImgList{negImgPos}));
    [rows,cols] = size(tmpImg);
    randIndices = randi((rows-128)*(cols-128), 1, numRandPerImg);
    [row,col] = ind2sub([rows-128, cols-128], randIndices);
    for i = 1:numRandPerImg
        patchIdx = (negImgPos-1)*numRandPerImg + i;
        display(patchIdx);
        negPatches{patchIdx} = tmpImg(row(i):row(i)+128, col(i):col(i)+128);
    end
end

% Resize positive examples to 128x128
for i = 1:numPos
    patch = posPatches{i};
    [dimSz, dimIdx] = max(size(patch));
    scale = 128/dimSz;
    scaledPatch = imresize(patch,'scale', scale);
    newDimSz = size(scaledPatch);
    newPatch = zeros(128,128);
    if dimIdx == 1
        offset = 64-newDimSz(2)/2;
        newPatch(:,offset:offset+newDimSz(2)) = scaledPatch(:,:);
    else
        offset = 64-newDimSz(1)/2;
        newPatch(offset:offset+newDimSz(1),:) = scaledPatch(:,:);
    end
    posPatches{i} = newPatch;
end

% Extract HoG from ...
% Positive patches
template_images_pos = cell(numPos);
for i = 1:numPos
    template_images_pos{i} = hog(posPatches{i});
end
% Negative patches
template_images_neg = cell(numNeg);
for i = 1:numNeg
    template_images_neg{i} = hog(negPatches{i});
end

% Store template images (16x16x9)
save('template_images_pos.mat','template_images_pos')
save('template_images_neg.mat','template_images_neg')

end

