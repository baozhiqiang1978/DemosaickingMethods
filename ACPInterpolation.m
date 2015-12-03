function dImage = ACPInterpolation(bayerImage)
    tic
    global RB;
    global G;
    RB = [-1,0,2,0,-1];
    G = [0,1,0,-1,0];
    
    bayerPlane = bayerImage(:,:,1) + bayerImage(:,:,2) +bayerImage(:,:,3);
    
    grn = green(double(bayerPlane)) + double(bayerImage(:,:,2));
  
    dImage(:,:,2) = uint8(green(double(bayerPlane))) + bayerImage(:,:,2);
    dImage(:,:,1) = bayerImage(:,:,1) + uint8(red(double(bayerImage(:,:,1)),grn));
    dImage(:,:,3) = bayerImage(:,:,3) + uint8(blue(double(bayerImage(:,:,3)),grn));
    
    toc
end

function g = green(bayerPlane)
    
    global RB;
    global G;
    
    bayerPlane = prepareForConv(bayerPlane);
    
    [y,x] = size(bayerPlane);
    
    g = zeros(y,x);
    
    for i = 3:2:y-2
        for j = 3:2:x-2
            
            V = abs(sum(double(bayerPlane(i-2:i+2,j)).*(G')))+abs(sum(double(bayerPlane(i-2:i+2,j)).*(RB')));
            H = abs(sum(double(bayerPlane(i,j-2:j+2)).*G))+abs(sum(double(bayerPlane(i,j-2:j+2)).*RB));
             
            if (V>H)
                
                g(i,j) = (bayerPlane(i,j-1) + bayerPlane(i,j+1))/2;
                g(i,j) = g(i,j) + sum(double(bayerPlane(i,j-2:j+2)).*RB)/2;
            
            elseif(V<H) 
                
                g(i,j) = (bayerPlane(i-1,j) + bayerPlane(i+1,j))/2;
                g(i,j) = g(i,j) + sum(double(bayerPlane(i-2:i+2,j)).*(RB'))/2;
                
            else
                tmp1 = (bayerPlane(i,j-1) + bayerPlane(i,j+1))/2;
                tmp1 = tmp1 + sum(double(bayerPlane(i,j-2:j+2)).*RB)/2;
                
                tmp2 = (bayerPlane(i-1,j) + bayerPlane(i+1,j))/2;
                tmp2 = tmp2 + sum(double(bayerPlane(i-2:i+2,j)).*(RB'))/2;
                
                g(i,j) = (tmp1 + tmp2)/2;
            end    
        end
    end
    
    for i = 4:2:y-2
        for j = 4:2:x-2
            
            V = abs(sum(double(bayerPlane(i-2:i+2,j)).*(G')))+abs(sum(double(bayerPlane(i-2:i+2,j)).*(RB')));
            H = abs(sum(double(bayerPlane(i,j-2:j+2)).*G))+abs(sum(double(bayerPlane(i,j-2:j+2)).*RB));
                     
            if (V>H)
                
                g(i,j) = (bayerPlane(i,j-1) + bayerPlane(i,j+1))/2;
                g(i,j) = g(i,j) + sum(double(bayerPlane(i,j-2:j+2)).*RB)/2;
            
            elseif(V<H) 
                
                g(i,j) = (bayerPlane(i-1,j) + bayerPlane(i+1,j))/2;
                g(i,j) = g(i,j) + sum(double(bayerPlane(i-2:i+2,j)).*(RB'))/2;
                
            else
                tmp1 = (bayerPlane(i,j-1) + bayerPlane(i,j+1))/2;
                tmp1 = tmp1 + sum(double(bayerPlane(i,j-2:j+2)).*RB)/2;
                
                tmp2 = (bayerPlane(i-1,j) + bayerPlane(i+1,j))/2;
                tmp2 = tmp2 + sum(double(bayerPlane(i-2:i+2,j)).*(RB'))/2;
                
                g(i,j) = (tmp1 + tmp2)/2;
            end   
        end
    end
    
     g = resultOfConv(g);
end

function r = red(bayerRed, g)
    
    bayerRed = prepareForConv(bayerRed);
    g = prepareForConv(g);
    
    [y,x] = size(bayerRed);
    
    r = zeros(y,x);

    for i = 3:2:y-2
        for j = 3:2:x-2
            
            alpha = abs(bayerRed(i-1,j-1)-bayerRed(i+1,j+1))+abs(2*g(i,j)-g(i-1,j-1)-g(i+1,j+1));
            beta = abs(bayerRed(i-1,j+1)-bayerRed(i+1,j-1))+abs(2*g(i,j)-g(i-1,j+1)-g(i+1,j-1));
                      
            if (alpha>beta)
                
                r(i,j) = (bayerRed(i-1,j+1) + bayerRed(i+1,j-1))/2;
                r(i,j) = r(i,j) + (2*g(i,j)-g(i-1,j+1)-g(i+1,j-1))/2;
            
            elseif(alpha<beta) 
                
                r(i,j) = (bayerRed(i+1,j+1) + bayerRed(i-1,j-1))/2;
                r(i,j) = r(i,j) + (2*g(i,j)-g(i+1,j+1)-g(i-1,j-1))/2;
                
            else
                tmp1 = (bayerRed(i-1,j+1) + bayerRed(i+1,j-1))/2;
                tmp1 = tmp1 + (2*g(i,j)-g(i-1,j+1)-g(i+1,j-1))/2;
                
                tmp2 = (bayerRed(i+1,j+1) + bayerRed(i-1,j-1))/2;
                tmp2 = tmp2 + (2*g(i,j)-g(i+1,j+1)-g(i-1,j-1))/2;
                
                r(i,j) = (tmp1 + tmp2)/2;
            end    
        end
    end
    
    for i = 3:2:y-2
        for j = 4:2:x-2
            r(i,j) = (bayerRed(i-1,j) + bayerRed(i+1,j)+ 2*g(i,j) - g(i-1,j) - g(i+1,j))/2;
        end
    end
    
    for i = 4:2:y-2
        for j = 3:2:x-2
            r(i,j) = (bayerRed(i,j-1) + bayerRed(i,j+1)+ 2*g(i,j) - g(i,j-1) - g(i,j+1))/2;           
        end
    end
    
    r = resultOfConv(r);

end

function b = blue(bayerBlue, g)
    
    bayerBlue = prepareForConv(bayerBlue);
    g = prepareForConv(g);
    
    [y,x] = size(bayerBlue);
    
    b = zeros(y,x);

    for i = 4:2:y-2
        for j = 4:2:x-2
            
            alpha = abs(bayerBlue(i-1,j-1)-bayerBlue(i+1,j+1))+abs(2*g(i,j)-g(i-1,j-1)-g(i+1,j+1));
            beta = abs(bayerBlue(i-1,j+1)-bayerBlue(i+1,j-1))+abs(2*g(i,j)-g(i-1,j+1)-g(i+1,j-1));
             
            if (alpha>beta)
                
                b(i,j) = (bayerBlue(i-1,j+1) + bayerBlue(i+1,j-1))/2;
                b(i,j) = b(i,j) + (2*g(i,j)-g(i-1,j+1)-g(i+1,j-1))/2;
                         
            elseif(alpha<beta) 
                
                b(i,j) = (bayerBlue(i+1,j+1) + bayerBlue(i-1,j-1))/2;
                b(i,j) = b(i,j) + (2*g(i,j)-g(i+1,j+1)-g(i-1,j-1))/2;
                
            else
                tmp1 = (bayerBlue(i-1,j+1) + bayerBlue(i+1,j-1))/2;
                tmp1 = tmp1 + (2*g(i,j)-g(i-1,j+1)-g(i+1,j-1))/2;
                
                tmp2 = (bayerBlue(i+1,j+1) + bayerBlue(i-1,j-1))/2;
                tmp2 = tmp2 + (2*g(i,j)-g(i+1,j+1)-g(i-1,j-1))/2;
                
                b(i,j) = (tmp1 + tmp2)/2;
            end    
        end
    end
    
    for i = 3:2:y-2
        for j = 4:2:x-2
           b(i,j) = (bayerBlue(i,j-1) + bayerBlue(i,j+1)+ 2*g(i,j) - g(i,j-1) - g(i,j+1))/2; 
        end
    end
    
    for i = 4:2:y-2
        for j = 3:2:x-2
            b(i,j) = (bayerBlue(i-1,j) + bayerBlue(i+1,j)+ 2*g(i,j) - g(i-1,j) - g(i+1,j))/2;         
        end
    end
    
    b = resultOfConv(b);
end   

function cReady = prepareForConv( matrix)

    [y,x] = size(matrix);
    
    cReady = [zeros(2,x + 4); 
              zeros(y,2),matrix, zeros(y,2); 
              zeros(2,x + 4)];     

end

function cEnd = resultOfConv( matrix)

    [y,x] = size(matrix);
    
    cEnd = matrix(3:y-2,3:x-2);

end

