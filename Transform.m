classdef Transform

properties 
    x = 0;
    y = 0;
    z = 0;
    q = quaternion([0 0 0],'rotvec'); 
end 

methods 
    function this = Transform(x,y,z,q) 
        if nargin == 0
            this.x = 0; 
            this.y = 0; 
            this.z = 0; 
            this.q = quaternion([0 0 0],'rotvec'); 
        elseif nargin == 3
            this.x = x; 
            this.y = y; 
            this.z = z; 
            this.q = quaternion([0 0 0],'rotvec'); 
        else 
            this.x = x; 
            this.y = y; 
            this.z = z; 
            assert(isa(q,'quaternion'), 'q is not a quaternion!');
            this.q = q;
        end 
    end 
    
    function T = GetMatrix(this)
        T = eye(4); 
        T(1,4) = this.x; T(2,4) = this.y; T(3,4) = this.z; 
        T(1:3,1:3) = this.q.rotmat('frame'); 
    end 
    
    function Tinv = GetInverse(this)
        Tinv = zeros(4); 
        Tinv(4,4) = 1; 
        Tinv(1:3,1:3) = this.q.rotmat('frame')'; 
        Tinv(1:3,4) = -Tinv(1:3,1:3) * [this.x; this.y; this.z]; 
    end 
    
    function T = mtimes(this, transform2)
        assert(isa(transform2,'Transform'), 'T2 is not a Transform!'); 
        T1 = this.GetMatrix;
        T2 = transform2.GetMatrix; 
        T12 = T1*T2; 
        
        T = Transform(T12(1,4), T12(2,4), T12(3,4), ...
                        quaternion(T12(1:3,1:3), 'rotmat', 'frame')); 
    end 
end 
    
end 