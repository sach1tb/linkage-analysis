function example16_pantograph_with_fourbar_aWard(A,B,C, P_left_right, FLOATER_DOTS, ...
    P_rise, crank_length, rpm, ground_angle, crank_start_angle, ...
    pant_anchor_up, pant_hinge_offset, square_weight, link_width, ...
    foot_force)
    

% the line below adds the core scripts to the current working directory
addpath ../core

% This script allows you to utilize data from the Hrones and Nelson Atlas
% to develop a simple leg unit with a Pantograph to amplify output of the
% driving fourbar linkage. PVA and torque analyses are performed on the 
% entire leg mechanism, taking into account masses and moments of inertia
% for all links. 

%% Developed by Anthony Ward

%% Enter scaling factors from the Hrones and Nelson Atlas here
if nargin < 1
A= 1.5 ;  % A value from H&N Atlas or Scaling Factor Floating Link : Crank
B= 2.5 ;  % B value from H&N Atlas or Scaling Factor Rocker : Crank
C= 2.5 ;  % C value from H&N Atlas or Scaling Factor Ground : Crank
% Number of dots from end of crank to coupler P position 
% (right positive, left negative)
P_left_right= 7 ;

% Number of dots that comprise the length of the floating link on the atlas
% page (MUST BE A POSITIVE NUMBER)
FLOATER_DOTS = 6 ;

% Number of dots up or down to the coupler P position (up positive, down negative)
P_rise= 1 ;

%% Enter Crank Length Here
crank_length=28;

%% Enter Rotation Rate and Link Orientations Here
rpm= -30 ; %rotation rate in rpm

% Support for values of alpha_2 other than 0 are not currently supported
a2=0;       % alpha_2 (crank angular acceleration) rad/s^2

ground_angle = -56 ; %fourbar ground link orientation (in degrees)

crank_start_angle = 90 ; %starting crank angle relative to ground link (in degrees)
 

%% Pantograph Settings
% Adjust these to make sure the pantograph does not bind up anywhere

% PANT_ANCHOR_UP is the height above the rightmost point of the fourbar
% coupler curve that the anchor point for the pantograph will sit.
pant_anchor_up=180;

% PANT_HINGE_OFFSET is the distance the outside hinge point of the
% pantograph sits to the right of the rightmost point of the fourbar 
% coupler curve.
pant_hinge_offset=80;

%% Enter Physical Properties Here

% Default weight/area is for 3/16" (4.5mm) thick acrylic and is in kg/m^2
% Check here for more thickness values:
% https://www.usplastic.com/knowledgebase/article.aspx?contentkey=884
% multiply by (0.454/0.0929) for unit conversion
square_weight= 5.234 ;

% Default width of straight links in base units (default mm)
link_width=13;

% Force at foot to simulate weight supported by leg in kilograms
foot_force = .5;
end
% Height above the bottom of the foot path where the force begins to be
% applied: simulates ground contact prior to foot bottoming out its stroke,
% which would indicate that the leg is lifting the frame of the walker
% slightly as it makes contact with the ground
force_height=20; %mm

max_torque= 0.2; %Maximum output torque of driving motor in N-m


num_cycles= 1 ; %number of coupler curve cylces to be plotted 

%% Enter number of plot points here 
% Higher numbers provide better accuracy but take significantly longer to
% calculate
num_steps=50;


%% Enter base length units here
% Functionality has not been added to account for unit conversions
% All length values will currently be evaluated in mm
% Change this at your own risk
units= 'mm' ;










































