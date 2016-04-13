function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 

numNegImgs = length(template_images_neg);
T = zeros(16*16*9, numNegImgs);
% Form the neg data matrix
for i = 1:numNegImgs
   T(:,i) = template_images_neg{i}(:);
end

% Ti belongs to Rn and there are m images (columnwise data)
[n,m] = size(T);

% Calculate the covariance matrix
T_hat = mean(T,2);
Tc = T - (T_hat * ones(1,m));
Sigma = (1/m) * (Tc * Tc') - lambda*eye(n);

% Calculate the final template
Tpn = tl_pos_neg(template_images_pos, template_images_neg);
template = Sigma \ Tpn(:);
template = reshape(template, 16, 16, 9);

end