clear all;

% Load required data
display('Loading data');
Itest = rgb2gray(imread('../res/maneki-1.jpg'));
load('template_images_neg.mat')
load('template_images_pos.mat')

display('Preparing templates');
boxWidth = 128;
ndet = 1;
template = tl_pos_neg(template_images_pos, template_images_neg);
template = tl_lda(template_images_pos, template_images_neg, 0.001);

display(sprintf('Detecting top %d points', ndet));
[x,y,score,scale] = multiscale_detect(Itest, template, ndet, 0.75);

display('Displaying results');
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  d = floor((boxWidth/2)/scale(i));
  scaledBoxWidth = boxWidth/scale(i);
  hold on;
  h = rectangle('Position',[x(i)-d y(i)-d scaledBoxWidth scaledBoxWidth],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end

display('End of script');