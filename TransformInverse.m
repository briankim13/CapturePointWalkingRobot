function matInv = TransformInverse(mat)
    assert(size(mat,1) == 4);
    assert(size(mat,2) == 4);
    matInv = zeros(size(mat)); 
    matInv(4,4,:) = 1; 
    % do transpose... matInv(1:3,1:3) = mat(1:3,1:3)'
    for idx = 1:size(mat,3)
        matInv(1:3,1:3,idx) = mat(1:3,1:3,idx)';
    end
    for idx = 1:size(mat,3)
        matInv(1:3,4,idx) = -matInv(1:3,1:3,idx) * mat(1:3,4,idx);
    end
end