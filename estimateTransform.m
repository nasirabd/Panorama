function transform = estimateTransform(im1_points, im2_points)
% This function estimates a transform based on sets of points
% im1_points are points from the first image
% im2_points are the corresponding points in the second image
% transform is a 3x3 transform matrix returned

P = [];
for i = 1:size(im1_points,1)
    x = im1_points(i,1); y = im1_points(i,2); xp = im2_points(i,1); yp = im2_points(i,2);
    P = vertcat(P,[-x,-y,-1,0,0,0,(xp*x), (xp*y), xp;0,0,0,-x,-y,-1,(yp*x),(yp*y),yp]);
end
if size(P,1) > 8
    [U,S,V] = svd(P,'econ');
else
    [U,S,V] = svd(P);
end
q = V(:,size(V,2))';
transform = [q(1),q(2),q(3);q(4),q(5),q(6);q(7),q(8),q(9)];
end

