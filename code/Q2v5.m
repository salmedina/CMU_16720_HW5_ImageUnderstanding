clear all;

% Load required data
Itest = rgb2gray(imread('../res/maneki-neko.jpg'));
load('template_images_neg.mat')
load('template_images_pos.mat')

boxWidth = 128;
template = tl_pos_neg(template_images_pos, template_images_neg);
[x,y,score,scale] = multiscale_detect(Itest, template, 15, 0.7);

figure; clf; imshow(img);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  d = floor(boxWidth/2)*scale(i);
  hold on; 
  h = rectangle('Position',[x(i)-d y(i)-d boxWidth boxWidth],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end