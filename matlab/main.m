% CMPT 742 - Final Project
% main.m

clear all;
close all;
clc;

% Read input data.
obj_id = '6';
file_path = fullfile('..', 'snapshots', strcat('obj_', obj_id), filesep);
num_files = length(dir(strcat(file_path, '*.raw')));

[color_data, depth_color_data, depth_data, depth_metadata, point_cloud_data_raw] = parse_input_data(file_path, num_files);
control_points = {num_files, 1};

% HSV target control point parameters.
hsv_hue_min = 330/360;
hsv_hue_max = 30/360;
hsv_saturation_min = 0.3;
hsv_value_min = 0.6;

for i = 1 : num_files
    % Get target point cloud data.
    pc_current = pcdenoise(point_cloud_data_raw{i});
    pc_xyz = pc_current.Location;
    pc_rgb = pc_current.Color;
    pc_hsv = rgb2hsv(double(pc_rgb) ./ 255);
    
    % Find target control points based on their HSV color values.
    pc_target_index = find(((pc_hsv(:, 1) >= 0 & pc_hsv(:, 1) <= hsv_hue_max)...
        | (pc_hsv(:, 1) >= hsv_hue_min & pc_hsv(:, 1) <= 1))...
        & pc_hsv(:, 2) >= hsv_saturation_min & pc_hsv(:, 3) >= hsv_value_min);
    
    pc_target = pointCloud(pc_xyz(pc_target_index, :), 'Color', pc_rgb(pc_target_index, :));
    pc_target = pcdenoise(pc_target);
    
    % Segment target control points into 3 groups.
    pc_target_labels = pcsegdist(pc_target, 0.1);
    pc_target_1_all = pc_target.Location(pc_target_labels == 1, :);
    pc_target_2_all = pc_target.Location(pc_target_labels == 2, :);
    pc_target_3_all = pc_target.Location(pc_target_labels == 3, :);
    
    % Find target control point centroids.
    control_point_1 = mean(pc_target_1_all);
    control_point_2 = mean(pc_target_2_all);
    control_point_3 = mean(pc_target_3_all);
    
    % Sort target control points based on their relative distance.
    [control_point_1, control_point_2, control_point_3] = sort_control_points(control_point_1, control_point_2, control_point_3);
    control_points{i} = [control_point_1; control_point_2; control_point_3]';
end

% Define a fixed reference point cloud.
pc_final = pcdenoise(point_cloud_data_raw{1});

for i = 2 : num_files
    % Find target transformation into the fixed reference point cloud.
    [transform_data, ~] = absor(control_points{i}, control_points{1}, 'doScale', true, 'doTrans', true);
    target_transform = affine3d(transform_data.M');
    
    % Apply target transformation.
    pc_current = pcdenoise(point_cloud_data_raw{i});
    pc_transformed_xyz = transformPointsForward(target_transform, pc_current.Location);
    pc_transformed = pointCloud(pc_transformed_xyz, 'Color', pc_current.Color);
    
    % Merge point clouds.
    pc_final = pcmerge(pc_final, pc_transformed, 0.0001);
end

figure;
pcshow(pc_final, 'MarkerSize', 10);
