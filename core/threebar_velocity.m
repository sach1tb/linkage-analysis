function [bdot, w3, b, t3]=threebar_velocity(a, c, w2, t2, t4)

[b, t3]=threebar_position(a, c, t2, t4);

bdot=-1./(2*sqrt(c^2+a^2-2*a*c*cos(t4-t2))).*(2*a*c*sin(t4-t2)).*(-w2);
w3=1./(1+((c*sin(t4)-a*sin(t2))./(c*cos(t4)-a*cos(t2))).^2).*...
            ((-a*w2*cos(t2)./(c*cos(t4)-a*cos(t2)))+...
            -((c*sin(t4)-a*sin(t2))./(c*cos(t4)-a*cos(t2)).^2).*...
            +a*w2.*sin(t2));
        

