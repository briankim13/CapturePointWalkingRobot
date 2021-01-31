function matInv = TransformInverse(mat)
    matInv = zeros(4); 
    matInv(4,4) = 1; 
    matInv(1:3,1:3) = mat(1:3,1:3)'; 
    matInv(1:3,4) = -matInv(1:3,1:3) * mat(1:3,4);
end