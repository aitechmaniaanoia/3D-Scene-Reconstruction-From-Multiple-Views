% CMPT 742 - Final Project
% get_depth_metadata_value.m

function value = get_depth_metadata_value(metadata, field_name)
    value = cell2mat(metadata(strcmp(metadata.Type, field_name), 2).Depth);
end
