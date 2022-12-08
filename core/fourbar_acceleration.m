function [alphaCouplerOpen, alphaCouplerCross, alphaOutputOpen, alphaOutputCross, omegaCouplerOpen, omegaCouplerCross, omegaOutputOpen, omegaOutputCross, thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross]=...
    fourbar_acceleration(crankLength, couplerLength, outputLength, groundLength, alphaCrank, omegaCrank, thetaCrank, alphaGround, omegaGround, thetaGround)
% fourbar_acceleration performs, acceleration, velocity & position analysis 
% of crankLength fourbar linkage according to the convention in fourbar.png
% 
% Syntax
%
%   [alphaCouplerOpen, ~, alphaOutputOpen, ~, omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_acceleration(crankLength, couplerLength, outputLength, groundLength, alphaCrank, omegaCrank, thetaCrank)
%   [alphaCouplerOpen, ~, alphaOutputOpen, ~, omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_acceleration(crankLength, couplerLength, outputLength, groundLength, alphaCrank, omegaCrank, thetaCrank, alphaGround, omegaGround, thetaGround)
% Description
%
%   [alphaCouplerOpen, ~, alphaOutputOpen, ~, omegaCouplerOpen, ~, omegaOutputOpen, ~, thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_acceleration(crankLength, couplerLength, outputLength, groundLength, alphaCrank, omegaCrank, thetaCrank)
%   takes as input the link lengths crankLength, couplerLength, outputLength, groundLength, and the angular acceleration(s)
%   alphaCrank in rad/s^2, angular velocity(s) omegaCrank in rad/s and angle(s) thetaCrank for the 
%   input link in radians and returns the angular accelerations alphaCouplerOpen and alphaOutputOpen 
%   angular velocities omegaCouplerOpen and omegaOutputOpen and orientations for the 
%   coupler and output links in the open configuration

% omegaCrank=w20+alphaCrank*t;
% thetaCrank=w20.*t+0.5*alphaCrank*t.^2;
if nargin < 8
    alphaGround=0;
    omegaGround=0;
    thetaGround=0;
end

% if thetaGround is passed as crankLength single value but thetaCrank as more then
if numel(thetaCrank) > 1 && numel(thetaGround) ==1
    thetaGround=thetaGround*ones(1,numel(thetaCrank));
end


[omegaCouplerOpen, omegaCouplerCross, omegaOutputOpen, omegaOutputCross, ...
    thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross]=fourbar_velocity(crankLength, couplerLength, outputLength, groundLength, omegaCrank, thetaCrank, omegaGround, thetaGround);

% acceleration analysis
% open configuration
% A=outputLength*sin(thetaOutputOpen);
% B=couplerLength*sin(thetaCouplerOpen);
% C=crankLength*alphaCrank.*sin(thetaCrank) + crankLength*omegaCrank.^2.*cos(thetaCrank) + couplerLength*omegaCouplerOpen.^2.*cos(thetaCouplerOpen) - outputLength*omegaOutputOpen.^2.*cos(thetaOutputOpen);
% D=outputLength*cos(thetaOutputOpen);
% E=couplerLength*cos(thetaCouplerOpen);
% F=crankLength*alphaCrank.*cos(thetaCrank) - crankLength*omegaCrank.^2.*sin(thetaCrank) - couplerLength*omegaCouplerOpen.^2.*sin(thetaCouplerOpen) + outputLength*omegaOutputOpen.^2.*sin(thetaOutputOpen);

% alphaCouplerOpen=(C.*D-A.*F)./(A.*E-B.*D);
% alphaOutputOpen=(C.*E-B.*F)./(A.*E-B.*D);

% alphaCouplerOpen-a3ot
% alphaOutputOpen-a4ot

% cross configuration
% A=outputLength*sin(thetaOutputCross);
% B=couplerLength*sin(thetaCouplerCross);
% C=crankLength*alphaCrank.*sin(thetaCrank) + crankLength*omegaCrank.^2.*cos(thetaCrank) + couplerLength*omegaCouplerCross.^2.*cos(thetaCouplerCross) - outputLength*omegaOutputCross.^2.*cos(thetaOutputCross);
% D=outputLength*cos(thetaOutputCross);
% E=couplerLength*cos(thetaCouplerCross);
% F=crankLength*alphaCrank.*cos(thetaCrank) - crankLength*omegaCrank.^2.*sin(thetaCrank) - couplerLength*omegaCouplerCross.^2.*sin(thetaCouplerCross) + outputLength*omegaOutputCross.^2.*sin(thetaOutputCross);
% 
% 
% alphaCouplerCross=(C.*D-A.*F)./(A.*E-B.*D);
% alphaOutputCross=(C.*E-B.*F)./(A.*E-B.*D);


% full version for complex linkages
% -(- groundLength*cos(thetaGround - t3)*omegaGround^2 + crankLength*cos(thetaCrank - t3)*omegaCrank^2 + couplerLength*w3^2 - outputLength*cos(t3 - t4)*w4^2 + ...
% crankLength*alphaCrank*sin(thetaCrank - t3) - alphaGround*groundLength*sin(thetaGround - t3))/(outputLength*sin(t3 - t4))
alphaOutputOpen=-(- groundLength.*cos(thetaGround - thetaCouplerOpen).*omegaGround.^2 + crankLength.*cos(thetaCrank - thetaCouplerOpen).*omegaCrank.^2 + couplerLength.*omegaCouplerOpen.^2 - outputLength.*cos(thetaCouplerOpen - thetaOutputOpen).*omegaOutputOpen.^2 + ...
    crankLength.*alphaCrank.*sin(thetaCrank - thetaCouplerOpen) - alphaGround.*groundLength.*sin(thetaGround - thetaCouplerOpen))./(outputLength.*sin(thetaCouplerOpen - thetaOutputOpen));
alphaCouplerOpen=(groundLength.*cos(thetaGround - thetaOutputOpen).*omegaGround.^2 - crankLength.*cos(thetaCrank - thetaOutputOpen).*omegaCrank.^2 - couplerLength.*cos(thetaCouplerOpen - thetaOutputOpen).*omegaCouplerOpen.^2 + outputLength.*omegaOutputOpen.^2 -...
    crankLength.*alphaCrank.*sin(thetaCrank - thetaOutputOpen) + alphaGround.*groundLength.*sin(thetaGround - thetaOutputOpen))./(couplerLength.*sin(thetaCouplerOpen - thetaOutputOpen));


alphaOutputCross=-(- groundLength.*cos(thetaGround - thetaCouplerCross).*omegaGround.^2 + crankLength.*cos(thetaCrank - thetaCouplerCross).*omegaCrank.^2 + couplerLength.*omegaCouplerCross.^2 - outputLength.*cos(thetaCouplerCross - thetaOutputCross).*omegaOutputCross.^2 + ...
    crankLength.*alphaCrank.*sin(thetaCrank - thetaCouplerCross) - alphaGround.*groundLength.*sin(thetaGround - thetaCouplerCross))./(outputLength.*sin(thetaCouplerCross - thetaOutputCross));
alphaCouplerCross=(groundLength.*cos(thetaGround - thetaOutputCross).*omegaGround.^2 - crankLength.*cos(thetaCrank - thetaOutputCross).*omegaCrank.^2 - couplerLength.*cos(thetaCouplerCross - thetaOutputCross).*omegaCouplerCross.^2 + outputLength.*omegaOutputCross.^2 -...
    crankLength.*alphaCrank.*sin(thetaCrank - thetaOutputCross) + alphaGround.*groundLength.*sin(thetaGround - thetaOutputCross))./(couplerLength.*sin(thetaCouplerCross - thetaOutputCross));

