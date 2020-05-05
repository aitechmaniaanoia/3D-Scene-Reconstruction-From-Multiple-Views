% CMPT 742 - Final Project
% point_distance.m

function distance = point_distance(point_1, point_2)
    distance = sqrt((point_2(1) - point_1(1)).^2 +...
        (point_2(2) - point_1(2)).^2 +...
        (point_2(3) - point_1(3)).^2);
end
