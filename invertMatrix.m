function InvertedMatrix = invertMatrix(TransformMatrix,TransformType)
%TransformMatrix: is a 3x3 matrix that represents a transform
%TransformType: is a string that can have the following values 
%(‘scaling’, ‘rotation’, ‘translation’, ‘reflection’, ‘shear’, ‘affine’, ‘homography’)
%InvertedMatrix: is the TransformMatrix properly inverted

if strcmp(TransformType, 'scaling')
    TransformMatrix(1,1) = 1/TransformMatrix(1,1); TransformMatrix(2,2) = 1/TransformMatrix(2,2);
    InvertedMatrix = TransformMatrix;
elseif strcmp(TransformType, 'rotation')
    InvertedMatrix = TransformMatrix';
elseif strcmp(TransformType, 'translation')
    TransformMatrix(1,3) = -TransformMatrix(1,3); TransformMatrix(2,3) = -TransformMatrix(2,3);
    InvertedMatrix = TransformMatrix;
elseif strcmp(TransformType, 'reflection')
    InvertedMatrix = TransformMatrix;
elseif strcmp(TransformType, 'shear')
    coefficent = 1/(1-TransformMatrix(1,2)*TransformMatrix(2,1));
    TransformMatrix(1,2) = -TransformMatrix(1,2); TransformMatrix(2,1) = -TransformMatrix(2,1);
    InvertedMatrix = coefficent*TransformMatrix;
elseif strcmp(TransformType, 'affine')
    InvertedMatrix = inv(TransformMatrix);
elseif strcmp(TransformType, 'homography')
    InvertedMatrix = inv(TransformMatrix);
else
    error('ERROR: Unregonized TransformType');
end

end

