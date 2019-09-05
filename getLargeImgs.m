function big_images = getLargeImgs(directory_of_final)
    % get the image names that we are trying to make
    file_names = dir(directory_of_final);
    file_names = file_names(arrayfun(@(x) x.name(1) ~= '.', file_names));
    
    for i = 1 : length(file_names)
        %get the full file name
        final_image_name = fullfile(directory_of_final,file_names(i).name);
        img = imread(final_image_name); %read/get the image
        img = imresize(img, [15000 15000]); %resize to 10000x10000 pixels
        big_images(:,:,3*(i-1)+1:3*i) = img; %add the image to the stack of big images
    end
end

