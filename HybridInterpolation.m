function dImage = HybridInterpolation(bayerImage)
    tic
    bayerPlane = bayerImage(:,:,1) + bayerImage(:,:,2) + bayerImage(:,:,3); 
    
    greenPlane = green(double(bayerPlane)) + double(bayerImage(:,:,2));
    
    dImage(:,:,2) = greenPlane;
    dImage(:,:,1) = red(double(bayerImage(:,:,1)),greenPlane);
    dImage(:,:,3) = blue(double(bayerImage(:,:,3)),greenPlane);

    dImage = uint8(postProcessing(double(dImage)));
    toc
end
 
function g = green(bayerPlane)
    
    bayerPlane = prepareForConv(bayerPlane);
    [y, x] = size(bayerPlane);
    
    g = zeros(y, x);
    
    for i = 4:2:y-3
        for j = 4:2:x-3
            
            g1 = bayerPlane(i-1,j) + (bayerPlane(i,j) - bayerPlane(i-2,j))/2;
            g2 = bayerPlane(i,j-1) + (bayerPlane(i,j) - bayerPlane(i,j-2))/2;
            g3 = bayerPlane(i,j+1) + (bayerPlane(i,j) - bayerPlane(i,j+2))/2;
            g4 = bayerPlane(i+1,j) + (bayerPlane(i,j) - bayerPlane(i+2,j))/2;
            
