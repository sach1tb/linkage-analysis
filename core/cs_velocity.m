function [omegaCoupler1, omegaCoupler2, sliderVelocity1, sliderVelocity2, ...
    thetaCoupler1, thetaCoupler2, sliderDistance1, sliderDistance2]=cs_velocity(crankLength, couplerLength, offset, omegaCrank, thetaCrank, omegaGround, thetaGround)
% cs_velocity performs velocity & position analysis of crankLength 
% crank slider linkage according to the convention in crankslider.png
% 
% Syntax
%
%   [omegaCoupler1, ~, sliderVelocity1, ~, thetaCoupler1, ~, sliderDistance1]=cs_velocity(crankLength, couplerLength, offset, omegaCrank, thetaCrank)
%
% Description
%
%   [omegaCoupler1, ~, sliderVelocity1, ~, thetaCoupler1, ~, sliderDistance1]=cs_velocity(crankLength, couplerLength, offset, omegaCrank, thetaCrank)
%   takes as input the link lengths crankLength, couplerLength, offset, and the angular velocity(s)
%   omegaCrank in rad/s and angle(s) thetaCrank for the input link in radians 
%   and returns the angular velocity omegaCoupler1 and sliding link velocity sliderVelocity1
%

if nargin<6 
    omegaGround=0; thetaGround=0; 
end

[thetaCoupler1, thetaCoupler2, sliderDistance1, sliderDistance2]=cs_position(crankLength, couplerLength, offset, thetaCrank, thetaGround);


omegaCoupler1=crankLength*cos(thetaCrank)./(couplerLength*cos(thetaCoupler1)).*omegaCrank;
sliderVelocity1=-crankLength*omegaCrank*sin(thetaCrank)+couplerLength*omegaCoupler1.*sin(thetaCoupler1);

omegaCoupler2=crankLength*cos(thetaCrank)./(couplerLength*cos(thetaCoupler2)).*omegaCrank;
sliderVelocity2=-crankLength*omegaCrank*sin(thetaCrank)+couplerLength*omegaCoupler2.*sin(thetaCoupler2);