%% DONT TOUCH ANYTHING FROM HERE ONWARD
% Gravity
g=-9.80665;
sign_P_rise=sign(P_rise);
if sign_P_rise==0; sign_P_rise=-1;end    
a=crank_length; b=A*crank_length; c=B*crank_length; d=C*crank_length;
AP_scale=abs(norm([P_left_right P_rise])/FLOATER_DOTS);
APlen=AP_scale*b; 
BAP=atan2(P_rise,P_left_right); 
w2=2*pi*rpm/60; % omega_2 (crank angular velocity) rad/s
simTime=num_cycles*2*pi/abs(w2);
t=linspace(0,simTime, num_steps);
t1=ground_angle*pi/180;
t2=crank_start_angle*pi/180+t1+w2*t;
[a3o, ~ , a4o, ~ , w3o, ~ , w4o, ~ , t3o, ~ , t4o]=fourbar_acceleration(a,b,c,d,a2,w2,t2,0,0,t1);
px=a*cos(t2)+APlen*cos(t3o+BAP);
py=a*sin(t2)+APlen*sin(t3o+BAP);
v_px=-a*w2*sin(t2)-APlen*w3o.*sin(t3o);
v_py=a*w2*cos(t2)+APlen*w3o.*cos(t3o);
a_px=-a*a2*sin(t2)-a*(w2.^2).*cos(t2)-APlen*a3o.*sin(t3o)-APlen*(w3o.^2).*cos(t3o);
a_py=a*a2*cos(t2)-a*(w2.^2).*sin(t2)+APlen*a3o.*cos(t3o)-APlen*(w3o.^2).*sin(t3o);
p_length=(px.^2+py.^2).^(1/2);
[pant_anchor_x,px_max_index]=max(px);
pant_anchor_y=py(px_max_index)+pant_anchor_up;
pant_anchor_length=norm([pant_anchor_x pant_anchor_y]);
pant_length=norm([pant_anchor_up pant_hinge_offset]);
tp=atan2(py,px);
tpant=atan(pant_anchor_y/pant_anchor_x);
wp=w4o+w3o;
ap=a4o+a3o;

[ ~ ,apant_link, ~ , apant_anchor, ~ , wpant_link, ~ , wpant_anchor, ~ , tpant_link, ~ , tpant_anchor]=...
    fourbar_acceleration(p_length,pant_length/2,pant_length/2,pant_anchor_length,ap,wp,tp,0,0,tpant);

v_footpath_x=v_px-(-pant_length/2*wpant_link.*sin(tpant_link))+(-pant_length/2*wpant_anchor.*sin(wpant_anchor));

v_footpath_y=v_py-(pant_length/2*wpant_link.*cos(tpant_link))+(pant_length/2*wpant_anchor.*cos(wpant_anchor));

a_footpath_x=a_px -(-pant_length/2*apant_link.*sin(tpant_link)-pant_length/2*(wpant_link.^2).*cos(tpant_link))...
                  +(-pant_length/2*apant_anchor.*sin(tpant_anchor)-pant_length/2*(wpant_anchor.^2).*cos(tpant_anchor));

a_footpath_y=a_py -(pant_length/2*apant_link.*cos(tpant_link)-pant_length/2*(wpant_link.^2).*sin(tpant_link))...
                  +(pant_length/2*apant_anchor.*cos(tpant_anchor)-pant_length/2*(wpant_anchor.^2).*sin(tpant_anchor));
 
              
straight_link_lengths = [a c pant_length/2 pant_length]/1000;
[I_straight_links,M_links]=line_link_moment(square_weight,link_width/1000,straight_link_lengths);





%% Coupler Mass, Moment, and CG
if P_rise~=0
    A_coupler=(b/1000)*(abs(APlen*sin(BAP))/1000)/2;
else
    A_coupler=(max([APlen b-APlen*sign(P_left_right) b])/1000)*(link_width/1000);
end
m_coupler=A_coupler*square_weight;
if P_rise==0
    I_coupler=m_coupler/12*...
        ((link_width/1000)^2+(max([APlen b-APlen*sign(P_left_right) b])/1000)^2);
else
    I_coupler=m_coupler/12*...
        ((APlen*sin(BAP)/1000)^2+(b/1000)^2 ...
            -(APlen/1000*cos(BAP)*APlen/1000*sin(BAP))+...
                (APlen/1000*cos(BAP))^2);
end

footpath_x=zeros(1,num_steps);
footpath_y=zeros(1,num_steps);

for iter=1:num_steps
    [footpath_x(iter),footpath_y(iter)]=pantograph_plot(p_length(iter),pant_length/2,...
        pant_length/2,pant_anchor_length,tp(iter),...
        tpant_link(iter),tpant_anchor(iter),tpant,0);
end

