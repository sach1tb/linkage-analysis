function [bddot, a3, bdot, w3, b, t3]=threebar_acceleration(a, c, a2, w2, t2, t4)

[bdot, w3, b, t3]=threebar_velocity(a, c, w2, t2, t4);


% needs update
bddot=bdot*0;
a3=w3*0;
        

