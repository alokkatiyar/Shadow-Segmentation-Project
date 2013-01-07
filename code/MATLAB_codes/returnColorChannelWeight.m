function [imgRAvgDarker imgRAvgBrighter  imgGAvgDarker  imgGAvgBrighter  imgBAvgDarker  imgBAvgBrighter B]=returnColorChannelWeight(img , xGrad, yGrad,Hx, Hy, Ix, Iy, Jx, Jy,out,Rgrad,Ggrad,Bgrad)
%        yGrad(xEdge,yEdge)
%        xGrad(xEdge,yEdge)
      sizeGaussian = 3;
      for k = 0 : 2 
       l = 1;
       m = 1;   
       kernalConv = fspecial('gaussian', [ sizeGaussian sizeGaussian], 1);
       C = kernalConv;
       % divide the image into three colored channels
       imgR = img( :,:,1);
       imgG = img( :,:,2);
       imgB = img( :,:,3);
       [ lg, b ] = size(out);

       imshow(out);
        
       for i = 8 : lg - 8
           for j = 8 : b - 8
               if out(i,j)>0
               yEdge = j;
               xEdge = i;
               % canculate the gradient adirection at a particular
               % candidate edge
               angle = atan2(yGrad(xEdge,yEdge), xGrad(xEdge,yEdge));
               % canculate the gradient adirection at a particular
               % candidate edge in each of the three colored channel
               yr =  atan2(Hy(i,j), Hx(i,j));
               yg =  atan2(Iy(i,j), Ix(i,j));
               yb =  atan2(Jy(i,j), Jx(i,j));
               % calculate the magnitude of the gradient at the partcicular 
               % candidate edge pointfor each of the three color channels
                gradModR = Rgrad(i,j);
                gradModG = Ggrad(i,j);
                gradModB = Bgrad(i,j);

               % depending upon the direction of the gradient compute
               % the gaussian weighted average of the pixels on the lighter
               % and the brighter side for each of the three colored
               % channels. The window of Gaussian is take as 3, 5 ,7 for
               % the respective scales. The average is taken in two of the
               % four quadrants created by considering the pixel as the
               % origin( 1 quadrant fro th e darker shadow side and the other for the brighter 
               % sunlit side
               if ( angle > 0 && angle < 1.57 )
                   imgRAvgBrighter = conv2(double(imgR(xEdge - 3 : xEdge-1 , yEdge+1 : yEdge+3)),kernalConv);
                   imgRGaussAvgBrighter = imgRAvgBrighter(3,3);
                   imgRAvgDarker = conv2(double(imgR(xEdge+1 : xEdge + 3 , yEdge-3: yEdge-1  )),kernalConv);
                   imgRGaussAvgDarker = imgRAvgDarker(3,3);
                   imgGAvgBrighter = conv2(double(imgG( xEdge - 3 : xEdge-1 , yEdge+1 : yEdge+3 )),kernalConv);
                   imgGGaussAvgBrighter = imgGAvgBrighter(3,3);
                   imgGAvgDarker = conv2(double(imgG( xEdge+1 : xEdge + 3 , yEdge-3: yEdge-1)),kernalConv);
                   imgGGaussAvgDarker = imgGAvgDarker(3,3);
                   imgBAvgBrighter = conv2(double(imgB(xEdge - 3 : xEdge-1 , yEdge+1 : yEdge+3)), kernalConv);
                   imgBGaussAvgBrighter = imgBAvgBrighter(3,3);
                   imgBAvgDarker = conv2(double(imgB( xEdge+1 : xEdge + 3 , yEdge-3: yEdge-1)),kernalConv);
                   imgBGaussAvgDarker = imgBAvgDarker(3,3);
                   
              elseif( angle >= 1.57 && angle < 3.14 )  
                  
                   imgRAvgBrighter = conv2(double(imgR( xEdge - 3 : xEdge-1 , yEdge-3: yEdge-1)),kernalConv);
                   imgRGaussAvgBrighter = imgRAvgBrighter(3,3);
                   imgRAvgDarker = conv2(double(imgR( xEdge+1 : xEdge + 3 , yEdge+1:yEdge+3 )),kernalConv);
                   imgRGaussAvgDarker = imgRAvgDarker(3,3);
                   imgGAvgBrighter = conv2(double(imgG(xEdge - 3 : xEdge-1 , yEdge-3: yEdge-1)),kernalConv);
                   imgGGaussAvgBrighter = imgGAvgBrighter(3,3);
                   imgGAvgDarker = conv2(double(imgG( xEdge+1 : xEdge + 3 , yEdge+1:yEdge+3 )),kernalConv);
                   imgGGaussAvgDarker = imgGAvgDarker(3,3);
                   imgBAvgBrighter= conv2(double(imgB( xEdge - 3 : xEdge-1 , yEdge-3: yEdge-1)),kernalConv);
                   imgBGaussAvgBrighter = imgBAvgBrighter(3,3);
                   imgBAvgDarker = conv2(double(imgB(xEdge+1 : xEdge + 3 , yEdge+1:yEdge+3 )),kernalConv);
                   imgBGaussAvgDarker = imgBAvgDarker(3,3);
                   
               elseif ( angle < 0 && angle > -1.57 )    
                   imgRAvgDarker = conv2(double(imgR( xEdge - 3 : xEdge - 1 , yEdge-3 :yEdge-1)),kernalConv);
                   imgRGaussAvgDarker = imgRAvgDarker(3,3);
                   imgRAvgBrighter= conv2(double(imgR( xEdge+1: xEdge + 3 , yEdge+1: yEdge+3)),kernalConv);
                   imgRGaussAvgBrighter = imgRAvgBrighter(3,3);
                   imgGAvgDarker = conv2(double(imgG( xEdge - 3 : xEdge - 1 , yEdge-3 :yEdge-1)),kernalConv);
                   imgGGaussAvgDarker = imgGAvgDarker(3,3);
                   imgGAvgBrighter = conv2(double(imgG( xEdge+1: xEdge + 3 , yEdge+1: yEdge+3)),kernalConv);
                   imgGGaussAvgBrighter = imgGAvgBrighter(3,3);
                   imgBAvgDarker = conv2(double(imgB( xEdge - 3 : xEdge - 1 , yEdge-3 :yEdge-1)),kernalConv);
                   imgBGaussAvgDarker = imgBAvgDarker(3,3);
                   imgBAvgBrighter = conv2(double(imgB( xEdge+1: xEdge + 3 , yEdge+1: yEdge+3)),kernalConv);
                   imgBGaussAvgBrighter = imgBAvgBrighter(3,3);
                   
                   
               elseif  ( angle < -1.57 && angle > -3.14 )    

           
                   imgRAvgDarker= conv2(double(imgR( xEdge - 3 : xEdge-1 , yEdge + 1: yEdge + 3)),kernalConv);
                   imgRGaussAvgDarker = imgRAvgDarker(3,3);
                   imgRAvgBrighter = conv2(double(imgR( xEdge + 1 : xEdge + 3 , yEdge - 3: yEdge - 1 )),kernalConv);
                   imgRGaussAvgBrighter = imgRAvgBrighter(3,3);
                   imgGAvgDarker = conv2(double(imgG(xEdge - 3 : xEdge-1 , yEdge + 1: yEdge + 3 )),kernalConv);
                   imgGGaussAvgDarker = imgGAvgDarker(3,3);
                   imgGAvgBrighter = conv2(double(imgG( xEdge + 1 : xEdge + 3 , yEdge - 3: yEdge - 1 )),kernalConv);
                   imgGGaussAvgBrighter = imgGAvgBrighter(3,3);
                   imgBAvgDarker= conv2(double(imgB( xEdge - 3 : xEdge-1 , yEdge + 1: yEdge + 3)),kernalConv);
                   imgBGaussAvgDarker = imgBAvgDarker(3,3);
                   imgBAvgBrighter= conv2(double(imgB( xEdge + 1 : xEdge + 3 , yEdge - 3: yEdge - 1 )),kernalConv);
                   imgBGaussAvgBrighter = imgBAvgBrighter(3,3);
                                      
               end
               
           % computer the edge width for the fourth feature    
           choiceR = retChoiceForEdgeWidth( yr );
           wr = calculateWidth( sizeGaussian , choiceR , yEdge, xEdge, imgR);
           
           choiceG = retChoiceForEdgeWidth( yg );
           wg = calculateWidth( sizeGaussian , choiceG , yEdge, xEdge, imgG);
           
           choiceB = retChoiceForEdgeWidth( yb );
           wb = calculateWidth( sizeGaussian , choiceB , yEdge, xEdge, imgB);
           
           tr = imgRGaussAvgDarker / imgRGaussAvgBrighter;
           tg = imgGGaussAvgDarker / imgGGaussAvgBrighter;
           tb = imgBGaussAvgDarker / imgBGaussAvgBrighter;
%             if tb==0
%                 disp(tb);
%             end
           % save the feature vectors (36D ) in a M by 38 matrix , the
           % extra two columns are for saving the pixel numbers
           B(m,k*12+1) = (tr + tg + tb )/3;
           B(m,k*12+2) = tr / tb;
           B(m,k*12+3) = tg / tb;
           B(m,k*12+4) =  gradModR / imgRGaussAvgBrighter;
           B(m,k*12+5) =  gradModG / imgGGaussAvgBrighter;
           B(m,k*12+6) =  gradModB / imgBGaussAvgBrighter;
           B(m,k*12+7) = min( abs( yr -yg), 2*3.14 - abs( yr -yg ));
           B(m,k*12+8) = min( abs( yg -yb), 2*3.14 - abs( yg -yb ));
           B(m,k*12+9) = min( abs( yb -yr), 2*3.14 - abs( yb -yr ));
           B(m,k*12+10) = (wr + wg + wb)/3;
           B(m,k*12+11) = abs(wr / wg);
           B(m,k*12+12) = abs(wr / wb);
           if(k==2) 
             B(m,37 ) = i;
             B(m,38) = j;
           end
                          
           m = m + 1;
           end
         i
         end   
         
            
       end   
       sizeGaussian=  sizeGaussian + 2;
      end
      
      for a=1:size(B,1)
          for b=1:size(B,2)
              if B(a,b)== inf
                  B(a,b)=0;
%                   disp(B(a,b))
              end
          end
      end
       figure;imshow(out);
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
