function [omegaCouplerOpen, omegaCouplerCross, omegaOutputOpen, omegaOutputCross, ...
    thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank, omegaGround, thetaGround)
% fourbar_velocity performs velocity & position analysis of crankLength 
% fourbar linkage according to the convention in fourbar.png
% 
% Syntax
%
%   [omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank)
%   [omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank)
%   [omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank, omegaGround, thetaGround)
%   [~, omegaCouplerCross, ~, omegaOutputCross, ~, thetaCouplerCross, ~, thetaOutputCross]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank)
%   [~, omegaCouplerCross, ~, omegaOutputCross, ~, thetaCouplerCross, ~, thetaOutputCross]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank, omegaGround, thetaGround)
%
% Description
%
%   [omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank)
%   takes as input the link lengths crankLength, couplerLength, outputLength, groundLength, and the angular velocity(s)
%   omegaCrank in rad/s and angle(s) thetaCrank for the input link in radians 
%   and returns the angular velocity omegaCouplerOpen and omegaOutputOpen and orientations for the 
%   coupler and output links in the open configuration
%
%   [omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank) returns
%   the angular velocity and orientations for the 
%   coupler and output links in the open configuration for 2 seconds

if nargin<7 
    omegaGround=0; thetaGround=0; 
end
if nargin<6 
    thetaCrank=omegaCrank*(0:.01:2); 
    omegaGround=0; thetaGround=0;
end

[thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround);

omegaCouplerOpen=crankLength.*omegaCrank.*sin(thetaOutputOpen-thetaCrank)./(couplerLength.*sin(thetaCouplerOpen-thetaOutputOpen)) + ...
    groundLength.*omegaGround.*sin(thetaOutputOpen-thetaGround)./(couplerLength.*sin(thetaOutputOpen-thetaCouplerOpen));
omegaOutputOpen=crankLength.*omegaCrank.*sin(thetaCrank-thetaCouplerOpen)./(outputLength.*sin(thetaOutputOpen-thetaCouplerOpen)) + ...
    groundLength.*omegaGround.*sin(thetaCouplerOpen-thetaGround)./(outputLength.*sin(thetaOutputOpen-thetaCouplerOpen));

omegaCouplerCross=crankLength.*omegaCrank.*sin(thetaOutputCross-thetaCrank)./(couplerLength.*sin(thetaCouplerCross-thetaOutputCross)) + ...
    groundLength.*omegaGround.*sin(thetaOutputCross-thetaGround)./(couplerLength.*sin(thetaOutputCross-thetaCouplerCross));
omegaOutputCross=crankLength.*omegaCrank.*sin(thetaCrank-thetaCouplerCross)./(outputLength.*sin(thetaOutputCross-thetaCouplerCross)) + ...
    groundLength.*omegaGround.*sin(thetaCouplerCross-thetaGround)./(outputLength.*sin(thetaOutputCross-thetaCouplerCross));
        

