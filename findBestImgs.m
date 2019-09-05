function [indexes,best_img] = findBestImgs(final_image,imgs,avgs)
    best_dist = intmax; %initially set the best distance to max
    best_index = 0; %will be used for finding the corresponding best small image
    
    
    small_images_dim = size(imgs,1); %finds the dimension of small images
    big_image_dim = size(final_image,1); %finds the dimension of the goal image
    best_img = zeros(big_image_dim,big_image_dim,3); %this will be the final constructed image
    indexes = zeros(big_image_dim,big_image_dim); %this will hold the indexes of the best pictures
    
    
    for i = 1 : (big_image_dim/small_images_dim)
        for j = 1 : (big_image_dim/small_images_dim)
            %get the average values for the r, g, and b layers
            mean_final_r = mean2(final_image((small_images_dim*(i-1)+1):small_images_dim*i,(small_images_dim*(j-1)+1:small_images_dim*j),1));
            mean_final_g = mean2(final_image((small_images_dim*(i-1)+1):small_images_dim*i,(small_images_dim*(j-1)+1:small_images_dim*j),2));
            mean_final_b = mean2(final_image((small_images_dim*(i-1)+1):small_images_dim*i,(small_images_dim*(j-1)+1:small_images_dim*j),3));
            best_dist = intmax; %reset the best distance each iteration
            
            %now find best image for the space of the small images
            for k = 1 : (length(avgs) / 3)
                %gets the rgb average for the current small picture
                rgb = deal(avgs(3*(k-1)+1:3*k));
                
                % use least squares regression to find the 'distance'
                % between the goal color, and the color of the current
                % small image
                curr_dist = sqrt((mean_final_r - rgb(1))^2 + (mean_final_g - rgb(2))^2 + (mean_final_b - rgb(3))^2);
                
                %if a smaller distance (ie difference of color) is found,
                %update the new best image
                if(curr_dist < best_dist)
                    best_dist = curr_dist;
                    best_index = k;
                end
            end
            %add the found best small image to the final image to be produced
            indexes(small_images_dim*(i-1)+1:small_images_dim*i,small_images_dim*(j-1)+1:small_images_dim*j) = best_index;
            best_img(small_images_dim*(i-1)+1:small_images_dim*i,small_images_dim*(j-1)+1:small_images_dim*j,:) = imgs(1:small_images_dim,1:small_images_dim,3*(best_index - 1)+1:3*best_index);
        end
    end
  
end

