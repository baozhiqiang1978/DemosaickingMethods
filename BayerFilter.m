function [bayerImage] = BayerFilter(image)
    bayerImage(:,:,1) = red(image);
    bayerImage(:,:,2) = green(image);
    bayerImage(:,:,3) = blue(image);
end

function r = red(image)
    [x,y,z] = size(image);
    r = zeros(x,y,'uint8');
    r(2:2:x, 2:2:y) = image(2:2:x, 2:2:y, 1);
end

function g = green(image)
    [x,y,z] = size(image);
    g = zeros(x,y,'uint8');
    g(2:2:x, 1:2:y) = image(2:2:x, 1:2:y, 2);
    g(1:2:x, 2:2:y) = image(1:2:x, 2:2:y, 2);
end

function b = blue(image)
    [x,y,z] = size(image);
    b = zeros(x,y,'uint8');
    b(1:2:x, 1:2:y) = image(1:2:x, 1:2:y, 3);
end

