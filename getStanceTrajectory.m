function xyzqtrajectory = getStanceTrajectory(currMat,targetMat,xyz_traj,Tw_f_mat, Tstance, Tstep)
% 1) rotation
quat = quaternion(currMat(1:3,1:3), 'rotmat', 'frame'); 
quat = quat.compact; 
quattarget = quaternion(targetMat(1:3,1:3), 'rotmat', 'frame');
quattarget = quattarget.compact; 

pts0 = [0 0 0 quat]';
pts1 = [0 0 0 quattarget]'; 

wpts = [pts0 pts1]; 
tpts = [0 Tstance];
tvec = 0:Tstep:Tstance; 

[xyzqtrajectory, ~, ~, ~] = cubicpolytraj(wpts, tpts, tvec); 

% 2) position 
% transform body trajectory (w.r.t. world) to 
% foot trajectory (w.r.t. body) 
% footMat: world to foot at the beginning of step 
% xyz_traj: world to body 
% straj:   body to foot through the step
npoints = length(xyzqtrajectory); 
Tliptraj = zeros(4,4,npoints); 
for idx2 = 1:npoints
    Tliptraj(4,4,idx2) = 1;
    % Get the rotational part of matrix from quaternion
%     Tliptraj(1:3,1:3,idx2) = eye(3); 
    quat = quaternion(xyzqtrajectory(4:7,idx2)'); 
    Tliptraj(1:3,1:3,idx2) = quat.rotmat('frame');
    % Get the positional part from trajectory w.r.t. world  
    Tliptraj(1:3,4,idx2) = xyz_traj(1:3,idx2); 
end 
Tliptraj(:,:,1)
Tw_f_mat

straj = zeros(3,npoints); 
for idx2 = 1:npoints
    temp1 = TransformInverse(Tliptraj(:,:,idx2)) * Tw_f_mat;
    straj(:,idx2) = temp1(1:3,4); 
end 

temp = length(xyzqtrajectory); 
xyzqtrajectory(1:3,1:temp) = straj(1:3,1:temp); 
end
