function avgColors = findAvgColor(imgs)
    %finds the average for each layer, which means each image's r g and b
    %layer will get an average value, which will then be used later to find
    %the best image to use to construct the final image
    for i = 1 : length(imgs)
        avgColors(i) = mean2(imgs(:,:,i));   
    end
    
end

