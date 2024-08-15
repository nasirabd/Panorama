function transform = estimateTransformRANSAC(im1_points, im2_points)
% This function preforms a RANSAC to narrow down points for the transform
% im1_points are points from the first image
% im2_points are the corresponding points in the second image
% transform is a 3x3 transform matrix returned

max = 0; Abest = zeros(3,3); t = .00005; k = 4; n = 40000; %control variables
for j = 1:n
    %Creates random indexes for the first set of points
    randRows = randperm(size(im1_points,1));
    randRows = randRows(1:k);

    %Finds a transform matrix 'A' based on the random set of points generated
    A=estimateTransform( im1_points(randRows,:), im2_points(randRows,:));

    %Converts the first set of points to homography points and applies the
    %transform matrix 'A' to all of those points
    homPoints1 = cart2hom(im1_points)';
    ePointsHat = A*homPoints1;

    %Error checking to determine the number of points that are within the
    %acceptable error threshold
    count = 0;
    for i = 1:size(ePointsHat,2)
        xe = ePointsHat(1,i)/ePointsHat(3,i); ye = ePointsHat(2,i)/ePointsHat(3,i);
        xp = im2_points(i,1); yp = im2_points(i,2); 
        e = (xp-xe)^2 + (yp-ye)^2;
        if(e<t)
            count = count + 1;
        end
    end

    %if there are more good points than the current max, update max and Abest
    if count>max
        max = count;
        Abest = A;
    end
end

transform = Abest;
end

