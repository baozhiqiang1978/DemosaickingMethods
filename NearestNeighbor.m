function dImage = NearestNeighbor(bayerImage)
    dImage(:,:,1) = red(bayerImage(:,:,1));
    dImage(:,:,2) = greenV(bayerImage(:,:,2));
    dImage(:,:,3) = blue(bayerImage(:,:,3));
end

function r = red(bayerRed)
    
    [x,y] = size(bayerRed);
    
    r = bayerRed;

    for i = 2:2:x
        for j = 2:2:y
            
            r(i-1,j) = bayerRed(i,j);
            r(i,j-1) = bayerRed(i,j);
            r(i-1,j-1) = bayerRed(i,j);
        end
    end
end

function g = greenH(bayerGreen)
    [x,y] = size(bayerRed);
    
    g = bayerGreen;
    
    for i = 1:x
        if  (rem(i,2) == 1)      
            for j = 2:2:y
                
                g(i,j-1) = bayerGreen(i,j);
                
            end    
        else
            for j = 1:2:y
                
                g(i,j+1) = bayerGreen(i,j);
                
            end 
        end
    end   
end

function g = greenV(bayerGreen)
    [x,y] = size(bayerGreen);
    
    g = bayerGreen;
    
    for j = 1:y
        if  (rem(j,2) == 1)      
            for i = 2:2:x
                
                g(i-1,j) = bayerGreen(i,j);
                
            end    
        else
            for i = 1:2:x
                
                g(i+1,j) = bayerGreen(i,j);
                
            end 
        end
    end   
end

function b = blue(bayerBlue)
    
    [x,y] = size(bayerBlue);
    
    b = bayerBlue;

    for i = 1:2:x
        for j = 1:2:y
            
            b(i+1,j) = bayerBlue(i,j);
            b(i,j+1) = bayerBlue(i,j);
            b(i+1,j+1) = bayerBlue(i,j);
        end
    end
end