%% Torque Analysis
% Crank
rCG_crank=a/2/1000;
I_crank=I_straight_links(1);
m_crank=M_links(1);

% Coupler
if P_rise==0
    % rCG_coupler_23
    if P_left_right>=FLOATER_DOTS
        rCG_coupler_23=APlen/2/1000;
        rCG_coupler_34=abs(b/1000-rCG_coupler_23);
        rCG_coupler_pant=rCG_coupler_23;
        BAC_crank=0;
        if P_left_right>(2*FLOATER_DOTS)
            BAC_rocker=pi;
        else
            BAC_rocker=0;
        end
        BAC_pant=0;
    elseif P_left_right>=0
        rCG_coupler_23=b/2/1000;
        rCG_coupler_34=rCG_coupler_23;
        rCG_coupler_pant=abs(b/2/1000-APlen/1000);
        BAC_crank=0;
        BAC_rocker=0;
        BAC_pant=0;
    elseif P_left_right<0
        rCG_coupler_34=(b+APlen)/2/1000;
        rCG_coupler_23=abs(b/1000-rCG_coupler_34);
        rCG_coupler_pant=rCG_coupler_34;
        BAC_crank=pi;
        BAC_rocker=0;
        BAC_pant=pi;
    end
else
    a_AP=APlen*cos(BAP)/1000;
    h_AP=APlen*sin(BAP)/1000;
    x_bar_coupler=(b/1000+a_AP)/3;
    y_bar_coupler=h_AP/3;
    
    BAC_crank=atan2(y_bar_coupler,x_bar_coupler);
    BAC_rocker=atan2(-y_bar_coupler,b/1000-x_bar_coupler);
    BAC_pant=atan2(h_AP-y_bar_coupler,a_AP-x_bar_coupler);
    
    rCG_coupler_23=norm([a_AP h_AP]);
    
    rCG_coupler_34=norm([b/1000-a_AP h_AP]);
    
    rCG_coupler_pant=norm([a_AP-x_bar_coupler h_AP-y_bar_coupler]);
end

% Rocker
rCG_rocker=c/2/1000;
I_rocker=I_straight_links(2);
m_rocker=M_links(2);

% Upward Pant Link/Pant Foot
rCG_pant_link=pant_length/2/2/1000;
I_pant_link=I_straight_links(3);
m_pant_link=M_links(3);

% Pant Anchor Link/Downward Link
rCG_pant_anchor=pant_length/2/1000;
I_pant_anchor=I_straight_links(4);
m_pant_anchor=M_links(4);
    
% Joint Positions
% Crank/Ground
R12=[   rCG_crank*cos(t2+pi);
        rCG_crank*sin(t2+pi)];
    
% Crank/Coupler    
R32=[   rCG_crank*cos(t2);
        rCG_crank*sin(t2)];

R23=[   rCG_coupler_23*cos(t3o+BAC_crank+pi);
        rCG_coupler_23*sin(t3o+BAC_crank+pi)];

% Coupler/Rocker
R43=[   rCG_coupler_34*cos(t3o+BAC_crank+BAC_rocker);
        rCG_coupler_34*sin(t3o+BAC_crank+BAC_rocker)];

R34=[   rCG_rocker*cos(t4o);
        rCG_rocker*sin(t4o)];
    
% Rocker/Ground    
R14=[   rCG_rocker*cos(t4o+pi);
        rCG_rocker*sin(t4o+pi)];

% Coupler/Pantograph
RP3=[   rCG_coupler_pant*cos(t3o+BAC_crank+BAC_pant);
        rCG_coupler_pant*sin(t3o+BAC_crank+BAC_pant)];
    
R3PUL=[   rCG_pant_link*cos(tpant_link+pi);
          rCG_pant_link*sin(tpant_link+pi)];
      
R3PLL=[   rCG_pant_link*cos(tpant_anchor+pi);
          rCG_pant_link*sin(tpant_anchor+pi)];      

% Upper Link/Anchor
RPaPUL=[    rCG_pant_link*cos(tpant_link);
            rCG_pant_link*sin(tpant_link)];
        
RPULPa=zeros(2,num_steps);
        
