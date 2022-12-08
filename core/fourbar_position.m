function [thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross, A, B, C]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround)
% fourbar_position performs position analysis of crankLength fourbar linkage
% according to the convention in fourbar.png
% 
% Syntax
%
%   [thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank)
%   [thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround)
%   [~, thetaCouplerCross, ~, thetaOutputCross]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank)
%   [~, thetaCouplerCross, ~, thetaOutputCross]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround)
%   [thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross, A, B, C]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank)
%   [thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross, A, B, C]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround)
%
% Description
%   [thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank) takes as input the link
%   lengths crankLength, couplerLength, outputLength, groundLength, and the angle(s) thetaCrank for the input link in radians 
%   and returns the angles theta_3 and theta_4 in radians in the open 
%   configuration
%
%   [thetaCouplerOpen, ~, thetaOutputOpen]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank, thetaGround) allows crankLength tilted
%   ground with angle thetaGround in radians
%
%   [~, thetaCouplerCross, ~, thetaOutputCross]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank) for cross
%   configuration
%
%   [thetaCouplerOpen, thetaCouplerCross, thetaOutputOpen, thetaOutputCross, A, B, C]=fourbar_position(crankLength, couplerLength, outputLength, groundLength, thetaCrank) to see
%   all values including those of constants A, B, and C
%
%
% Reference
%   [1] R. L. Norton, Design of Machinery, McGrawHill
%
% SB, MEE320, NIU, 2018
%
% Known bugs: 
% 1) does not work for pi - 2pi range for parallelogram linkages (3/2019)

if nargin<6, thetaGround=0; end

K1=2*groundLength.*outputLength.*cos(thetaGround)-2*crankLength.*outputLength.*cos(thetaCrank);
K2=2*groundLength.*outputLength.*sin(thetaGround)-2*crankLength.*outputLength.*sin(thetaCrank);
K3=2*crankLength.*groundLength.*sin(thetaGround).*sin(thetaCrank) + 2*crankLength.*groundLength.*cos(thetaGround).*cos(thetaCrank);
K4=couplerLength.^2-crankLength.^2-outputLength.^2-groundLength.^2;

A=K4+K1+K3;
B=-2*K2;
C=K4-K1+K3;

if A==0, A=eps; end
thetaOutputCross=2*atan((-B-sqrt(B.^2-4*A.*C))./(2*A));
thetaOutputOpen=2*atan((-B+sqrt(B.^2-4*A.*C))./(2*A));

K5=2*crankLength.*couplerLength.*cos(thetaCrank)-2*couplerLength.*groundLength.*cos(thetaGround);
K6=2*crankLength.*couplerLength.*sin(thetaCrank)-2*couplerLength.*groundLength.*sin(thetaGround);
K7=2*crankLength.*groundLength.*sin(thetaGround).*sin(thetaCrank) + 2*crankLength.*groundLength.*cos(thetaGround).*cos(thetaCrank);
K8=(outputLength.^2-groundLength.^2-crankLength.^2-couplerLength.^2);


D=K8+K7+K5;
E=-2*K6;
F=K8-K5+K7;

if D==0, D=eps; end
thetaCouplerCross=2*atan((-E+sqrt(E.^2-4*D.*F))./(2*D));
thetaCouplerOpen=2*atan((-E-sqrt(E.^2-4*D.*F))./(2*D));
