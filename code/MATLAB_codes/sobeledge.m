function [solution3,Gx,Gy]=sobeledge(image)
I=image;
%disp('Hello');
%declaring padded image
for i=1:size(I,1)+2
    for j=1:size(I,2)+2
        nI(i,j)=0;
    end
end

%padding(duplicating) the border values and declaring the output
for i=1:size(I,1)
    for j=1:size(I,2)
        nI(i+1,j+1)=I(i,j);
        if i==1 || i==size(I,1)|| j==1 || j==size(I,2)
            nI(i,j)=I(i,j);
        end
        solution3(i,j)=0;
    end
end

%Applying the Sobel Mask
for i=2:size(nI,1)-1
    for j=2:size(nI,2)-1
        Gy(i-1,j-1)=-nI(i+1,j-1)+nI(i-1,j-1)-2*(nI(i+1,j)-nI(i-1,j))-nI(i+1,j+1)+nI(i-1,j+1);
        Gx(i-1,j-1)=-nI(i-1,j-1)+nI(i-1,j+1)+2*(-nI(i,j-1)+nI(i,j+1))-nI(i+1,j-1)+nI(i+1,j+1);
        solution3(i-1,j-1)=sqrt(Gx(i-1,j-1)^2+Gy(i-1,j-1)^2);
    end
end

%Scaling to 8-bit value
Gy=(Gy/max(max(Gy)))*256;
Gx=(Gx/max(max(Gx)))*256;
solution3=(solution3/max(max(solution3)))*256;

%Thresholding
% for i=1:size(I,1)
%     for j=1:size(I,2)
%         if solution3(i,j)<75
%             solution3(i,j)=0;
%         else
%             solution3(i,j)=255;
%         end
%     end
% end
%Displaying the result
% figure,imshow(solution3,[]);
% title('OUTPUT OF SOBEL EDGE DETECTOR');
