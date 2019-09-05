function main
    %% Get all of the input images
    dir_of_images = 'images';
    dir_of_final = 'final_image';
    [orig_small_imgs,small_imgs] = getSmallPictures(dir_of_images);
    big_imgs = getLargeImgs(dir_of_final);
    
  
    %% let the user pick one of the final images, or provide a path to their desired image
    mode = input('Would you like to choose an image (1), or provide your own (2), or get a random one from the internet (3). Enter 1, 2, or 3\n');
    
    %check to make sure the user gave a valid input in the range 1-3
    if(mode < 1 || mode > 3) 
        mode = 1;
    end
     
    %mode 1 is where the user selects a pre-given image
    if(mode == 1)
        
        figure;
        %show the 4 option of photos
        subplot(2,2,1),imshow(big_imgs(:,:,1:3));
        title('1');
        subplot(2,2,2),imshow(big_imgs(:,:,4:6));
        title('2');
        subplot(2,2,3),imshow(big_imgs(:,:,7:9));
        title('3');
        subplot(2,2,4),imshow(big_imgs(:,:,10:12));
        title('4');
        pic_choice = input('Select your image. Enter 1-4\n');
        
        %input validation to make sure a valid photo number is chosen
        if(pic_choice < 1 || pic_choice > 4)
            pic_choice = 1;
        end
        close all;
        
        final_image = big_imgs(:,:,3*(pic_choice-1)+1:3*pic_choice);
        
    %mode 2 is where the user provides a path directly to the image    
    elseif (mode == 2)
        path_to_pic = input('Please provide the path to the image\n','s');
        final_image = imread(path_to_pic);
        final_image = imresize(final_image, [15000 15000]);
        
    %mode 3 is where a random picture from the internet is sampled
    else
        %get the random image and save it as a png
        temp_img = 'temp.png';
        full_file = websave(temp_img,'https://source.unsplash.com/random');
        final_image = imread('temp.png'); %read in the random image
        
        %find the smallest dimension of the image
        edge1 = size(final_image,1);
        edge2 = size(final_image,2);
        min_edge = min([edge1 edge2]);
        
        %crops the image to make it square based on the smallest edge
        final_image = imcrop(final_image,[0 0 min_edge min_edge]);
        
        %resize to 15000x15000 pixels
        final_image = imresize(final_image, [15000 15000]);
    end
    
    %show the original image
    figure;
    imshow(final_image);
    title('Original Photo');
    
    %% find the average color for each rgb layer for each picture
    avgs = findAvgColor(small_imgs);
    
    %% find the best small images that will makeup the final desired image
    [indexes,best_img] = findBestImgs(final_image,small_imgs,avgs);
    
    %% show the constructed image and save a png of the file
    best_img = uint8(best_img);
    smaller_best_img = imresize(best_img, [1000 1000]);
    imwrite(smaller_best_img,'mosaic.png');
    
    figure;
    imshow(smaller_best_img);
    title('Photo Mosaic');
    
    figure;
    sgtitle('Click on the mosaic image to find the image that constructed that point. Click outside the image to exit')
    subplot(1,2,1),imshow(best_img);
    
    
    %% allow the user to select points on the image to see what small image was used in construction
    %will run until the user selects outside the boundaries
    x=1;
    y=1;
   
    while y>=1 && y <= length(best_img) && x>=1 && x<= length(best_img)

        %get the index and the corresponding image number (1-25)
        y = floor(y);
        x = floor(x);
        img_num = indexes(y,x);

        %get the RGB image values from the RGB stack
        img = orig_small_imgs(:,:,3*(img_num-1)+1:3*img_num);
       
        subplot(1,2,2),imshow(uint8(img)); %display that image
       
        
        [x,y] = ginput(1); %get a new input from the user's mouse touch on the image
        
    end

    %once ended, close all windows and ends
    close all;
    
end

