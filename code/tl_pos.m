function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix

nTpl = length(template_images_pos);
v = template_images_pos{1}(:);
for i = 2:nTpl
    v = v + template_images_pos{i}(:);
end
v = v ./ nTpl;
template = reshape(v, 16, 16, 9);

end