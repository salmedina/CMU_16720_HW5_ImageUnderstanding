function [ heatMap  ] = calcHeatmap( I, template )

featMap = hog(I);
[m,n,k] = size(featMap);
heatMap = zeros(m,n);

for i = 1:k
    heatMap = heatMap + imfilter(featMap(:,:,i),template(:,:,i));
end

end

