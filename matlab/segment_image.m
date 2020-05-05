% CMPT 742 - Final Project
% segment_image.m

function mask_final = segment_image(image_rgb, num_objects)
    image_gray = rgb2gray(image_rgb);
    image_gray = imgaussfilt(image_gray, 2);

    % Detect edges
    [~, threshold] = edge(image_gray, 'sobel');
    fudge_factor = 0.5;
    mask_gradient = edge(image_gray, 'sobel', threshold * fudge_factor);
    
    % Dilate edges
    struct_element_line_90 = strel('line', 2, 90);
    struct_element_line_0 = strel('line', 2, 0);
    mask_dilated = imdilate(mask_gradient, [struct_element_line_90 struct_element_line_0]);

    % Fill regions inside the edges
    mask_filled = imfill(mask_dilated, 'holes');

    % Remove borders
    mask_no_border = imclearborder(mask_filled, 4);

    % Erosion
    struct_element_diamond = strel('diamond', 6);
    mask_smoothed = imerode(mask_no_border, struct_element_diamond);
    mask_smoothed = imerode(mask_smoothed, struct_element_diamond);

    % Extract largest region
    mask_final = bwareafilt(mask_smoothed, num_objects);
end
