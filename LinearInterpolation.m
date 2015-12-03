function dImage = LinearInterpolation( bayerImage)
    tic
    global conGreen;
    conGreen = [0 1 0;1 4 1;0 1 0];
    
    global conRedBlue;
    conRedBlue = [1 2 1;2 4 2;1 2 1];

    dImage(:,:,1) = red(bayerImage(:,:,1));
    dImage(:,:,2) = green(bayerImage(:,:,2));
    dImage(:,:,3) = blue(bayerImage(:,:,3));
    toc

end
 
function r = red(bayerRed)

    global conRedBlue;

    temp1 = prepareForConv(bayerRed);
    
    [y,x] = size(temp1);
    
    r = zeros(y,x);
    
    for i = 2:y-1
        for j = 2:x-1
    
            temp2 = temp1(i-1:i+1,j-1:j+1);
   
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
    
     for i = 2:y-1
        for j = 2:x-1
    
            temp2 = temp1(i-1:i+1,j-1:j+1);
            
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
    
    for i = 2:y-1
        for j = 2:x-1
    
            temp2 = temp1(i-1:i+1,j-1:j+1);
            
%                     [temp1(i-1, j-1), temp1(i-1, j), temp1(i-1, j+1);
%                     temp1(i, j-1), temp1(i, j), temp1(i, j+1);
%                     temp1(i+1, j-1), temp1(i+1, j), temp1(i+1, j+1)];

            val = conRedBlue.*double(temp2);
            
            div = val;
            div(div ~= 0) = 1;
            
            div = sum(sum(div.*conRedBlue));
            
            b(i, j) = sum(sum(val/div));
            
        end
    end
    
    b = uint8(resultOfConv(b));

end

% function r = red(bayerRed)
% 
%     global conRedBlue;
% 
%     r = prepareForConv(bayerRed);
%     
%     [y,x] = size(r);
%     
%     temp = [r(1:y-2, 1:x-2), r(1:y-2, 2:x-1), r(1:y-2, 3:x);
%             r(2:y-1, 1:x-2), r(2:y-1, 2:x-1), r(2:y-1, 3:x);
%             r( 3:y , 1:x-2), r(3:y  , 2:x-1), r(3:y  , 3:x)]
%     
%     r(2:x-1, 2:y-1) = sum(sum(conRedBlue.*double([r(1:y-2, 1:x-2), r(1:y-2, 2:x-1), r(1:y-2, 3:x);
%             r(2:y-1, 1:x-2), r(2:y-1, 2:x-1), r(2:y-1, 3:x);
%             r( 3:y , 1:x-2), r(3:y  , 2:x-1), r(3:y  , 3:x)])));
%     
%     r = uint8(resultOfConv(r));
%     
% end
% 
% function g = green(bayerGreen)
% 
%     global conGreen;
%     
%     g = prepareForConv(bayerGreen);
%     
%     [y,x] = size(g);
%     
%     temp = [r(1:y-2, 1:x-2) r(1:y-2, 2:x-1) r(1:y-2, 3:x);
%             r(2:y-1, 1:x-2) r(2:y-1, 2:x-1) r(2:y-1, 3:x);
%             r( 3:y , 1:x-2) r(3:y  , 2:x-1) r(3:y  , 3:x)];
%     
%     g(2:x-1, 2:y-1) = sum(sum(conGreen.*double(temp)));
%     
%     g = uint8(resultOfConv(g));
% 
% 
% end
% 
% function b = blue(bayerBlue)
%     
%     global conRedBlue;
%     
%     b = prepareForConv(bayerBlue);
%     
%     [y,x] = size(b);
%     
%     temp = [r(1:y-2, 1:x-2) r(1:y-2, 2:x-1) r(1:y-2, 3:x);
%             r(2:y-1, 1:x-2) r(2:y-1, 2:x-1) r(2:y-1, 3:x);
%             r( 3:y , 1:x-2) r(3:y  , 2:x-1) r(3:y  , 3:x)];
%     
%     b(2:x-1, 2:y-1) = sum(sum(conRedBlue.*double(temp)));
%     
%     b = uint8(resultOfConv(b));
% 
% end

function cReady = prepareForConv( matrix)

    [y,x] = size(matrix);
    
    cReady = [zeros(1,x + 2); 
              zeros(y,1),matrix, zeros(y,1); 
              zeros(1,x + 2)];

end

function cEnd = resultOfConv( matrix)

    [y,x] = size(matrix);
    
    cEnd = matrix(2:y-1,2:x-1);

end