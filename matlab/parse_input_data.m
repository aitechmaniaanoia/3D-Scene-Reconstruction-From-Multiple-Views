% CMPT 742 - Final Project
% parse_input_data.m

function [color_data, depth_color_data, depth_data, depth_metadata, point_cloud_data] = parse_input_data(file_path, num_files)
    color_data = {num_files, 1};
    depth_color_data = {num_files, 1};
    depth_data = {num_files, 1};
    depth_metadata = {num_files, 1};
    point_cloud_data = {num_files, 1};

    for i = 1 : num_files
        % Initialize File Names
        file_name_color_rgb = strcat(file_path, 'rgb', num2str(i, '%d'), '_Color.png');
        file_name_depth_rgb = strcat(file_path, 'd', num2str(i, '%d'), '_Depth.png');
        file_name_depth_raw = strcat(file_path, 'd', num2str(i, '%d'), '_Depth.raw');
        file_name_depth_md = strcat(file_path, 'd', num2str(i, '%d'), '_Depth_metadata.csv');
        file_name_point_cloud = strcat(file_path, 'pc', num2str(i, '%d'), '.ply');

        % Parse RGB Color Data
        try
            color_data{i} = imread(file_name_color_rgb);
            depth_color_data{i} = imread(file_name_depth_rgb);
        catch ex
            fprintf(2, 'ERROR: %s\n', ex.message);
        end
        
        % Parse Depth Metadata
        % Parse RGB Color Data
        try
            metadata = readtable(file_name_depth_md);
            res_x = str2num(get_depth_metadata_value(metadata, 'Resolution x'));
            res_y = str2num(get_depth_metadata_value(metadata, 'Resolution y'));
            depth_metadata{i} = metadata;
        catch ex
            fprintf(2, 'ERROR: %s\n', ex.message);
        end

        % Parse Depth Raw Data
        try
            file_raw_id = fopen(file_name_depth_raw, 'r');
            data = fread(file_raw_id, '*uint16');
            depth_data{i} = reshape(data, [res_x res_y])';
            fclose(file_raw_id);
        catch ex
            fprintf(2, 'ERROR: %s\n', ex.message);
        end
        
        % Parse Point Cloud Data
        try
            point_cloud_data{i} = pcread(file_name_point_cloud);
        catch ex
            fprintf(2, 'ERROR: %s\n', ex.message);
        end
    end
end
