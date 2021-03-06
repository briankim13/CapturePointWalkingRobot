function tform = xyzq2Tform(xyzq)

val = reshape(xyzq(4:7),1,4); 
q = quaternion(val); 
rmat = q.rotmat('frame');
tform = eye(4);
tform(1:3,1:3) = rmat; 
tform(1:3,4) = xyzq(1:3); 

end 