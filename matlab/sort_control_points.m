% CMPT 742 - Final Project
% sort_control_points.m

function [p1_sorted, p2_sorted, p3_sorted] = sort_control_points(point_1, point_2, point_3)
    p1_p2_distance = point_distance(point_1, point_2);
    p2_p3_distance = point_distance(point_2, point_3);
    p1_p3_distance = point_distance(point_1, point_3);

    p1_sum_distance = p1_p2_distance + p1_p3_distance;
    p2_sum_distance = p1_p2_distance + p2_p3_distance;
    p3_sum_distance = p1_p3_distance + p2_p3_distance;
    max_sum_distance = max([p1_sum_distance p2_sum_distance p3_sum_distance]);
    
    % Make most distant point an anchor point.
    % Set p1_sorted to be the anchor point.
    % Set p2_sorted to be the most distant point from the anchor point.
    % Set p3_sorted to be the closest point to the anchor point.
    if (p1_sum_distance == max_sum_distance)
        p1_sorted = point_1;
        
        if (p1_p2_distance >= p1_p3_distance)
            p2_sorted = point_2;
            p3_sorted = point_3;
        else
            p2_sorted = point_3;
            p3_sorted = point_2;
        end
    elseif (p2_sum_distance == max_sum_distance)
        p1_sorted = point_2;
        
        if (p1_p2_distance >= p2_p3_distance)
            p2_sorted = point_1;
            p3_sorted = point_3;
        else
            p2_sorted = point_3;
            p3_sorted = point_1;
        end
    elseif (p3_sum_distance == max_sum_distance)
        p1_sorted = point_3;
        
        if (p1_p3_distance >= p2_p3_distance)
            p2_sorted = point_1;
            p3_sorted = point_2;
        else
            p2_sorted = point_2;
            p3_sorted = point_1;
        end
    end
end
