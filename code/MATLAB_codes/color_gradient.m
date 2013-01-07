function [out Hx Hy Ix Iy Jx Jy gradX gradY Rgrad Ggrad Bgrad]=color_gradient(in)
% computes the gradient of a color image
% Divide the image in three separate colored channel
R=double(in(:,:,1));
G=double(in(:,:,2));
B=double(in(:,:,3));
% convert the image to grayscale, this is done to find the overall gradient
% at a particular pixel of the image
x=rgb2gray(in);
% Compute the x and y component of the gradient direction as well as the the
% magnitude of the gradient for each of the three colored channels
[Rgrad Rx Ry]=sobeledge(R);
[Ggrad Gx Gy]=sobeledge(G);
[Bgrad Bx By]=sobeledge(B);
[zx xx xy]=sobeledge(x);

% apply canny edge detection algorithm to filter out the candidate shadow
% edge pixels
out=edge(x,'canny');

% assing values to the return variables

Hx = Rx;
Hy = Ry;



Ix = Gx;
Iy = Gy;
% 

Jx = Bx;
Jy = By;

gradX = xx;
gradY = xy ;

%out=sqrt(Rx.*Rx+Ry.*Ry+Gx.*Gx+Gy.*Gy+Bx.*Bx+By.*By+eps);