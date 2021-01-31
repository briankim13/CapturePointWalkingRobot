function tform = vec2Tform(vectorTrajectory)

%% Transform vector form of x;y;z;q to transform matrix
q = quaternion(reshape(vectorTrajectory(4:7),1,4)); 
rmat = q.rotmat('frame');
tform = eye(4);
tform(1:3,1:3) = rmat; 
tform(1:3,4) = vectorTrajectory(1:3); 

end