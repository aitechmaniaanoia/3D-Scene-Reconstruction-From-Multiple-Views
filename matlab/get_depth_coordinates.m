% CMPT 742 - Final Project
% get_depth_coordinates.m

function [points, color_values] = get_depth_coordinates(color_data, depth_data, depth_metadata)
    fx = str2double(get_depth_metadata_value(depth_metadata, 'Fx'));
    fy = str2double(get_depth_metadata_value(depth_metadata, 'Fy'));
    ppx = str2double(get_depth_metadata_value(depth_metadata, 'PPx'));
    ppy = str2double(get_depth_metadata_value(depth_metadata, 'PPy'));

    [y_max, x_max]= size(depth_data);
    points = zeros(x_max * y_max, 3);
    color_values = zeros(size(points));
    index = 1;

    for row_y = 1 : y_max
        for col_x = 1 : x_max
            depth = depth_data(row_y, col_x);

            if (depth == 0)
               continue; 
            end

            % Point in image coordinates
            image_coordinates = [col_x row_y 1]';

            % Intrinsic matrix K
            K = [fx 0   ppx
                0   fy  ppy
                0   0   1];
            
            % Transforming from image coordinates to world coordinates
            points(index, :) = (K \ image_coordinates) * double(depth);
            
            for k = 1 : 3
                color_values(index, k) = color_data(row_y, col_x, k);
            end
            
            index = index + 1;
        end
    end
end
