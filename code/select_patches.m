function select_patches()

numPos = 5;
numNeg = 100;

posImgList = {'../res/maneki-neko.jpg' ...
              '../res/maneki-neko.jpg' ...
              '../res/maneki-neko.jpg' ...
              '../res/maneki-neko.jpg' ...
              '../res/maneki-neko.jpg' };
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
        negPatches{patchIdx} = tmpImg(row(i):row(i)+128, col(i):col(i)+128);
    end
end

% Resize positive examples to 128x128
for i = 1:numPos
    patch = posPatches{i};
    [maxDimSz, maxDimIdx] = max(size(patch));
    [minDimSz, minDimIdx] = min(size(patch));
    padSz = floor((maxDimSz-minDimSz)/2);
    if maxDimIdx == 1
        padding = [0 padSz];
    else
        padding = [padSz 0];
    end
    patch = padarray(patch, padding);
    scaledPatch = imresize(patch,[128 128]);
    
    posPatches{i} = scaledPatch;
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

display('Finished template processing');
end

