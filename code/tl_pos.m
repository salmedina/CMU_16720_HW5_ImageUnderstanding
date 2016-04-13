function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix

T = vertcat(cellfun(@(x) x(:), template_images_neg));
template = reshape(mean(T,2), 16, 16, 9);

end