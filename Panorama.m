function panoramaImage = Panorama(image1,image2)
% This fuction combines two images into one
% image1 is an image
% image2 is also an image
% panoramaImage is the output image after images 1 and 2 were combined

%Converts Images to grayscale and converts them to double
image1Gray = im2double(rgb2gray(image1));
image2Gray = im2double(rgb2gray(image2));

%using SURF alg to get all of the correspondences and features
points1 = detectSURFFeatures( image1Gray );
features1 = extractFeatures( image1Gray,points1 );
points2 = detectSURFFeatures( image2Gray );
features2 = extractFeatures( image2Gray,points2 );

% matching features together to get points for each image
indexPairs = matchFeatures( features1, features2, 'Unique', true );
matchedPoints1 = points1( indexPairs( :,1 ) );
matchedPoints2 = points2( indexPairs( :,2 ) );
im1_points = matchedPoints1.Location;
im2_points = matchedPoints2.Location;

%calles function to estimate the transform needed to mesh the two photos
A=estimateTransformRANSAC( im1_points, im2_points );

%calles function to preform a homography transform on image2 using the
%transform matrix 'A' obtained above
im2_transformed = transformImage(image2Gray, invertMatrix(A,'homography'), 'homography');
nanlocations = isnan( im2_transformed );
im2_transformed( nanlocations )=0;

imshow(im2_transformed);
saveas(gcf,'Outputs/im2_transformed.png');
close all;

%Expanding im1 to be the size of im2
[H2,W2] = size(im2_transformed);
[H1,W1] = size(image1Gray);
im1_expanded = [image1Gray zeros(H1,W2-W1)];
im1_expanded = [im1_expanded; zeros(H2-H1,W2)];

imshow(im1_expanded);
saveas(gcf,'Outputs/im1_expanded.png');
close all;

%blending im1_expanded and im2_transformed together

%creating the ramp
imshow(im1_expanded);
[x_overlap,y_overlap]=ginput(2);
overlapleft=round(x_overlap(1));
overlapright=round(x_overlap(2));
close all;
%im1 ramp
onesToLeft = ones(1,overlapleft);
zerosToRight = zeros(1,overlapright);
stepvalue1 = linspace(1,0,W2-size(onesToLeft,2)-size(zerosToRight,2));
im1_ramp = [onesToLeft,stepvalue1,zerosToRight];
%im2 ramp
zerosToLeft = zeros(1,overlapleft);
onesToRight = ones(1,overlapright);
stepvalue2 = linspace(0,1,W2-size(zerosToLeft,2)-size(onesToRight,2));
im2_ramp=[zerosToLeft,stepvalue2,onesToRight];

%using the ramp to blend the images
im1_blend = im1_expanded.*im1_ramp;
im2_blend = im2_transformed.*im2_ramp;

imshow(im1_blend);
saveas(gcf,'Outputs/im1_blend.png');
close all;
imshow(im2_blend);
saveas(gcf,'Outputs/im2_blend.png');
close all;



panoramaImage = im1_blend+im2_blend;
end

