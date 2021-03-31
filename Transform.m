classdef Transform < handle
% Helper class to handle 4x4 transform 

% Copyright 2021 Wooshik Brian Kim
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"), 
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
% and/or sell copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included 
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
% THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
% OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
% OR OTHER DEALINGS IN THE SOFTWARE.

properties 
    x = 0;
    y = 0;
    z = 0;
    q = quaternion([0 0 0],'rotvec'); 
    axesLength = 1; 
end 

methods 
    function this = Transform(x,y,z,rotationInfo) 
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
            if isa(rotationInfo,'quaternion')
                this.q = rotationInfo; 
            elseif all(size(rotationInfo) == [3,3])
                this.q = quaternion(rotationInfo, 'rotmat', 'frame'); 
            end
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
    
    function SetAxes(this, axesLength)
        this.axesLength = axesLength; 
    end
    
    function [hXdir, hYdir, hZdir, this] = Draw(this, hAxes, color, axesLength)
        arguments 
            this
            hAxes 
            color {mustBeNumeric} = [0 0.4470 0.7410];
            axesLength {mustBeNumeric} = 1; 
        end 
        mat = this.GetMatrix; 
        X = mat(1,4); Y = mat(2,4); Z = mat(3,4); 
        mat(1:3,1:3) = mat(1:3,1:3)*axesLength; % by default the length is one 
        this.axesLength = axesLength; 
        hXdir = plot3(hAxes, [X, X+mat(1,1)], [Y, Y+mat(2,1)], [Z, Z+mat(3,1)], 'Color', color); 
        hYdir = plot3(hAxes, [X, X+mat(1,2)], [Y, Y+mat(2,2)], [Z, Z+mat(3,2)], 'Color', color);
        hZdir = plot3(hAxes, [X, X+mat(1,3)], [Y, Y+mat(2,3)], [Z, Z+mat(3,3)], 'Color', color);
    end 
    
    function UpdateDraw(this, hXdir, hYdir, hZdir, axesLength)
        arguments
            this
            hXdir
            hYdir
            hZdir
            axesLength {mustBeNumeric} = 1; 
        end
        mat = this.GetMatrix; 
        X = mat(1,4); Y = mat(2,4); Z = mat(3,4); 
        mat(1:3,1:3) = mat(1:3,1:3) * axesLength; 
        hXdir.XData = [X, X+mat(1,1)]; hXdir.YData = [Y, Y+mat(2,1)]; hXdir.ZData = [Z, Z+mat(3,1)]; 
        hYdir.XData = [X, X+mat(1,2)]; hYdir.YData = [Y, Y+mat(2,2)]; hYdir.ZData = [Z, Z+mat(3,2)];
        hZdir.XData = [X, X+mat(1,3)]; hZdir.YData = [Y, Y+mat(2,3)]; hZdir.ZData = [Z, Z+mat(3,3)];
    end
end

methods (Static)
    function matInv = Inverse(mat)
        matInv = zeros(4); 
        matInv(4,4) = 1; 
        matInv(1:3,1:3) = mat(1:3,1:3)'; 
        matInv(1:3,4) = -matInv(1:3,1:3) * mat(1:3,4);
    end
end 
    
end 