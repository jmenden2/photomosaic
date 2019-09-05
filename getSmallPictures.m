function [orig_imgs,imgs] = getSmallPictures(directory_of_stock)
    %load the image name/information
    img_files = dir(directory_of_stock);
   
    %remove images starting with '.' to keep only the image files
    img_files = img_files(arrayfun(@(x) x.name(1) ~= '.', img_files));
    
    %load each small picture
    for i = 1 : length(img_files)
        %get the full file name
        filename = fullfile(directory_of_stock,img_files(i).name);
        img = imread(filename); %read/get the image
        orig_imgs(:,:,3*(i-1)+1:3*i) = imresize(img, [500 500]); %these images will be used to see how the mosaic is constructed
        img = imresize(img, [30 30]); % all pictures will be resized to 25x25 pixels
        imgs(:,:,3*(i-1)+1:3*i) = img; %add the color image to the stack 
    end
end

