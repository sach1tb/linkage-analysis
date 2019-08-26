function [A, B, P]=fbloop(O2, A, B, O4, APlen, BAP, t2)

R2=A-O2;
R3=B-A;
R4=B-O4;
R1=O4-O2;

% check validity with 0.01 tolerance
if norm(R2+R3-R1-R4)> 0.01
    error('invalid link lengths');
end