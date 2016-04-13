clear all;

% Load required data
Itest = rgb2gray(imread('../res/maneki-neko.jpg'));
load('template_images_neg.mat')
load('template_images_pos.mat')

boxWidth = 128;
template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score] = detect(Itest,template,0);
draw_detection(Itest, x, y, boxWidth);