function TransformedImage = transformImage(InputImage, TransformMatrix, TransformType)
%INPTUS: (InputImage, TransformMatrix, TransformType)
%InputImage: is an image of size H_ixW_i, HAS to be grayscale as it will be
%TransformMatrix: is a 3x3 matrix that represents a transform
%TransformType: is a string that can have the following values 
%(‘scaling’, ‘rotation’, ‘translation’, ‘reflection’, ‘shear’, ‘affine’, ‘homography’)
%
%OUTPUTS: TransformedImage
%TransformedImage: is the image after the transform as been done to it of
%size H_oxW_o

%converts the type of the image from unit8 to a double
I = im2double(InputImage);

%~~~~~~~~~STEP #1~~~~~~~~~


%gets the height and width of the input image
[Hi,Wi] = size(I);

%The four original corners of the input image
corner1 = [1,1,1]';
corner2 = [Wi,1,1]';
corner3 = [1,Hi,1]';
corner4 = [Wi,Hi,1]';

%Using the TransformMatrix find the four corners of I'
corner1prime = TransformMatrix*corner1;
corner2prime = TransformMatrix*corner2;
corner3prime = TransformMatrix*corner3;
corner4prime = TransformMatrix*corner4;

xp1 = corner1prime(1)/corner1prime(3);
xp2 = corner2prime(1)/corner2prime(3); 
xp3 = corner3prime(1)/corner3prime(3); 
xp4 = corner4prime(1)/corner4prime(3);

yp1 = corner1prime(2)/corner1prime(3);
yp2 = corner2prime(2)/corner2prime(3); 
yp3 = corner3prime(2)/corner3prime(3); 
yp4 = corner4prime(2)/corner4prime(3); 

%Using the four corners of I' to find the min/max of x and y in
%Transformed Image
minX = 1; maxX = max([xp1,xp2,xp3,xp4]); %min([1,xp1,xp2,xp3,xp4])
minY = 1; maxY = max([yp1,yp2,yp3,yp4]); %min([1,yp1,yp2,yp3,yp4])


%~~~~~~~~~STEP #2~~~~~~~~~


%Create and set X' and Y' grids
[Xprime, Yprime] = meshgrid(minX:maxX,minY:maxY);

%Height and Width of I'
[Ho,Wo] = size(Xprime);

%Creates the matrix for I' Scaled down from double to single because I was
%running out of memeory
pprimeMatrix = [Xprime(:)';Yprime(:)';ones(1,Ho*Wo)];


%~~~~~~~~~STEP #3~~~~~~~~~


%Inverts the transform matrix
Ainverse = invertMatrix(TransformMatrix,TransformType);


%~~~~~~~~~STEP #4~~~~~~~~~


%get the hatted not prime matrix
phatmatrix = Ainverse*pprimeMatrix;

%get the x and y matrices from the phat matrix
xMatrix = reshape((phatmatrix(1,:) ./ phatmatrix(3,:))', Ho, Wo);
yMatrix = reshape((phatmatrix(2,:) ./ phatmatrix(3,:))', Ho, Wo);


%~~~~~~~~~STEP #5~~~~~~~~~


%Interloplate the transformed image from the x and y matrices
TransformedImage = interp2(single(I), xMatrix, yMatrix);

end

