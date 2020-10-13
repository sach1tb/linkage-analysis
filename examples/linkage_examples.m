function linkage_examples
addpath ../core
global ht linktype

linktype=1; % fourbar with 

figure(10); gcf; clf;
select_button=uicontrol('Parent',10,'Style','popupmenu','String',...
    {'fourbar (position analysis)';'pantograph'; 'jansen'; ...
    'crank-slider';},...
    'Units','normalized','Position',[0.125 0.875 0.2 0.1],'Visible','on');
% select_button=uicontrol('Parent',10,'Style','popupmenu','String',...
%     {'fourbar w/ coupler';'jansen';'pantograph'; ...
%     'fourbar w/ pantograph by A. Ward'; 'crank-slider'; ...
%     'inverted crank-slider'; ''; ''; ''; 'fourbar w/ coupler'},...
%     'Units','normalized','Position',[0.125 0.875 0.2 0.1],'Visible','on');
select_button.Callback = @select_linkage;

ax1=subplot(1,2,1); 
pos = get(ax1,'Position');
un = get(ax1,'Units');
delete(ax1)
ht = uitable('Units',un,'Position',pos);

% select the linkage
select_linkage(select_button);

% update the plot on right
% update_button=uicontrol('Parent',10,'Style','pushbutton','String','->',...
%     'Units','normalized','Position',[0.5 0.5 0.05 0.03],'Visible','on');
% update_button.Callback = @update_plot;
% 
% update_plot(update_button);

% analyze the linkage
analyze_button=uicontrol('Parent',10,'Style','pushbutton','String','Analyze',...
    'Units','normalized','Position',[0.8 0.9 0.1 0.05],'Visible','on');
analyze_button.Callback = @analyze;


function update_plot(src, event)
global ht linktype
subplot(1,2,2);
cla;
box on;

