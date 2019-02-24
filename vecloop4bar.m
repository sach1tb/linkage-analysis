function F=vecloop4bar(x, a,b,c,d,t2)
% vector loop equations for fourbar linkage
% x is a vector of unknown variables, in this case, t3 and t4
% a,b,c,d, and t2 are as defined in fourbar.png

% initial guess
t3=x(1);
t4=x(2);

% vector loop equations
F(1)=a*cos(t2)+b*cos(t3)-c*cos(t4)-d;
F(2)=a*sin(t2)+b*sin(t3)-c*sin(t4);