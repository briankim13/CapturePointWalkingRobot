% Walking Robot Startup Script
%
% Copyright 2017-2019 The MathWorks, Inc.

%% Load basic robot parameters from modeling and simulation example
robotParameters

%% 
g = 9.807; 
Ts = 0.005; 
plane_x = 30; 
%original time constant was too small and motion was not smooth enough
motion_time_constant = 0.005; 
contact_damping = 4000; 

zRobot = 0.78;
zModel = 0.68; 
swingHeight = 0.1; 

desiredStepTime = 0.8; 

% create a struct for helper functions to use 
robotParam.Ts = Ts; 
robotParam.zRobot = zRobot; 
robotParam.zModel = zModel; 

desiredFootTransforms = cell(6, 1); 
desiredCapturePoints = zeros(6, 2);
R = [0 -1 0;0 0 1;-1 0 0]; 
Tb_fl = Transform(-0.12, 0, 0, R);
Tb_fr = Transform( 0.12, 0, 0, R);
Tw_b = Transform(0, 0, 0); 

walkStyle = 2; % 1, 2
if walkStyle == 1 
    % set the capture point so that the robot will rotate some degree every step 
    for idx = 1:length(desiredCapturePoints)
        deltaYaw = deg2rad(15);  
        q = quaternion([0 0 deltaYaw], 'rotvec'); 
        Tb_bp = Transform(0,0,0,q); 
        Tw_b = Tb_bp * Tw_b; 
    
        if mod(idx,2) > 0 
            Tw_fl = Tw_b*Tb_fl;
            desiredFootTransforms{idx} = Tw_fl; 
            desiredCapturePoints(idx,1:2) = [Tw_fl.x; Tw_fl.y]; 
        else 
            Tw_fr = Tw_b*Tb_fr; 
            desiredFootTransforms{idx} = Tw_fr; 
            desiredCapturePoints(idx,1:2) = [Tw_fr.x; Tw_fr.y]; 
        end 
    end 
else
    % TODO; create transform array as well 
    % Walk in straigt line 
    desiredCapturePoints = [-0.12 0.1;
                             0.12 0.2;
                            -0.12 0.4;
                             0.12 0.5;
                            -0.12 0.5;
                             0.12 0.5]; 
end 

% for now footholds and capture point EOS are same 
desiredfootholds = desiredCapturePoints; 

% Create the Linear Inverted Pendulum Model
% Create a discrete state-space model of the linear inverted pendulum.
w = sqrt(g/zModel); 
w2 = g/zModel; 
A = [0   1 0  0
     w2  0 0  0
     0   0 0  1
     0   0 w2 0]; 
B = [0  0
    -w2 0
     0  0
     0  -w2]; 
C = [1 0 0 0
     0 0 1 0]; 
D = [0 0;0 0]; 

lipm = ss(A,B,C,D); 
lipmD = c2d(lipm, Ts); 

Ad = lipmD.A; 
Bd = lipmD.B;
Cd = lipmD.C;
Dd = lipmD.D;
% Initial State
% In this example, the robot will start walking with its center of mass (COM) positioned right above the right foot. 
x0  = 0.12; 
dx0 = 0; 
y0  = 0; 
dy0 = 0; 
state0 = [x0 dx0 y0 dy0]'; 
robotpos0 = [0; 0; zModel]; 

xc = x0; 
yc = y0;
dxc = dx0; 
dyc = dy0; 
cpointx = xc + dxc/w; 
cpointy = yc + dyc/w; 