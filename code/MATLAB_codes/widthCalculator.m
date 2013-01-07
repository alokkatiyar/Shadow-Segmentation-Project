function [B ] = widthCalculator(nametxtFile, img , xGrad, yGrad,Hx, Hy, Ix, Iy, Jx, Jy,out,Rgrad,Ggrad,Bgrad)
   % divide the image into three colored channels 
   imgR = img( :,:,1);
   imgG = img( :,:,2);
   imgB = img( :,:,3);
   m = 1;
   % find the size of the candidate edge  matrix of the candidate edge
   % pixels
   [ lg, b ] = size(out);
   %open the textfile name provided from the command line for reading
   fid = fopen( nametxtFile,'r')
   % while we do not reach the end of the file
   while ~feof(fid)
     a =fgetl(fid);
     b =fgetl(fid);
     x = str2num(a);
     % find out the x co-ordinate of the image
     x = x +.5;
     % find out the y co-ordinate of the image
     y = str2num(b);
     y = y + .5;
     if( (x > 8 && y > 8))
         % this gap of 8 pixels has been kept to allow for the traversal in
         % both the directions along which the gradient has been resolved
         if ((y < 328) &&  ( x < 492))
             
             if( out( y , x) > 0)
                 
                 
                 i = y;
                 j = x;
                 % compute the direction of the gradient in each and every
                 % color channel
                 yr =  atan2(Hy(i,j), Hx(i,j));
                 yg =  atan2(Iy(i,j), Ix(i,j));
                 yb =  atan2(Jy(i,j), Jx(i,j)); 
                 % find out what is the direction along which the direction
                 % of our greadient in the red channel at a particular pixel
                 %can be roughly taken
                 choiceR = retChoiceForEdgeWidth( yr );
                 % calculate the width of the red channel 
                 wr = calculateWidth( 7 , choiceR , j, i, imgR);
   
                 %similarly comput the width of the green and blue channel
                 %respectively
                 choiceG = retChoiceForEdgeWidth( yg );
                 wg = calculateWidth( 7 , choiceG , j, i, imgG);
           
                 choiceB = retChoiceForEdgeWidth( yb );
                 wb = calculateWidth( 7 , choiceB , j, i, imgB);
                
                 % store the edge widths and the corresponding image
                 % coi-ordinates in a matrix
                 B(m,1) = wr;
                 B(m,2) = wg;
                 B(m,3) = wb;
                 B(m,4) = i;
                 B(m,5) = j;
                 m = m + 1;
             end
          end    
       end
    end
end

% This function resolves the gradient along one of the eight choices we
% make for computing the edge widths
function [ operationNum ] = retChoiceForEdgeWidth( gradientDir)
   % -22.5 to 22.5 treated to be lying along the horizonatl
   if( ( gradientDir < .3925 &&  gradientDir > 0) || (gradientDir > -.3925 &&  gradientDir <= 0))
       operationNum = 1;
   % >22.5 to 67.5 will be treated to be lying along 45 degree    
   elseif( gradientDir >= .3925 &&  gradientDir < 1.1775 )  
       operationNum = 2;
   % > 67.5 but less than 112.5  will be taken along the vertical dirn   
   elseif( gradientDir >= 1.1775 && gradientDir < 1.963 )
       operationNum = 3;
   % >112.5 but less than 157.5 taken along the 135 degree    
   elseif( gradientDir >= 1.963  && gradientDir < 2.748 )
       operationNum = 4;
   % > 157.5 and less than 180 or l greater than -180 but less than -157.5      
   elseif( ( gradientDir >= 2.748 && gradientDir < 3.14 ) || ( gradientDir <= -2.748 || gradientDir >= -3.14)) 
       operationNum = 5;
   % less than -22.5 but greater than -67.5   
   elseif( ( gradientDir <= -.3925 &&  gradientDir > -1.1775 ))
       operationNum = 6;
   % less than -67.5 but greater than -112.5    
   elseif( gradientDir <= -1.1775 && gradientDir > -1.963 )
       operationNum = 7; 
   %less than -112.5 but greater -than 157.5   
   elseif( gradientDir <= -1.963 && gradientDir > -2.748 )
       operationNum = 8;
    end    
end

