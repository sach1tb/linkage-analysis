function fourbar_position_nr
% solve fourbar position analysis using newton raphson method

% this is the function that specifies the vector loop equations
fun = @root2d;
x0 = [0.2,1.5];

% command fsolve needs the function name and the initial estimate. 
% the solution can go either way! so open and crossed depends on the inital
% estimate
x = fsolve(fun,x0)

function F=root2d(x)

a=20; b=40; c=30; d=40;
t2=90*pi/180;

t3=x(1);
t4=x(2);

% vector loop equations
F(1)=a*cos(t2)+b*cos(t3)-c*cos(t4)-d;
F(2)=a*sin(t2)+b*sin(t3)-c*sin(t4);