% Anchor/Ground
R1Pa=[  rCG_pant_anchor*cos(tpant_anchor+pi);
        rCG_pant_anchor*sin(tpant_anchor+pi)];
    
% Anchor/Foot
RPfPa=[ rCG_pant_anchor*cos(tpant_anchor);
        rCG_pant_anchor*sin(tpant_anchor)];
    
RPaPf=[ rCG_pant_anchor*cos(tpant_link);
        rCG_pant_anchor*sin(tpant_link)];
    
% Lower Link/Foot
RPfPLL=[    rCG_pant_link*cos(tpant_anchor);
            rCG_pant_link*sin(tpant_anchor)];
        
RPLLPf=     zeros(2,num_steps);

% Foot/Free End
RFPf=[  rCG_pant_anchor*cos(tpant_link+pi);
        rCG_pant_anchor*sin(tpant_link+pi)];
    
% Accelerations at CG
% joint 23
a23_x=-a*w2^2*cos(t2);
a23_y=-a*w2^2*sin(t2);

% crank
aCG_crank_x=-rCG_crank*w2^2*cos(t2);
aCG_crank_y=-rCG_crank*w2^2*sin(t2);

% coupler
aCG_coupler_x=a23_x+(-rCG_coupler_23*a3o.*sin(t3o+BAC_crank)...
                     -rCG_coupler_23*w3o.^2.*cos(t3o+BAC_crank));
aCG_coupler_y=a23_y+(rCG_coupler_23*a3o.*cos(t3o+BAC_crank)...
                     -rCG_coupler_23*w3o.^2.*sin(t3o+BAC_crank));

% rocker
aCG_rocker_x=   -rCG_rocker*a4o.*sin(t4o)...
                -rCG_rocker*w4o.^2.*cos(t4o);
aCG_rocker_y=   rCG_rocker*a4o.*cos(t4o)...
                -rCG_rocker*w4o.^2.*sin(t4o);

% upper link: a_px+  a_py+
aCG_UL_x=   a_px-rCG_pant_link*apant_link.*sin(tpant_link)...
             -rCG_pant_link*wpant_link.^2.*cos(tpant_link);
aCG_UL_y=   a_py+rCG_pant_link*apant_link.*cos(tpant_link)...
             -rCG_pant_link*wpant_link.^2.*sin(tpant_link);

% anchor
aCG_Pa_x=   -rCG_pant_anchor*apant_anchor.*sin(tpant_anchor)...
             -rCG_pant_anchor*wpant_anchor.^2.*cos(tpant_anchor);
aCG_Pa_y=   rCG_pant_anchor*apant_anchor.*cos(tpant_anchor)...
             -rCG_pant_anchor*wpant_anchor.^2.*sin(tpant_anchor);

% lower link
aCG_LL_x=   -rCG_pant_link*apant_anchor.*sin(tpant_anchor)...
             -rCG_pant_link*wpant_anchor.^2.*cos(tpant_anchor);
aCG_LL_y=   rCG_pant_link*apant_anchor.*cos(tpant_anchor)...
             -rCG_pant_link*wpant_anchor.^2.*sin(tpant_anchor);
         
% foot 
aCG_Pf_x=   -rCG_pant_anchor*apant_link.*sin(tpant_link)...
             -rCG_pant_anchor*wpant_link.^2.*cos(tpant_link);
aCG_Pf_y=   rCG_pant_anchor*apant_link.*cos(tpant_link)...
             -rCG_pant_anchor*wpant_link.^2.*sin(tpant_link);
         
