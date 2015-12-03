function [e,r] = CMSEandCPSNR(originalImage, DemosaicedImage, omittedPixelsWidth)
    
    if omittedPixelsWidth ~= 0

        DemosaicedImage = omitPixels(originalImage, DemosaicedImage, omittedPixelsWidth);
    
    end
    
    [y x z] = size(DemosaicedImage);
    
    e = sum(sum(sum((double(originalImage - DemosaicedImage)).^2)));
    
    e = e /(3*(y-omittedPixelsWidth)*(x-omittedPixelsWidth));
  
    r = 10*log((255.^2)/e);
    
end

function dImage = omitPixels(originalImage, DemosaicedImage, omittedPixelsWidth)
    
    DemosaicedImage(1:omittedPixelsWidth,:,:) = originalImage(1:omittedPixelsWidth,:,:);
    
    DemosaicedImage(:,1:omittedPixelsWidth,:) = originalImage(:,1:omittedPixelsWidth,:);
    
    DemosaicedImage(end-omittedPixelsWidth:end,:,:) = originalImage(end-omittedPixelsWidth:end,:,:);
    
    DemosaicedImage(:,end-omittedPixelsWidth:end,:) = originalImage(:,end-omittedPixelsWidth:end,:);
    
    dImage = DemosaicedImage;
end    