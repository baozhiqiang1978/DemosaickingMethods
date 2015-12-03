 function dImage = CubicInterpolation( bayerImage)
    tic
    global conGreen;
    conGreen = [0 0 0 1 0 0 0;
                0 0 -9 0 -9 0 0;
                0 -9 0 81 0 -9 0;
                1 0 81 256 81 0 1;
                0 -9 0 81 0 -9 0;
                0 0 -9 0 -9 0 0;
                0 0 0 1 0 0 0];
     
    global conRedBlue;
    conRedBlue = [1 0 -9 -16 -9 0 1;
                  0 0 0 0 0 0 0;
                  -9 0 81 144 81 0 -9;
                  -16 0 144 256 144 0 -16;
                  -9 0 81 144 81 0 -9;
                  0 0 0 0 0 0 0;
                  1 0 -9 -16 -9 0 1];

    dImage(:,:,1) = red(double(bayerImage(:,:,1)));
    dImage(:,:,2) = green(double(bayerImage(:,:,2)));
    dImage(:,:,3) = blue(double(bayerImage(:,:,3)));
    toc

end

function r = red(bayerRed)

    global conRedBlue;

    temp1 = prepareForConv(bayerRed);
    
    [y,x] = size(temp1);
    
    r = zeros(y,x);
    
    for i = 4:y-3
        for j = 4:x-3
    
            temp2 = temp1(i-3:i+3,j-3:j+3);
            
            val = conRedBlue.*double(temp2);
            
            div = val;
            div(div ~= 0) = 1;
            
            div = sum(sum(div.*conRedBlue));
            
            r(i, j) = sum(sum(val/div));

        end
    end    
    
    r = uint8(resultOfConv(r));
    
end

function g = green(bayerGreen)

    global conGreen;
    
    temp1 = prepareForConv(bayerGreen);
    
    [y,x] = size(temp1);
    
    g = zeros(y,x);
    
     for i = 4:y-3
        for j = 4:x-3
    
            temp2 = temp1(i-3:i+3,j-3:j+3);
            
            val = conGreen.*double(temp2);
            
            div = val;
            div(div ~= 0) = 1;
            
            div = sum(sum(div.*conGreen));
            
            g(i, j) = sum(sum(val/div));
  
         end
    end 
    
    g = uint8(resultOfConv(g));
end

function b = blue(bayerBlue)
    
    global conRedBlue;
    
    temp1 = prepareForConv(bayerBlue);
    
    [y,x] = size(temp1);
    
    b = zeros(y,x);
    
    for i = 4:y-3
        for j = 4:x-3
    
            temp2 = temp1(i-3:i+3,j-3:j+3);

            val = conRedBlue.*double(temp2);
            
            div = val;
            div(div ~= 0) = 1;
            
            div = sum(sum(div.*conRedBlue));
            
            b(i, j) = sum(sum(val/div));
            
        end
    end
    
    b = uint8(resultOfConv(b));

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