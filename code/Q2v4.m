clear all;

% Load required data
Itest = rgb2gray(imread('../res/maneki-1.jpg'));
load('template_images_neg.mat')
load('template_images_pos.mat')

boxWidth = 128;
template = tl_lda(template_images_pos, template_images_neg, 0.001);
[x,y,score] = detect(Itest,template,1);
draw_detection(Itest, x, y, boxWidth);