% Matrix Algebra
x=zeros(21,num_steps);
for iter=1:num_steps
%     B Matrix
    B=[     m_crank*aCG_crank_x(iter);
            m_crank*(aCG_crank_y(iter)-g);
            I_crank*a2;
            m_coupler*aCG_coupler_x(iter);
            m_coupler*(aCG_coupler_y(iter)-g);
            I_coupler*a3o(iter);
            m_rocker*aCG_rocker_x(iter);
            m_rocker*(aCG_rocker_y(iter)-g);
            I_rocker*a4o(iter);
            m_pant_link*aCG_UL_x(iter);
            m_pant_link*(aCG_UL_y(iter)-g);
            I_pant_link*apant_link(iter);
            m_pant_link*aCG_LL_x(iter);
            m_pant_link*(aCG_LL_y(iter)-g);
            I_pant_link*apant_anchor(iter);
            m_pant_anchor*aCG_Pa_x(iter);
            m_pant_anchor*(aCG_Pa_y(iter)-g);
            I_pant_anchor*apant_anchor(iter)
            m_pant_anchor*aCG_Pf_x(iter);
            m_pant_anchor*(aCG_Pf_y(iter)-g);
            I_pant_anchor*apant_link(iter)];
    
    if (footpath_y(iter)-min(footpath_y))<=force_height
        B(20)=B(20)-foot_force*abs(g);
    end
    
    A=[ %crank    
        1 0 1 zeros(1,18);
        0 1 0 1 zeros(1,17);
        -R12(2,iter) R12(1,iter) -R32(2,iter) R32(1,iter) zeros(1,16) 1;
        %coupler
        0 0 -1 0 1 0 0 0 1 0 1 0 zeros(1,9);
        0 0 0 -1 0 1 0 0 0 1 0 1 zeros(1,9);
        0 0 R23(2,iter) -R23(1,iter) -R43(2,iter) R43(1,iter) 0 0 -RP3(2,iter) RP3(1,iter) -RP3(2,iter) RP3(1,iter) zeros(1,9);
        %rocker
        zeros(1,4) -1 0 1 0 zeros(1,13);
        zeros(1,4) 0 -1 0 1 zeros(1,13);
        zeros(1,4) R34(2,iter) -R34(1,iter) -R14(2,iter) R14(1,iter) zeros(1,13);
        %Upper Link
        zeros(1,8) -1 0 0 0 1 0 zeros(1,7);
        zeros(1,8) 0 -1 0 0 0 1 zeros(1,7);
        zeros(1,8) R3PUL(2,iter) -R3PUL(1,iter) 0 0 -RPULPa(2,iter) RPULPa(1,iter) zeros(1,7);
        %Lower Link
        zeros(1,10) -1 0 zeros(1,6) 1 0 0;
        zeros(1,10) 0 -1 zeros(1,6) 0 1 0;
        zeros(1,10) R3PLL(2,iter) -R3PLL(1,iter) zeros(1,6) -RPfPLL(2,iter) RPfPLL(1,iter) 0;
        %Anchor
        zeros(1,12) 1 0 1 0 1 0 0 0 0;
        zeros(1,12) 0 1 0 1 0 1 0 0 0;
        zeros(1,12) -RPaPUL(2,iter) RPaPUL(1,iter) -R1Pa(2,iter) R1Pa(1,iter) -RPfPa(2,iter) RPfPa(1,iter) 0 0 0;
        %Foot
        zeros(1,16) -1 0 -1 0 0;
        zeros(1,16) 0 -1 0 -1 0;
        zeros(1,16) RPaPf(2,iter) -RPaPf(1,iter) RPLLPf(2,iter) -RPLLPf(1,iter) 0];
    
    x(:,iter)=A\B;
end

% Plot Results
figure(1); gcf; clf;
set(gcf,'WindowState','maximized')
subplot(3,2,[1,3]);
    
for iter=1:num_steps
%     Footpath overlay 
    plot(footpath_x,footpath_y,'k-.','linewidth',2);
    
%     Driving Fourbar Linkage
    fourbar_plot_plus(a,b,c,d,BAP,APlen, t2(iter),t3o(iter),...
        t4o(iter),t1, eye(3));
    
%     Pantograph
    pantograph_plot(p_length(iter),pant_length/2,...
        pant_length/2,pant_anchor_length,tp(iter),...
        tpant_link(iter),tpant_anchor(iter),tpant,1,eye(3),...
        min([-a-10 min(footpath_x)-10]),max([max(px)+pant_hinge_offset*3 max(footpath_x)])...
        ,min([-pant_anchor_y-10 min(footpath_y)-10]),pant_anchor_y+10);
    
    drawnow;
    if iter~=num_steps cla; end
end

title('Linkage')