%             top direction
            alpha1 = 1 + abs(bayerPlane(i+1,j)-bayerPlane(i-1,j)) + abs(bayerPlane(i-1,j)-bayerPlane(i-3,j)) + abs(bayerPlane(i,j)- bayerPlane(i-2,j));
            alpha1 = alpha1 + abs(bayerPlane(i,j-1)-bayerPlane(i-2,j-1))/2 + abs(bayerPlane(i,j+1)-bayerPlane(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(bayerPlane(i,j+1)-bayerPlane(i,j-1)) + abs(bayerPlane(i,j-1)-bayerPlane(i,j-3)) + abs(bayerPlane(i,j)- bayerPlane(i,j-2));
            alpha2 = alpha2 + abs(bayerPlane(i-1,j)-bayerPlane(i-1,j-2))/2 + abs(bayerPlane(i+1,j)-bayerPlane(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(bayerPlane(i,j-1)-bayerPlane(i,j+1)) + abs(bayerPlane(i,j+1)-bayerPlane(i,j+3)) + abs(bayerPlane(i,j)- bayerPlane(i,j+2));
            alpha3 = alpha3 + abs(bayerPlane(i-1,j)-bayerPlane(i-1,j+2))/2 + abs(bayerPlane(i+1,j)-bayerPlane(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(bayerPlane(i-1,j)-bayerPlane(i+1,j)) + abs(bayerPlane(i+1,j)-bayerPlane(i+3,j)) + abs(bayerPlane(i,j)- bayerPlane(i+2,j));
            alpha4 = alpha4 + abs(bayerPlane(i,j-1)-bayerPlane(i+2,j-1))/2 + abs(bayerPlane(i,j+1)-bayerPlane(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            g(i,j) = (alpha1*g1 + alpha2*g2 + alpha3*g3 + alpha4*g4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end    
    
    for i = 5:2:y-3
        for j = 5:2:x-3
            
            g1 = bayerPlane(i-1,j) + (bayerPlane(i,j) - bayerPlane(i-2,j))/2;
            g2 = bayerPlane(i,j-1) + (bayerPlane(i,j) - bayerPlane(i,j-2))/2;
            g3 = bayerPlane(i,j+1) + (bayerPlane(i,j) - bayerPlane(i,j+2))/2;
            g4 = bayerPlane(i+1,j) + (bayerPlane(i,j) - bayerPlane(i+2,j))/2;
            
%             top direction
            alpha1 = 1 + abs(bayerPlane(i+1,j)-bayerPlane(i-1,j)) + abs(bayerPlane(i-1,j)-bayerPlane(i-3,j)) + abs(bayerPlane(i,j)- bayerPlane(i-2,j));
            alpha1 = alpha1 + abs(bayerPlane(i,j-1)-bayerPlane(i-2,j-1))/2 + abs(bayerPlane(i,j+1)-bayerPlane(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(bayerPlane(i,j+1)-bayerPlane(i,j-1)) + abs(bayerPlane(i,j-1)-bayerPlane(i,j-3)) + abs(bayerPlane(i,j)- bayerPlane(i,j-2));
            alpha2 = alpha2 + abs(bayerPlane(i-1,j)-bayerPlane(i-1,j-2))/2 + abs(bayerPlane(i+1,j)-bayerPlane(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(bayerPlane(i,j-1)-bayerPlane(i,j+1)) + abs(bayerPlane(i,j+1)-bayerPlane(i,j+3)) + abs(bayerPlane(i,j)- bayerPlane(i,j+2));
            alpha3 = alpha3 + abs(bayerPlane(i-1,j)-bayerPlane(i-1,j+2))/2 + abs(bayerPlane(i+1,j)-bayerPlane(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(bayerPlane(i-1,j)-bayerPlane(i+1,j)) + abs(bayerPlane(i+1,j)-bayerPlane(i+3,j)) + abs(bayerPlane(i,j)- bayerPlane(i+2,j));
            alpha4 = alpha4 + abs(bayerPlane(i,j-1)-bayerPlane(i+2,j-1))/2 + abs(bayerPlane(i,j+1)-bayerPlane(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            g(i,j) = (alpha1*g1 + alpha2*g2 + alpha3*g3 + alpha4*g4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end  
    
    g = resultOfConv(g);
        
end

function r = red(bayerRed, g)
    
    bayerRed = prepareForConv(bayerRed);
    g = prepareForConv(g);
    
    [y, x] = size(bayerRed);
    
    r = bayerRed;
    
    for i = 4:2:y-3
        for j = 4:2:x-3
            
            r1 = r(i-1,j-1) + (g(i,j) - g(i-1,j-1));
            r2 = r(i-1,j+1) + (g(i,j) - g(i-1,j+1));
            r3 = r(i+1,j-1) + (g(i,j) - g(i+1,j-1));
            r4 = r(i+1,j+1) + (g(i,j) - g(i+1,j+1));
            
%             top-left direction
            alpha1 = 1 + abs(g(i-2,j-2)-g(i-1,j-1)) + abs(g(i-1,j-1)-g(i,j));
            alpha1 = alpha1 + abs(g(i-1,j-2)-g(i,j-1))/2 + abs(g(i-2,j-1)-g(i-1,j))/2;
            alpha1 = 1 / alpha1;
%             top-right direction
            alpha2 = 1 + abs(g(i-2,j+2)-g(i-1,j+1)) + abs(g(i-1,j+1)-g(i,j));
            alpha2 = alpha2 + abs(g(i-2,j+1)-g(i-1,j))/2 + abs(g(i-1,j+2)-g(i,j+1))/2;
            alpha2 = 1 / alpha2;
%             bottom-left direction
            alpha3 = 1 + abs(g(i+2,j-2)-g(i+1,j-1)) + abs(g(i+1,j-1)-g(i,j));
            alpha3 = alpha3 + abs(g(i+1,j-2)-g(i,j-1))/2 + abs(g(i+2,j-1)-g(i+1,j))/2;
            alpha3 = 1 / alpha3;
%             bottom-right direction
            alpha4 = 1 + abs(g(i+2,j+2)-g(i+1,j+1)) + abs(g(i+1,j+1)-g(i,j));
            alpha4 = alpha4 + abs(g(i+2,j+1)-g(i+1,j))/2 + abs(g(i+1,j+2)-g(i,j+1))/2;
            alpha4 = 1 / alpha4;
            
            r(i,j) = (alpha1*r1 + alpha2*r2 + alpha3*r3 + alpha4*r4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end    
    
    for i = 4:2:y-3
        for j = 5:2:x-3
            
            r1 = r(i-1,j) + (g(i,j) - g(i-1,j));
            r2 = r(i,j-1) + (g(i,j) - g(i,j-1));
            r3 = r(i,j+1) + (g(i,j) - g(i,j+1));
            r4 = r(i+1,j) + (g(i,j) - g(i+1,j));
            
%             top direction
            alpha1 = 1 + abs(g(i,j)-g(i-1,j)) + abs(g(i-1,j)-g(i-2,j)) + abs(g(i,j-1)- g(i-1,j-1))/2;
            alpha1 = alpha1 + abs(g(i-1,j-1)- g(i-2,j-1))/2 + abs(g(i,j+1)-g(i-1,j+1))/2 + abs(g(i-1,j+1)-g(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(g(i,j)-g(i,j-1)) + abs(g(i,j-1)-g(i,j-2)) + abs(g(i-1,j)- g(i-1,j-1))/2;
            alpha2 = alpha2 + abs(g(i-1,j-1)- g(i-1,j-2))/2 + abs(g(i+1,j)-g(i+1,j-1))/2 + abs(g(i+1,j-1)-g(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(g(i,j)-g(i,j+1)) + abs(g(i,j+1)-g(i,j+2)) + abs(g(i-1,j)- g(i-1,j+1))/2;
            alpha3 = alpha3 + abs(g(i-1,j+1)- g(i-1,j+2))/2 + abs(g(i+1,j)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(g(i,j)-g(i+1,j)) + abs(g(i+1,j)-g(i+2,j)) + abs(g(i,j-1)- g(i+1,j-1))/2;
            alpha4 = alpha4 + abs(g(i+1,j-1)- g(i+2,j-1))/2 + abs(g(i,j+1)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            r(i,j) = (alpha1*r1 + alpha2*r2 + alpha3*r3 + alpha4*r4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end  
    
    for i = 5:2:y-3
        for j = 4:2:x-3
            
            r1 = r(i-1,j) + (g(i,j) - g(i-1,j));
            r2 = r(i,j-1) + (g(i,j) - g(i,j-1));
            r3 = r(i,j+1) + (g(i,j) - g(i,j+1));
            r4 = r(i+1,j) + (g(i,j) - g(i+1,j));
            
%             top direction
            alpha1 = 1 + abs(g(i,j)-g(i-1,j)) + abs(g(i-1,j)-g(i-2,j)) + abs(g(i,j-1)- g(i-1,j-1))/2;
            alpha1 = alpha1 + abs(g(i-1,j-1)- g(i-2,j-1))/2 + abs(g(i,j+1)-g(i-1,j+1))/2 + abs(g(i-1,j+1)-g(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(g(i,j)-g(i,j-1)) + abs(g(i,j-1)-g(i,j-2)) + abs(g(i-1,j)- g(i-1,j-1))/2;
            alpha2 = alpha2 + abs(g(i-1,j-1)- g(i-1,j-2))/2 + abs(g(i+1,j)-g(i+1,j-1))/2 + abs(g(i+1,j-1)-g(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(g(i,j)-g(i,j+1)) + abs(g(i,j+1)-g(i,j+2)) + abs(g(i-1,j)- g(i-1,j+1))/2;
            alpha3 = alpha3 + abs(g(i-1,j+1)- g(i-1,j+2))/2 + abs(g(i+1,j)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(g(i,j)-g(i+1,j)) + abs(g(i+1,j)-g(i+2,j)) + abs(g(i,j-1)- g(i+1,j-1))/2;
            alpha4 = alpha4 + abs(g(i+1,j-1)- g(i+2,j-1))/2 + abs(g(i,j+1)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            r(i,j) = (alpha1*r1 + alpha2*r2 + alpha3*r3 + alpha4*r4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end  
    
    r = resultOfConv(r);
        
end

function b = blue(bayerBlue, g)
    
    bayerBlue = prepareForConv(bayerBlue);
    g = prepareForConv(g);
    
    [y, x] = size(bayerBlue);
    
    b = bayerBlue;
    
    for i = 5:2:y-3
        for j = 5:2:x-3
            
            b1 = b(i-1,j-1) + (g(i,j) - g(i-1,j-1));
            b2 = b(i-1,j+1) + (g(i,j) - g(i-1,j+1));
            b3 = b(i+1,j-1) + (g(i,j) - g(i+1,j-1));
            b4 = b(i+1,j+1) + (g(i,j) - g(i+1,j+1));
            
%             top-left direction
            alpha1 = 1 + abs(g(i-2,j-2)-g(i-1,j-1)) + abs(g(i-1,j-1)-g(i,j));
            alpha1 = alpha1 + abs(g(i-1,j-2)-g(i,j-1))/2 + abs(g(i-2,j-1)-g(i-1,j))/2;
            alpha1 = 1 / alpha1;
%             top-right direction
            alpha2 = 1 + abs(g(i-2,j+2)-g(i-1,j+1)) + abs(g(i-1,j+1)-g(i,j));
            alpha2 = alpha2 + abs(g(i-2,j+1)-g(i-1,j))/2 + abs(g(i-1,j+2)-g(i,j+1))/2;
            alpha2 = 1 / alpha2;
%             bottom-left direction
            alpha3 = 1 + abs(g(i+2,j-2)-g(i+1,j-1)) + abs(g(i+1,j-1)-g(i,j));
            alpha3 = alpha3 + abs(g(i+1,j-2)-g(i,j-1))/2 + abs(g(i+2,j-1)-g(i+1,j))/2;
            alpha3 = 1 / alpha3;
%             bottom-right direction
            alpha4 = 1 + abs(g(i+2,j+2)-g(i+1,j+1)) + abs(g(i+1,j+1)-g(i,j));
            alpha4 = alpha4 + abs(g(i+2,j+1)-g(i+1,j))/2 + abs(g(i+1,j+2)-g(i,j+1))/2;
            alpha4 = 1 / alpha4;
            
            b(i,j) = (alpha1*b1 + alpha2*b2 + alpha3*b3 + alpha4*b4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end    
    
    for i = 4:2:y-3
        for j = 5:2:x-3
            
            b1 = b(i-1,j) + (g(i,j) - g(i-1,j));
            b2 = b(i,j-1) + (g(i,j) - g(i,j-1));
            b3 = b(i,j+1) + (g(i,j) - g(i,j+1));
            b4 = b(i+1,j) + (g(i,j) - g(i+1,j));
            
%             top direction
            alpha1 = 1 + abs(g(i,j)-g(i-1,j)) + abs(g(i-1,j)-g(i-2,j)) + abs(g(i,j-1)- g(i-1,j-1))/2;
            alpha1 = alpha1 + abs(g(i-1,j-1)- g(i-2,j-1))/2 + abs(g(i,j+1)-g(i-1,j+1))/2 + abs(g(i-1,j+1)-g(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(g(i,j)-g(i,j-1)) + abs(g(i,j-1)-g(i,j-2)) + abs(g(i-1,j)- g(i-1,j-1))/2;
            alpha2 = alpha2 + abs(g(i-1,j-1)- g(i-1,j-2))/2 + abs(g(i+1,j)-g(i+1,j-1))/2 + abs(g(i+1,j-1)-g(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(g(i,j)-g(i,j+1)) + abs(g(i,j+1)-g(i,j+2)) + abs(g(i-1,j)- g(i-1,j+1))/2;
            alpha3 = alpha3 + abs(g(i-1,j+1)- g(i-1,j+2))/2 + abs(g(i+1,j)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(g(i,j)-g(i+1,j)) + abs(g(i+1,j)-g(i+2,j)) + abs(g(i,j-1)- g(i+1,j-1))/2;
            alpha4 = alpha4 + abs(g(i+1,j-1)- g(i+2,j-1))/2 + abs(g(i,j+1)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            b(i,j) = (alpha1*b1 + alpha2*b2 + alpha3*b3 + alpha4*b4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end  
    
    for i = 5:2:y-3
        for j = 4:2:x-3
            
            b1 = b(i-1,j) + (g(i,j) - g(i-1,j));
            b2 = b(i,j-1) + (g(i,j) - g(i,j-1));
            b3 = b(i,j+1) + (g(i,j) - g(i,j+1));
            b4 = b(i+1,j) + (g(i,j) - g(i+1,j));
            
%             top direction
            alpha1 = 1 + abs(g(i,j)-g(i-1,j)) + abs(g(i-1,j)-g(i-2,j)) + abs(g(i,j-1)- g(i-1,j-1))/2;
            alpha1 = alpha1 + abs(g(i-1,j-1)- g(i-2,j-1))/2 + abs(g(i,j+1)-g(i-1,j+1))/2 + abs(g(i-1,j+1)-g(i-2,j+1))/2;
            alpha1 = 1 / alpha1;
%             left direction
            alpha2 = 1 + abs(g(i,j)-g(i,j-1)) + abs(g(i,j-1)-g(i,j-2)) + abs(g(i-1,j)- g(i-1,j-1))/2;
            alpha2 = alpha2 + abs(g(i-1,j-1)- g(i-1,j-2))/2 + abs(g(i+1,j)-g(i+1,j-1))/2 + abs(g(i+1,j-1)-g(i+1,j-2))/2;
            alpha2 = 1 / alpha2;
%             right direction
            alpha3 = 1 + abs(g(i,j)-g(i,j+1)) + abs(g(i,j+1)-g(i,j+2)) + abs(g(i-1,j)- g(i-1,j+1))/2;
            alpha3 = alpha3 + abs(g(i-1,j+1)- g(i-1,j+2))/2 + abs(g(i+1,j)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+1,j+2))/2;
            alpha3 = 1 / alpha3;
%             bottom direction
            alpha4 = 1 + abs(g(i,j)-g(i+1,j)) + abs(g(i+1,j)-g(i+2,j)) + abs(g(i,j-1)- g(i+1,j-1))/2;
            alpha4 = alpha4 + abs(g(i+1,j-1)- g(i+2,j-1))/2 + abs(g(i,j+1)-g(i+1,j+1))/2 + abs(g(i+1,j+1)-g(i+2,j+1))/2;
            alpha4 = 1 / alpha4;
            
            b(i,j) = (alpha1*b1 + alpha2*b2 + alpha3*b3 + alpha4*b4)/(alpha1 + alpha2 + alpha3 + alpha4);
        end
    end  
    
    b = resultOfConv(b);
        
end

function ppImage = postProcessing(dImage)

    ppImage = dImage;

    RG = dImage(:,:,1) - dImage(:,:,2);
    
    BG = dImage(:,:,3) - dImage(:,:,2);
    
    [y, x] = size(RG);
    
    for i = 3:y-2
        for j = 3:x-2
        
            Vrg = median(reshape(RG(i-2:i+2,j-2:j+2), 1, 25));
            
            Vbg = median(reshape(BG(i-2:i+2,j-2:j+2), 1, 25));
            
            ppImage(i,j,2) = (dImage(i,j,1)-Vrg)/2 + (dImage(i,j,3)-Vbg)/2;
            
            ppImage(i,j,1) = ppImage(i,j,2) + Vrg;
            
            ppImage(i,j,3) = ppImage(i,j,2) + Vbg;        
            
        end
    end    
end

function cReady = prepareForConv( matrix)

    [y,x] = size(matrix);
    
    cReady = [zeros(3,x + 6); 
              zeros(y,3),matrix, zeros(y,3); 
              zeros(3,x + 6)];     

end

function cEnd = resultOfConv( matrix)

    [y,x] = size(matrix);
    
    cEnd = matrix(4:y-3,4:x-3);

end