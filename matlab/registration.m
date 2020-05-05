% CMPT 742 - Final Project
% registration.m

% https://www.mathworks.com/help/vision/ug/point-cloud-registration-workflow.html

% Moving ptCloudCurrent into ptCloudRef
function [ptCloudScene] = registration(ptCloudRef, ptCloudCurrent)
    gridSize = 0.01; % 0.1 = 10cm (size of grid filter)
    mergeSize = 0.0015; % 0.015 = 1.5cm box grid filter; smaller mergeSize = better resolution
    
    % Downsampling
    fixed = pcdownsample(ptCloudRef, 'gridAverage', gridSize);
    moving = pcdownsample(ptCloudCurrent, 'gridAverage', gridSize);
    
    % Apply ICP registration
    tform = pcregistericp(moving,fixed, 'Metric','pointToPoint', 'Extrapolate',true, 'InlierRatio',0.95, 'MaxIterations',200, 'Tolerance',[0.00001, 0.00005]);
    % Default: Metric='pointToPoint', Extrapolate=false, InlierRatio=1, MaxIterations=20, Tolerance=[0.01, 0.05]
    
    % Apply CPD registration
    % tform = pcregistercpd(moving,fixed, 'Transform','Rigid','OutlierRatio',0.1, 'MaxIterations',100, 'Tolerance',0.00000001);
    % Default: Transform='Nonrigid', OutlierRatio=0.1, MaxIterations=20, Tolerance=0.00673794699 = exp(-5)
    % Other options: Transform='Rigid' or Transform='Affine'
    
    % Aligning
    ptCloudAligned = pctransform(ptCloudCurrent,tform);
    
    % Merging
    ptCloudScene = pcmerge(ptCloudRef, ptCloudAligned, mergeSize);
end