switch linktype   
  case 1
    [img, map, alphadata]=imread('../doc/fourbar.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;   
  case 2
    [img, map, alphadata]=imread('../doc/sylvester_pantograph.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;   
  case 3
    [img, map, alphadata]=imread('../doc/jansen.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;  
  case 4
    [img, map, alphadata]=imread('../doc/crankslider.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off; 
  case 10
    [img, map, alphadata]=imread('../doc/fourbar_w_pantograph_award.png');
    image(img, 'alphadata', alphadata);
    axis image;
    axis off;   
  otherwise
end 


function analyze(src, event)
global ht linktype

simTime=5; % seconds 
t=linspace(0,simTime, 100);

switch linktype   
  case 1 % fourbar
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    d=ht.Data{4,2};
    AP=ht.Data{5,2};
    BAP=ht.Data{6,2}*pi/180;
    cfg=ht.Data{7,2};
    w2=ht.Data{8,2};
    example01_position_analysis(a,b,c,d,AP,BAP,w2,cfg,simTime);
 case 10
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    d=ht.Data{4,2};
    AP=ht.Data{5,2};
    BAP=ht.Data{6,2}*pi/180;
    cfg=ht.Data{7,2};
    w2=ht.Data{8,2};
    a2=ht.Data{9,2};
    lnk_rho=ht.Data{10,2};
    lnk_width=ht.Data{11,2};
    lnk_thickness=ht.Data{12,2};
    rPA=ht.Data{13,2};
    fPAx=ht.Data{14,2};
    fPAy=ht.Data{15,2};
    example11b(a,b,c,d,AP,BAP,w2,a2, lnk_rho, lnk_width, lnk_thickness, ...
        rPA, fPAx, fPAy, cfg,simTime);    
  case 3
    za=ht.Data{1,2};
    wAZ=ht.Data{2,2};
    ab=ht.Data{3,2};
    by=ht.Data{4,2};
    zy=ht.Data{5,2};
    tZY=ht.Data{6,2}*pi/180;
    ac=ht.Data{7,2};
    yc=ht.Data{8,2};
    yd=ht.Data{9,2};
    bd=ht.Data{10,2};
    ce=ht.Data{11,2};
    de=ht.Data{12,2};
    ef=ht.Data{13,2};
    cf=ht.Data{14,2};

    example12_jansen(za, wAZ, ab, by, zy, tZY, ac, yc, yd, bd, ce, de, ef, cf)
  case 2
    az=ht.Data{1,2};
    ab=ht.Data{2,2};
    de=ht.Data{3,2};
    yz=ht.Data{4,2};
    wAZ=ht.Data{5,2};
    aAZ=ht.Data{6,2};
    example08_pantograph(az, ab, de, yz, wAZ, aAZ);  
  case 10
    za=ht.Data{1,2};
    ab=ht.Data{2,2};
    by=ht.Data{3,2};
    zy=ht.Data{4,2};
    ac=ht.Data{5,2};
    yc=ht.Data{6,2};
    yd=ht.Data{7,2};
    bd=ht.Data{8,2};
    ce=ht.Data{9,2};
    de=ht.Data{10,2};
    ef=ht.Data{11,2};
    cf=ht.Data{12,2};
    wAZ=ht.Data{1,3};
    example16_pantograph_with_fourbar(A,B,C, P_left_right, Floater_dots, ...
        P_rise, crank_length, rpm, ground_angle, crank_start_angle, ...
        pant_anchor_up, pant_hinge_offset, square_weight, link_width, ...
        foot_force);  
  case 4
    a=ht.Data{1,2};
    b=ht.Data{2,2};
    c=ht.Data{3,2};
    w2=ht.Data{4,2};
    cfg=ht.Data{5,2};
    example05_crank_slider(a,b,c,w2,cfg,simTime);     
  otherwise
end 



function select_linkage(src, event)
global linktype ht
linktype=get(src,'Value');
switch linktype   
  case 1

%     example01_position_analysis(a,b,c,d,APlen,BAP,w2,simTime);
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 1.36, 'm';
            'b', 10, 'm';
            'c', 10, 'm';
            'd', 15, 'm';
            'AP', 20, 'm';
            'BAP', 0, 'degrees';
            'config', 1, 'open=1';
            'omega2', -2, 'rad/s';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
  case 11

%     example01_position_analysis(a,b,c,d,APlen,BAP,w2,simTime);
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 0.86, 'm';
            'b', 1.85, 'm';
            'c', 0.86, 'm';
            'd', 2.22, 'm';
            'AP', 20, 'm';
            'BAP', 0, 'degrees';
            'config', 1, 'open=1';
            'omega2', -2, 'rad/s';
            'alpha2', 1, 'rad/s^2';
            'material density', 1190, 'kg/m^3';
            'link width', 0.013, 'm';
            'link thickness', 0.00475, 'm';
            'rPA', 1.33, 'm';
            'FPAx', 500, 'N';
            'FPAy', 0, 'N'};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];
  case 3
%     example12_jansen(za, ab, by, zy, ac, yc, yd, bd, ce, de, ef, cf, wAZ)
    ColumnName={'variable', 'value', 'units'};
%     ColumnName={'endpoints', 'length (m)', 'theta (rad)','omega (rad/s)',  ...
%             'alpha(rad/s^2)',  'mass (kg)',  ...
%             'moi(kgm^2)', 'torque(Nm)',  'force_x(Nm)', 'force_y(Nm)', 'rF(m)'};
    data={  'AZ', 15, 'm'; % crank
            'omegaAZ', 1, 'rad/s';
            'BA', 50, 'm';
            'BY',41.5,'m';
            'YZ',sqrt(38^2+7.8^2), 'm';
            'thetaYZ', 190, 'degrees'
            'AC',61.9, 'm';
            'YC',39.3, 'm';
            'YD',40.1,'m';
            'BD',55.8, 'm';
            'CE',36.7, 'm';
            'DE',39.4, 'm';
            'EF',65.7, 'm';
            'CF',49, 'm';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
    
case 2
        %     example08_pantograph(az, ab, de, yz, wAZ, aAZ)
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'az', 10, 'cm';
            'ab', 40, 'cm';
            'de', 40, 'cm';
            'yz', 54, 'cm';
            'omegaAZ', 1, 'rad/s';
            'alphaAZ', 0, 'rad/s^2';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];  
  case 10
%         example16_pantograph_with_fourbar(A,B,C, P_left_right, Floater_dots, ...
%         P_rise, crank_length, rpm, ground_angle, crank_start_angle, ...
%         pant_anchor_up, pant_hinge_offset, square_weight, link_width, ...
%         foot_force);
    ColumnName={'variable', 'value', 'units', 'description'};

    data={  'A (H&N)', 1.5, '', 'Scaled length of floater'; 
            'B (H&N)', 2.5, '', '';
            'C (H&N)', 2.5, '', '';
            'PLR',7,'', '# of dots from crank to coupler along horizontal';
            'FLD',6, '', '# of dots on floater';
            'PUD',1, '', '# of dots from crank to coupler along horizontal';
            'A',30, 'mm', '';
            'rpm',10, '', '';
            'theta1',30,'degrees', '';
            'BD',55.8, 'm';
            'CE',36.7, 'm';
            'DE',39.4, 'm';
            'EF',65.7, 'm';
            'CF',49, 'm';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false, false];  
  case 4

%     example05_crank_slider(a,b,c,w2,cfg, simTime);
    
    ColumnName={'variable', 'value', 'units'};
        
    data={  'a', 40, 'cm';
            'b', 120, 'cm';
            'c', 80, 'cm';
            'omega2', 1, 'rad/s';
            'config', 1, 'open=1';};
    ht.Data=data;
    ht.ColumnName=ColumnName;    
    ht.ColumnEditable = [false, true, false];       
  otherwise
end 




update_plot;