clear all;

% Load required data
Itest = rgb2gray(imread('../res/maneki-neko.jpg'));
load('template_images_neg.mat')
load('template_images_pos.mat')

boxWidth = 128;
display()
template = tl_lda(template_images_pos, template_images_neg, 0.1);
[x,y,score] = detect(Itest,template,15);
draw_detection(Itest, x, y, boxWidth);