% function which returns the width of the edge for a particular candidate
% edge
function [ width ] = calculateWidth( kernalSizeCurrent , choice ,yEdge,xEdge, imgChannel)
  switch choice
      case 1  
           % -22.5 to 22.5 considered to be lying along the horizontal
          max = imgChannel(xEdge , yEdge);
          % number of pixels upto which intensity continually increases
          % this is for the max side
          maxSide = 0;
          for i=  1 : kernalSizeCurrent
              if ( imgChannel(xEdge , (yEdge + i)) > max )
                  max = imgChannel(xEdge , (yEdge + i));
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
          end
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side

          min = imgChannel(xEdge,yEdge);
          minSide = 0;
          for i= 1 : kernalSizeCurrent
              if ( imgChannel( xEdge , (yEdge - i)) < min )
                  min = imgChannel( xEdge , (yEdge - i));
                  minSide = minSide + 1; 
              else 
                  break;
              end
          end
          
          width = maxSide + minSide + 1;
        
      case 2  
          % >22.5 to 67.5 will be treated along 45 degree   
          max = imgChannel(xEdge,yEdge);
          % number of pixels upto which intensity continually increases
          % this is for the max side
          maxSide = 0;
          for i=  1 :  kernalSizeCurrent
              if ( imgChannel( xEdge - i , yEdge + i) > max )
                  max = imgChannel( xEdge - i , yEdge + i);
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
          end  
          min = imgChannel(xEdge,yEdge);
          minSide = 0;
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
          for i= 1 :  kernalSizeCurrent
              if ( imgChannel((xEdge + i),(yEdge - 1)) < min )
                  min = imgChannel((xEdge + i),(yEdge - 1));
                  minSide = minSide + 1; 
              else 
                  break;
              end
          end
          width = maxSide + minSide + 1;
       
      case 3 
          % > 67.5 but less than 112.5  will be taken along the vertical dirn  
           % number of pixels upto which intensity continually increases
          % this is for the max side
          max = imgChannel(xEdge,yEdge);
          maxSide = 0;
          for i=  1 :  kernalSizeCurrent
              if ( imgChannel((xEdge - i), yEdge) > max )
                   max = imgChannel((xEdge - i), yEdge);
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
          end  
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
          min = imgChannel(xEdge,yEdge);
          minSide = 0;
          for i= 1 : kernalSizeCurrent
              if ( imgChannel((xEdge + i), yEdge) < min )
                  min = imgChannel((xEdge + i), yEdge);
                  minSide = minSide + 1; 
              else 
                  break;
              end
         end
         width = maxSide + minSide + 1;
         
      case 4  
          % number of pixels upto which intensity continually increases
          % this is for the max side
          % >112.5 but less than 157.5 taken along the 135 degree 
          max = imgChannel(xEdge,yEdge);
          maxSide = 0;
          for i=  1 :  kernalSizeCurrent
              if ( imgChannel( xEdge - i , yEdge - i) > max )
                  max = imgChannel( xEdge - i , yEdge - i);
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
          end  
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
          min = imgChannel(xEdge,yEdge);
          minSide = 0;
          for i= 1 :  kernalSizeCurrent
              if ( imgChannel((xEdge + i), (yEdge + 1)) < min )
                  min = imgChannel((xEdge + i), (yEdge + 1));
                  minSide = minSide + 1; 
              else 
                  break;
              end
          end
          width = maxSide + minSide + 1;
      
      case 5      
           % > 157.5 and less than 180 or  greater than -180 but less than -157.5 
           % number of pixels upto which intensity continually increases
           % this is for the max side
           max = imgChannel(xEdge,yEdge);
           maxSide = 0;
           for i=  1 : kernalSizeCurrent
              if ( imgChannel(xEdge , (yEdge - i)) > max )
                  max = imgChannel(xEdge , (yEdge - i));
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
           end  
           % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
           min = imgChannel(xEdge,yEdge);
           minSide = 0;
           for i= 1 : kernalSizeCurrent
              if ( imgChannel(xEdge , (yEdge + i)) < min )
                  min = imgChannel(xEdge , (yEdge + i));
                  minSide = minSide + 1; 
              else 
                  break;
              end
           end
           width = maxSide + minSide + 1;   
           
      case 6     
           % less than -22.5 but greater than -67.5   
            max = imgChannel(xEdge,yEdge);
            maxSide = 0;
            % number of pixels upto which intensity continually increases
            % this is for the max side
            for i =  1 :  kernalSizeCurrent
              if ( imgChannel( xEdge + i , yEdge + i) > max )
                  max = imgChannel( xEdge + i , yEdge + i);
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
            end  
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
           min = imgChannel(xEdge,yEdge);
           minSide = 0;
           for i= 1 :  kernalSizeCurrent
              if ( imgChannel((xEdge - i), (yEdge - 1)) < min )
                  min = mgChannel((xEdge - i), (yEdge - 1));
                  minSide = minSide + 1; 
              else 
                  break;
              end
           end
           width = maxSide + minSide + 1;
           
      case 7 
           % less than -67.5 but greater than -112.5    this implies
           % calculate width along vertical
           % number of pixels upto which intensity continually increases
           % this is for the max side
            max = imgChannel(xEdge,yEdge);
            maxSide = 0;
            for i =  1 :  kernalSizeCurrent
               if ( imgChannel((xEdge + i), yEdge) > max )
                  max =  imgChannel((xEdge + i), yEdge);
                  maxSide = maxSide + 1; 
               else 
                  break;
               end   
            end  
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side 
           min = imgChannel(xEdge,yEdge);
           minSide = 0;
           for i= 1 : kernalSizeCurrent
               if ( imgChannel((xEdge - i) , yEdge) < min )
                  min =  imgChannel((xEdge - i) , yEdge);
                  minSide = minSide + 1; 
               else 
                  break;
               end
           end
          width = maxSide + minSide + 1;
      case 8 
          %less than -112.5 but greater -than 157.5   
          % number of pixels upto which intensity continually increases
          % this is for the max side
          max = imgChannel(xEdge,yEdge);
          maxSide = 0;
          for i=  1 :  kernalSizeCurrent
              if ( imgChannel( xEdge + i , yEdge - i) > max )
                  max = imgChannel( xEdge + i , yEdge - i);
                  maxSide = maxSide + 1; 
              else 
                  break;
              end   
          end  
          % numbetr of pixels upto which intensity continually decreases
          % this is for the min side
          min = imgChannel(xEdge,yEdge);
          minSide = 0;
          for i= 1 :  kernalSizeCurrent
              if ( imgChannel((xEdge - i) , (yEdge + 1)) < min )
                  min = imgChannel((xEdge - i) , (yEdge + 1));
                  minSide = minSide + 1; 
              else 
                  break;
              end
          end
          width = maxSide + minSide + 1;
   end
end 
