function [thetaCoupler1, thetaCoupler2, sliderDistance1, sliderDistance2]=cs_position(crankLength, couplerLength,offset, thetaCrank)
%
% crank-slider (or slider-crank) position analysis
%
% Syntax
%
%   [thetaCoupler1, ~, sliderDistance1]=cs_position(crankLength, couplerLength,offset, thetaCrank)
%   [~, thetaCoupler2, ~, sliderDistance2]=cs_position(crankLength, couplerLength,offset, thetaCrank)
%
% Description
%   [thetaCoupler1, ~, sliderDistance1]=cs_position(crankLength, couplerLength,offset, thetaCrank) takes as input the link
%   lengths crankLength, couplerLength, offset, and the angle(s) thetaCrank for the input link in radians 
%   and returns the angles theta_3 in radians and distance d for one
%   configuration
%
%   [~, thetaCoupler2, ~, sliderDistance2]=cs_position(crankLength, couplerLength,offset, thetaCrank) takes as input the link
%   lengths crankLength, couplerLength, offset, and the angle(s) thetaCrank for the input link in radians 
%   and returns the angles theta_3 in radians and distance d for the other
%   configuration

thetaCoupler1=asin((crankLength*sin(thetaCrank)-offset)/couplerLength);
thetaCoupler2=pi-thetaCoupler1;

sliderDistance1=crankLength*cos(thetaCrank)-couplerLength*cos(thetaCoupler1);
sliderDistance2=crankLength*cos(thetaCrank)-couplerLength*cos(thetaCoupler2);
