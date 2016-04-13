function [ ] = draw_detection(img, x, y, boxWidth)
% Draws the bounding boxes of the points given in x, y

[ndet, ~] = size(x);
d = floor(boxWidth/2);

figure; clf; imshow(img);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on; 
  h = rectangle('Position',[x(i)-d y(i)-d boxWidth boxWidth],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
  hold off;
end

end