% Separate plot of Footpath
subplot(3,2,5);
plot(footpath_x,footpath_y-min(footpath_y), 'k-.', 'linewidth', 2);
set(gca, 'fontsize', 16, 'fontname', 'times');
title('Foot Path')
xlabel(units);
ylabel(units);
grid on;
axis image; % this makes sure you see the right aspect ratio

% Position Plot of foot path
subplot(3,2,2);
plot(t, footpath_x, 'linewidth',2); hold on; plot(t, footpath_y-min(footpath_y), 'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times'); 
title('Position');
ylabel(units);
grid on; legend('x', 'y');

%Velocity Plot of foot path
subplot(3,2,4);
plot(t, v_footpath_x, 'linewidth',2); hold on; plot(t, v_footpath_y, 'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
title('Velocity')
ylabel(strcat(units,'/s'));
grid on; legend('x', 'y');

% Acceleration pot of foot path
subplot(3,2,6);
plot(t, a_footpath_x, 'linewidth',2); hold on; plot(t, a_footpath_y, 'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
xlabel('time(s)'); 
ylabel(strcat(units,'/s^2'));
title('Acceleration')
grid on; legend('x', 'y');



F12=zeros(1,num_steps);
F32=zeros(1,num_steps);
F43=zeros(1,num_steps);
F14=zeros(1,num_steps);
FULC=zeros(1,num_steps);
FLLC=zeros(1,num_steps);
FAUL=zeros(1,num_steps);
F1A=zeros(1,num_steps);
FFA=zeros(1,num_steps);
FLLF=zeros(1,num_steps);
Tcrank=zeros(1,num_steps);


% Extract force values from x array
for iter=1:num_steps
    
    F12(iter)=norm([x(1,iter) x(2,iter)]);
    F32(iter)=norm([x(3,iter) x(4,iter)]);
    F43(iter)=norm([x(5,iter) x(6,iter)]);
    F14(iter)=norm([x(7,iter) x(8,iter)]);
    FULC(iter)=norm([x(9,iter) x(10,iter)]);
    FLLC(iter)=norm([x(11,iter) x(12,iter)]);
    FAUL(iter)=norm([x(13,iter) x(14,iter)]);
    F1A(iter)=norm([x(15,iter) x(16,iter)]);
    FFA(iter)=norm([x(17,iter) x(18,iter)]);
    FLLF(iter)=norm([x(19,iter) x(20,iter)]);
    Tcrank(iter)=x(21,iter);
    
end

figure(2); gcf;clf;

% Plot of 
subplot(3,2,1);
plot(t,F12,'linewidth',2);hold on; plot(t,F32,'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
ylabel('Newtons');
title('Forces in Link A');
legend('F_{A,ground}', 'F_{AB}');
xlim([0,3]);

subplot(3,2,2);
plot(t,F14,'linewidth',2);hold on; plot(t,F43,'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
ylabel('Newtons');
title('Forces in Link C');
legend('F_{C,ground}','F_{BC}');
xlim([0,3]);

subplot(3,2,3);
plot(t,FULC,'linewidth',2);hold on; plot(t,FLLC,'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
ylabel('Newtons');
title('Forces at P');
legend('F_{P_{UL}}','F_{P_{LL}}');
xlim([0,3]);

subplot(3,2,4);
plot(t,FAUL,'linewidth',2);hold on; plot(t,F1A,'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
ylabel('Newtons');
title('Forces in Link E');
legend('F_{P_{UL}E}','F_{E,ground}');
xlim([0,3]);

subplot(3,2,5);
plot(t,FFA,'linewidth',2);hold on; plot(t, FLLF,'linewidth',2);
set(gca, 'fontsize', 16, 'fontname', 'times');
xlabel('time (s)');
ylabel('Newtons');
title('Forces in Link F');
legend('F_{EF}','F_{P_{LL}F}');
xlim([0,3]);

subplot(3,2,6);
plot(t,Tcrank,'linewidth',2);hold on; 
plot(t,max_torque*(1+zeros(1,num_steps)),'r--','linewidth',1);
plot(t,-max_torque*(1+zeros(1,num_steps)),'r--','linewidth',1);
set(gca, 'fontsize', 16, 'fontname', 'times');
xlabel('time (s)');
title('Torque Required to Maintain RPM');
ylabel('N-m');
xlim([0,t(end)]);

set(gcf,'WindowState','maximized');







%% Nested Functions

function [foot_path_x,foot_path_y]=pantograph_plot(a,b,c,d, t2,t3,t4,t1,PLOT, clrs,XMIN,XMAX,YMIN,YMAX)


    % fourbar plot automatically adds ground orientation
    opos=0*exp(1i*t1);
    apos=a*exp(1i*t2);
    bpos=apos+b*exp(1i*t3);
    odpos=crank_length*exp(1i*t1);
    dpos=d*exp(1i*t1);
    cpos=dpos+c*exp(1i*t4);
    
    PUL_text_pos=apos+b/2*exp(1i*t3)+17*exp(1i*(t3+pi/2));
    PLL_text_pos=apos+c/2*exp(1i*t4)+10*exp(1i*(t4-pi/2));
    anchor_text_pos=dpos+3/4*c*exp(1i*t4)+10*exp(1i*(t4+pi/2));
    foot_text_pos=dpos+2*c*exp(1i*t4)+5/4*b*exp(1i*(t3+pi))+10*exp(1i*(t3-pi/2));

    % draw it if PLOT=true
    if PLOT
        % pantograph links
        % up
        quiver(real(apos), imag(apos), ...
            real(bpos-apos), imag(bpos-apos), 0, 'color', 'r', ...
            'linewidth', 2);
        plot(real(bpos), imag(bpos), 'ko', 'markersize', 6, 'linewidth', 2);
        PUL_text=text(real(PUL_text_pos),imag(PUL_text_pos),'P_{UL}');
        set(PUL_text,'HorizontalAlignment','center');
        % down
        quiver(real(apos), imag(apos), ...
            real(cpos-dpos), imag(cpos-dpos), 0, 'color', 'g', ...
            'linewidth', 2);
        plot(real(apos)+real(cpos-dpos), imag(apos)+imag(cpos-dpos), 'ko', 'markersize', 6, 'linewidth', 2);
        PLL_text=text(real(PLL_text_pos),imag(PLL_text_pos),'P_{LL}');
        set(PLL_text,'HorizontalAlignment','center');
       
        % rocker/output
        quiver(real(dpos), imag(dpos), ...
            real(cpos-dpos), imag(cpos-dpos), 0, 'color', clrs(3,:), ...
            'linewidth', 2);
        

        % ground
        plot(real(dpos), imag(dpos), 'ko', 'markersize', 6, 'linewidth', 1);
        plot(real(dpos), imag(dpos), 'ks', 'markersize', 10, 'linewidth', 2);
        quiver(real(odpos), imag(odpos), ...
            real(dpos-odpos), imag(dpos-odpos), 0, 'k', ...
            'linewidth', 1);
        
        % Anchor Link
        plot([real(dpos),real(dpos)+2*real(cpos-dpos)],[imag(dpos),imag(dpos)+...
            2*imag(cpos-dpos)],'b','linewidth',2);
        plot(real(dpos)+2*real(cpos-dpos),imag(dpos)+2*imag(cpos-dpos),'ko',...
            'markersize',6,'linewidth',2);
        anchor_text=text(real(anchor_text_pos),imag(anchor_text_pos),'E');
        set(anchor_text,'HorizontalAlignment','center');

        % Pantograph foot
        quiver(real(dpos)+2*real(cpos-dpos),imag(dpos)+2*imag(cpos-dpos),...
            -2*real(bpos-apos), -2*imag(bpos-apos),0,'r','linewidth',2);
        foot_text=text(real(foot_text_pos),imag(foot_text_pos),'F');
        set(foot_text,'HorizontalAlignment','center');

        grid on;
        axis([XMIN,XMAX,YMIN,YMAX]);
        daspect([1 1 1]);
        axis off;
    end

    foot_path_x=real(dpos)+2*real(cpos-dpos)-2*real(bpos-apos);
    foot_path_y=imag(dpos)+2*imag(cpos-dpos)-2*imag(bpos-apos);

end


function [t1,t2, t3, t4]=fourbar_plot_plus(a,b,c,d,BAP,APlen, t2,t3,t4,t1, clrs)

    % BAP and APlen is the angle it makes with the floating
    % link and the distance of the coupler link from the joint between
    % the crank and the floater 
    %
    % % example use:
    % a=40; b=60; c=30; d=55; t2=2*pi/3; t1=0;
    % [t3o, t3c, t4o, t4c, A, B, C]=fourbar_position(a, b, c, d, t2, t1); 
    % fourbar_plot(a, b, c, d, 0, 0, t2, t3o, t4o, t1, eye(3))

    % fourbar plot automatically adds ground orientation
    opos=0*exp(1i*t1);
    apos=a*exp(1i*t2);
    bpos=apos+b*exp(1i*t3);
    dpos=d*exp(1i*t1);
    cpos=dpos+c*exp(1i*t4);

    copos=apos+APlen*exp(1i*(t3+BAP));

    %text locations

    crank_text_pos=apos/2+10*exp(1i*(t2+pi/2));
    rocker_text_pos=dpos+c/2*exp(1i*t4)+10*exp(1i*(t4-pi/2));
    coupler_text_pos=apos+b/2*exp(1i*t3)+10*exp(1i*(t3-sign_P_rise*pi/2));
    P_text_pos=copos+13;
    ground_text_pos=dpos/2+10*exp(1i*(t1-pi/2));


    % draw it

    % ground
    plot(real(opos), imag(opos), 'ko', 'markersize', 6, 'linewidth', 1);
    hold on;
    plot(real(opos), imag(opos), 'ks', 'markersize', 10, 'linewidth', 2);

    % crank, link 2
    quiver(real(opos), imag(opos), ...
        real(apos-opos), imag(apos-opos), 0, 'color', clrs(1,:), ...
        'linewidth', 2);
    plot(real(apos), imag(apos), 'ko', 'markersize', 6, 'linewidth', 2);
    crank_text=text(real(crank_text_pos),imag(crank_text_pos),'A');
    set(crank_text,'HorizontalAlignment','center');

    % floating link
    quiver(real(apos), imag(apos), ...
        real(bpos-apos), imag(bpos-apos), 0, 'b', ...
        'linewidth', 2);
    plot(real(bpos), imag(bpos), 'ko', 'markersize', 6, 'linewidth', 2);
    coupler_text=text(real(coupler_text_pos),imag(coupler_text_pos),'B');
    set(coupler_text,'HorizontalAlignment','center');

    % coupler
    % quiver(real(apos), imag(apos), ...
    %     real(copos-apos), imag(copos-apos), 0, '.', 'color', clrs(3,:), ...
    %     'linewidth', 2);

    plot([real(apos) real(copos)], [imag(apos) imag(copos)], 'b','linewidth',2);

    plot([real(copos) real(bpos)], [imag(copos) imag(bpos)], 'b','linewidth',2);

    plot(real(copos),imag(copos),'ko','markersize',6,'linewidth',2);
    
    P_text=text(real(P_text_pos),imag(P_text_pos),'P');
    set(P_text,'HorizontalAlignment','center');


    % rocker/output
    quiver(real(dpos), imag(dpos), ...
        real(cpos-dpos), imag(cpos-dpos), 0, 'g', ...
        'linewidth', 2);
    rocker_text=text(real(rocker_text_pos),imag(rocker_text_pos),'C');
    set(rocker_text,'HorizontalAlignment','center');


    % ground
    plot(real(dpos), imag(dpos), 'ko', 'markersize', 6, 'linewidth', 1);
    plot(real(dpos), imag(dpos), 'ks', 'markersize', 10, 'linewidth', 2);
    quiver(real(opos), imag(opos), ...
        real(dpos-opos), imag(dpos-opos), 0, 'k', ...
        'linewidth', 1);
    ground_text=text(real(ground_text_pos),imag(ground_text_pos),'D');
    set(ground_text,'HorizontalAlignment','center');

    grid on;
    axis image;
    axis([-a, d+c, min(-a, -c), max(a,c)]);

    axis off;
end

function [I,M] = line_link_moment(square_weight,width,length)
I=1/12*width*square_weight*(width^2+length.^2).*length;
M=square_weight*width*length;
end







end
